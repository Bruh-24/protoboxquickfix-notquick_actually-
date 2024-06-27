// IF you have linked your account, this will trigger a verify of the user
/client/verb/verify_in_discord()
	set category = "OOC"
	set name = "Verify Discord Account"
	set desc = "Verify your discord account with your BYOND account"

	// Safety checks
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("This feature requires the SQL backend to be running."))
		return

	// Why this would ever be unset, who knows
	// var/prefix = CONFIG_GET(string/discordbotcommandprefix) - MASSMETA DELETION
	// if(!prefix)
	// 	to_chat(src, span_warning("This feature is disabled."))

	if(!SSdiscord || !SSdiscord.reverify_cache)
		to_chat(src, span_warning("Wait for the Discord subsystem to finish initialising"))
		return
	var/message = ""
	// Simple sanity check to prevent a user doing this too often
	var/cached_one_time_token = SSdiscord.reverify_cache[usr.ckey]
	if(cached_one_time_token && cached_one_time_token != "")
		message = "Вы уже сгенерировали свой одноразовый токен - [cached_one_time_token]. Если вам нужен новый - дождитесь окончания раунда; попробуйте верифицироваться, перейдя в канал #верефикация, нажав кнопку, а затем: <span class='code user-select'>[cached_one_time_token]</span> ввести в поле этот токен." //MASSMETA EDIT


	else
		// Will generate one if an expired one doesn't exist already, otherwise will grab existing token
		var/one_time_token = SSdiscord.get_or_generate_one_time_token_for_ckey(ckey)
		SSdiscord.reverify_cache[usr.ckey] = one_time_token
		message = "Ваш одноразовый токен: [one_time_token] Теперь вы можете пройти верификацию, перейдя в канал #верификация в дискорде, нажав кнопку и указав там данный токен: <span class='code user-select'>[one_time_token]</span>" //MASSMETA EDIT

	//Now give them a browse window so they can't miss whatever we told them
	var/datum/browser/window = new/datum/browser(usr, "discordverification", "Discord Verification")
	window.set_content("<div>[message]</div>")
	window.open()
