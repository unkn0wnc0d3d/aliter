-record(ids, {key, id}).
-record(char, {id, num, name, job, base_level, base_exp, job_level, job_exp, zeny, str, agi, vit, int, dex, luk, max_hp, hp, max_sp, sp, status_points, skill_points, hair_style, hair_colour, clothes_colour, view_weapon, view_shield, view_head_top, view_head_middle, view_head_bottom, map, x, y, save_map, save_x, save_y, online, fame, guild_position, guild_taxed, account_id, party_id, guild_id, pet_id, homunculus_id, mercenary_id}).
-record(account, {id, login, password, email, gender, login_count, last_login, last_ip, gm_level, ban_until}).
-record(apiresponse, {msg, info, account, char}).
-record(apirequest, {key, node, add_account, get_account, delete_account, update_account, add_char, get_char, delete_char, update_char}).