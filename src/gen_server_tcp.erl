-module(gen_server_tcp).
-behaviour(gen_server).

-export([behaviour_info/1]).

-export([start/3,
         start/4,
         start_link/3,
         start_link/4,
         call/2,
         call/3,
         multicall/2,
         multicall/3,
         multicall/4,
         cast/2,
         cast/3,
         abcast/2,
         abcast/3,
         reply/2]).

-export([init/1,
         loop/3,
         handle_accept/2,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         terminate/2,
         code_change/3]).

-record(server_state,
        {port,
         module,
         module_state,
         packet_handler,
         fsm}).

behaviour_info(callbacks) ->
    [{init, 1},
     {handle_call, 3},
     {handle_cast, 2},
     {handle_info, 2},
     {terminate, 2},
     {code_change, 3}].



start_link(Name, Module, InitArgs, Options) ->
    gen_server:start_link(Name, ?MODULE, [{'__gen_server_tcp_mod', Module} | InitArgs], Options).
start_link(Module, InitArgs, Options) ->
    gen_server:start_link(?MODULE, [{'__gen_server_tcp_mod', Module} | InitArgs], Options).

start(Name, Module, InitArgs, Options) ->
    gen_server:start(Name, ?MODULE, [{'__gen_server_tcp_mod', Module} | InitArgs], Options).

start(Module, InitArgs, Options) ->
    gen_server:start(?MODULE, [{'__gen_server_tcp_mod', Module} | InitArgs], Options).

call(ServerRef, Request) ->
    gen_server:call(ServerRef, Request).
call(ServerRef, Request, Timeout) ->
    gen_server:call(ServerRef, Request, Timeout).

multicall(Name, Request) ->
    gen_server:multicall(Name, Request).
multicall(Nodes, Name, Request) ->
    gen_server:multicall(Nodes, Name, Request).

multicall(Nodes, Name, Request, Timeout) ->
    gen_server:multicall(Nodes, Name, Request, Timeout).

cast(ServerRef, Request) ->
    gen_server:cast(ServerRef, Request).
cast(ServerRef, Request, Timeout) ->
    gen_server:cast(ServerRef, Request, Timeout).

abcast(Name, Request) ->
    gen_server:abcast(Name, Request).
abcast(Nodes, Name, Request) ->
    gen_server:abcast(Nodes, Name, Request).

reply(Client, Reply) ->
    gen_server:reply(Client, Reply).

loop(Socket, FSM, PacketHandler) ->
    ok = inet:setopts(Socket, [{active, once}]),
    receive
        {tcp, Socket, Packet} ->
            log:debug("Received packet.", [{packet, Packet}]),

            Event = PacketHandler:unpack(Packet),
            gen_fsm:send_event(FSM, Event),
            ?MODULE:loop(Socket, FSM, PacketHandler);

        {tcp_closed, Socket} ->
            log:info("Client disconnected."),
            gen_fsm:send_event(FSM, stop);

        {Header, Data} ->
            log:debug("Sending data.", [{data, Data}]),

            gen_tcp:send(Socket, PacketHandler:pack(Header, Data)),
            ?MODULE:loop(Socket, FSM, PacketHandler);

        Packet when is_binary(Packet) ->
            log:debug("Sending raw packet.", [{packet, Packet}]),

            gen_tcp:send(Socket, Packet),
            ?MODULE:loop(Socket, FSM, PacketHandler)
    end.

% gen_listener_tcp callbacks

handle_accept(Sock, #server_state{packet_handler = PacketHandler} = St) ->
    log:info("Client connected.", [{client, element(2, inet:peername(Sock))}]),

    Pid = spawn(fun() ->
                    {ok, FSM} = supervisor:start_child(client_sup, [self()]),
                    loop(Sock, FSM, PacketHandler)
                end),
    gen_tcp:controlling_process(Sock, Pid),
    {noreply, St}.


% gen_server callbacks

init([{'__gen_server_tcp_mod', Module} | InitArgs]) ->
    process_flag(trap_exit, true),

    log:debug("Starting generic TCP server.", [{module, Module}]),

    case Module:init(InitArgs) of
        {ok, {Port, FSM, PacketHandler}, ModState} ->
            St = #server_state{port = Port,
                               module = Module,
                               module_state = ModState,
                               fsm = FSM,
                               packet_handler = PacketHandler},

            supervisor:start_link(?MODULE,
                                  {all, St}),

            {ok, St};
        ignore ->
            ignore;
        {stop, Reason} ->
            {stop, Reason};
        Other ->
            {stop, Other}
    end;
init({all, #server_state{fsm = FSM} = St}) ->
    {ok, {{one_for_one, 100000, 60},
          [{listener,
            {gen_listener_tcp,
             start_link,
             [{local, listener},
              ?MODULE,
              {listener, St},
              []]},
            permanent,
            1000,
            worker,
            []},
           {client_sup,
            {supervisor,
             start_link,
             [{local, client_sup},
              ?MODULE,
              {clients, FSM}]},
            permanent,
            infinity,
            supervisor,
            []}]}};
init({listener, #server_state{port = Port} = St}) ->
    {ok, {Port, [binary, {packet, raw}, {active, false}]}, St};
init({clients, FSM}) ->
    {ok, {{simple_one_for_one, 2, 60},
          [{undefined,
            {FSM, start_link, []},
            temporary,
            301000, % FSMs wait <=5 mins for a signal to keep the login IDs.
            worker,
            []}]}}.

handle_call(Request, From, #server_state{module = Module, module_state = ModState} = St) ->
    case Module:handle_call(Request, From, ModState) of
        {reply, Reply, NewModState} ->
            {reply, Reply, St#server_state{module_state = NewModState}};
        {reply, Reply, NewModState, hibernate} ->
            {reply, Reply, St#server_state{module_state = NewModState}, hibernate};
        {reply, Reply, NewModState, Timeout} ->
            {reply, Reply, St#server_state{module_state = NewModState}, Timeout};
        {noreply, NewModState} ->
            {noreply, St#server_state{module_state = NewModState}};
        {noreply, NewModState, hibernate} ->
            {noreply, St#server_state{module_state = NewModState}, hibernate};
        {noreply, NewModState, Timeout} ->
            {noreply, St#server_state{module_state = NewModState}, Timeout};
        {stop, Reason, NewModState} ->
            {stop, Reason, St#server_state{module_state = NewModState}};
        {stop, Reason, Reply, NewModState} ->
            {stop, Reason, Reply, St#server_state{module_state = NewModState}}
    end.

handle_cast(Request, #server_state{module = Module, module_state = ModState}=St) ->
    case Module:handle_cast(Request, ModState) of
        {noreply, NewModState} ->
            {noreply, St#server_state{module_state = NewModState}};
        {noreply, NewModState, hibernate} ->
            {noreply, St#server_state{module_state = NewModState}, hibernate};
        {noreply, NewModState, Timeout} ->
            {noreply, St#server_state{module_state = NewModState}, Timeout};
        {stop, Reason, NewModState} ->
            {stop, Reason, St#server_state{module_state = NewModState}}
    end.


handle_info(Info, #server_state{module = Module, module_state = ModState}=St) ->
    case Module:handle_info(Info, ModState) of
        {noreply, NewModState} ->
            {noreply, St#server_state{module_state = NewModState}};
        {noreply, NewModState, hibernate} ->
            {noreply, St#server_state{module_state = NewModState}, hibernate};
        {noreply, NewModState, Timeout} ->
            {noreply, St#server_state{module_state = NewModState}, Timeout};
        {stop, Reason, NewModState} ->
            {stop, Reason, St#server_state{module_state = NewModState}}
    end.

terminate(Reason, #server_state{module = Module, module_state = ModState}) ->
    log:debug("Generic TCP server terminating.", [{module, Module}, {reason, Reason}]),
    Module:terminate(Reason, ModState).

code_change(OldVsn, #server_state{module = Module, module_state = ModState}=St, Extra) ->
    {ok, NewModState} = Module:code_change(OldVsn, ModState, Extra),
    {ok, St#server_state{module_state = NewModState}}.