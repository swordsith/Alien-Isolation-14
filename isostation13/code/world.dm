
/*
	The initialization of the game happens roughly like this:

	1. All global variables are initialized (including the global_init instance).
	2. The map is initialized, and map objects are created.
	3. world/New() runs, creating the process scheduler (and the old master controller) and spawning their setup.
	4. processScheduler/setup() runs, creating all the processes. game_controller/setup() runs, calling initialize() on all movable atoms in the world.
	5. The gameticker is created.

*/
var/global/datum/global_init/init = new ()

/*
	Pre-map initialization stuff should go here.
*/
/datum/global_init/New()
	generate_gameid()

	makeDatumRefLists()
	load_configuration()

	initialize_chemical_reagents()
	initialize_chemical_reactions()

	qdel(src) //we're done

/datum/global_init/Destroy()
	return TRUE

/var/game_id = null
/proc/generate_gameid()
	if(game_id != null)
		return
	game_id = ""

	var/list/c = list("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	var/l = c.len

	var/t = world.timeofday
	for(var/_ = 1 to 4)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)
	game_id = "-[game_id]"
	t = round(world.realtime / (10 * 60 * 60 * 24))
	for(var/_ = 1 to 3)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)


/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session
	hub = "Exadv1.spacestation13"
	hub_password = "kMZy3U5jJHSiBQjr"
	name = "Alien Isolation 13"
	status = ""//might be necessary
//	status = "<br><font size = 100><span style = \"color:purple\">ALIEN ISOLATION 13(<a href = \"https://discord.gg/rpxvmMW\">DISCORD</a>)</span></font>"
//	update_status() //disabled for now, re-enable it to change this shit automatically

#define RECOMMENDED_VERSION 509
/world/New()
	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	diary << "[log_end]\n[log_end]\nStarting up. (ID: [game_id]) [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND"

	config.post_load()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	if(config && config.log_runtime)
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	callHook("startup")
	//Emergency Fix
	load_mods()
	//end-emergency fix

	update_status()

	. = ..()

#ifndef UNIT_TEST

	sleep_offline = 1

#else
	log_unit_test("Unit Tests Enabled.  This will destroy the world when testing is complete.")
	load_unit_test_changes()
#endif

	// Set up roundstart seed list.
	plant_controller = new()

	// This is kinda important. Set up details of what the hell things are made of.
	populate_material_list()

	if(config.generate_asteroid)
		// These values determine the specific area that the map is applied to.
		// Because we do not use Bay's default map, we check the config file to see if custom parameters are needed, so we need to avoid hardcoding.
		if(config.asteroid_z_levels)
			for(var/z_level in config.asteroid_z_levels)
				// In case we got fed a string instead of a number...
				z_level = text2num(z_level)
				if(!isnum(z_level))
					// If it's still not a number, we probably got fed some nonsense string.
					admin_notice("<span class='danger'>Error: ASTEROID_Z_LEVELS config wasn't given a number.</span>")
				// Now for the actual map generating.  This occurs for every z-level defined in the config.
				new /datum/random_map/automata/cave_system(null,1,1,z_level,300,300)
				// Let's add ore too.
				new /datum/random_map/noise/ore(null, 1, 1, z_level, 64, 64)
		else
			admin_notice("<span class='danger'>Error: No asteroid z-levels defined in config!</span>")
		// Update all turfs to ensure everything looks good post-generation. Yes,
		// it's brute-forcey, but frankly the alternative is a mine turf rewrite.
		for(var/turf/simulated/mineral/M in world) // Ugh.
			M.updateMineralOverlays()
		for(var/turf/simulated/floor/asteroid/M in world) // Uuuuuugh.
			M.updateMineralOverlays()

	// Create autolathe recipes, as above.
	populate_lathe_recipes()

	// Create robolimbs for chargen.
	populate_robolimb_list()

	processScheduler = new
	master_controller = new /datum/controller/game_controller()
	spawn(1)
		processScheduler.deferSetupFor(/datum/controller/process/ticker)
		processScheduler.setup()
		master_controller.setup()
#ifdef UNIT_TEST
		initialize_unit_tests()
#endif



	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()

#undef RECOMMENDED_VERSION

	return

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/world/Topic(T, addr, master, key)
	diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key][log_end]"

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (copytext(T,1,7) == "status")
		var/input[] = params2list(T)
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config.abandon_allowed
		s["enter"] = config.enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null

		// This is dumb, but spacestation13.com's banners break if player count isn't the 8th field of the reply, so... this has to go here.
		s["players"] = 0
		s["stationtime"] = stationtime2text()
		s["roundduration"] = roundduration2text()

		if(input["status"] == "2")
			var/list/players = list()
			var/list/admins = list()

			for(var/client/C in clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue
					admins[C.key] = C.holder.rank
				players += C.key

			s["players"] = players.len
			s["playerlist"] = list2params(players)
			s["admins"] = admins.len
			s["adminlist"] = list2params(admins)
		else
			var/n = 0
			var/admins = 0

			for(var/client/C in clients)
				if(C.holder)
					if(C.holder.fakekey)
						continue	//so stealthmins aren't revealed by the hub
					admins++
				s["player[n]"] = C.key
				n++

			s["players"] = n
			s["admins"] = admins

		return list2params(s)

	else if(T == "manifest")
		var/list/positions = list()
		var/list/set_names = list(
				"heads" = command_positions,
				"sec" = security_positions,
				"eng" = engineering_positions,
				"med" = medical_positions,
				"sci" = science_positions,
				"car" = cargo_positions,
				"civ" = civilian_positions,
				"bot" = nonhuman_positions
			)

		for(var/datum/data/record/t in data_core.general)
			var/name = t.fields["name"]
			var/rank = t.fields["rank"]
			var/real_rank = make_list_rank(t.fields["real_rank"])

			var/department = 0
			for(var/k in set_names)
				if(real_rank in set_names[k])
					if(!positions[k])
						positions[k] = list()
					positions[k][name] = rank
					department = 1
			if(!department)
				if(!positions["misc"])
					positions["misc"] = list()
				positions["misc"][name] = rank

		for(var/k in positions)
			positions[k] = list2params(positions[k]) // converts positions["heads"] = list("Bob"="Captain", "Bill"="CMO") into positions["heads"] = "Bob=Captain&Bill=CMO"

		return list2params(positions)

	else if(T == "revision")
		if(revdata.revision)
			return list2params(list(branch = revdata.branch, date = revdata.date, revision = revdata.revision))
		else
			return "unknown"

	else if(copytext(T,1,5) == "info")
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

		var/list/search = params2list(input["info"])
		var/list/ckeysearch = list()
		for(var/text in search)
			ckeysearch += ckey(text)

		var/list/match = list()

		for(var/mob/M in mob_list)
			var/strings = list(M.name, M.ckey)
			if(M.mind)
				strings += M.mind.assigned_role
				strings += M.mind.special_role
			for(var/text in strings)
				if(ckey(text) in ckeysearch)
					match[M] += 10 // an exact match is far better than a partial one
				else
					for(var/searchstr in search)
						if(findtext(text, searchstr))
							match[M] += 1

		var/maxstrength = 0
		for(var/mob/M in match)
			maxstrength = max(match[M], maxstrength)
		for(var/mob/M in match)
			if(match[M] < maxstrength)
				match -= M

		if(!match.len)
			return "No matches"
		else if(match.len == 1)
			var/mob/M = match[1]
			var/info = list()
			info["key"] = M.key
			info["name"] = M.name == M.real_name ? M.name : "[M.name] ([M.real_name])"
			info["role"] = M.mind ? (M.mind.assigned_role ? M.mind.assigned_role : "No role") : "No mind"
			var/turf/MT = get_turf(M)
			info["loc"] = M.loc ? "[M.loc]" : "null"
			info["turf"] = MT ? "[MT] @ [MT.x], [MT.y], [MT.z]" : "null"
			info["area"] = MT ? "[MT.loc]" : "null"
			info["antag"] = M.mind ? (M.mind.special_role ? M.mind.special_role : "Not antag") : "No mind"
			info["hasbeenrev"] = M.mind ? M.mind.has_been_rev : "No mind"
			info["stat"] = M.stat
			info["type"] = M.type
			if(istype(M, /mob/living))
				var/mob/living/L = M
				info["damage"] = list2params(list(
							oxy = L.getOxyLoss(),
							tox = L.getToxLoss(),
							fire = L.getFireLoss(),
							brute = L.getBruteLoss(),
							clone = L.getCloneLoss(),
							brain = L.getBrainLoss()
						))
			else
				info["damage"] = "non-living"
			info["gender"] = M.gender
			return list2params(info)
		else
			var/list/ret = list()
			for(var/mob/M in match)
				ret[M.key] = M.name
			return list2params(ret)

	else if(copytext(T,1,9) == "adminmsg")
		/*
			We got an adminmsg from IRC bot lets split the input then validate the input.
			expected output:
				1. adminmsg = ckey of person the message is to
				2. msg = contents of message, parems2list requires
				3. validatationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
				4. sender = the ircnick that send the message.
		*/


		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr

			return "Bad Key"

		var/client/C
		var/req_ckey = ckey(input["adminmsg"])

		for(var/client/K in clients)
			if(K.ckey == req_ckey)
				C = K
				break
		if(!C)
			return "No client with that name on server"

		var/rank = input["rank"]
		if(!rank)
			rank = "Admin"

		var/message =	"<font color='red'>IRC-[rank] PM from <b><a href='?irc_msg=[input["sender"]]'>IRC-[input["sender"]]</a></b>: [input["msg"]]</font>"
		var/amessage =  "<font color='blue'>IRC-[rank] PM from <a href='?irc_msg=[input["sender"]]'>IRC-[input["sender"]]</a> to <b>[key_name(C)]</b> : [input["msg"]]</font>"

		C.received_irc_pm = world.time
		C.irc_admin = input["sender"]

		C << 'sound/effects/adminhelp.ogg'
		C << message


		for(var/client/A in admins)
			if(A != C)
				A << amessage

		return "Message Successful"

	else if(copytext(T,1,6) == "notes")
		/*
			We got a request for notes from the IRC Bot
			expected output:
				1. notes = ckey of person the notes lookup is for
				2. validationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
		*/
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr
			return "Bad Key"

		return show_player_info_irc(ckey(input["notes"]))

	else if(copytext(T,1,4) == "age")
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)
				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr
			return "Bad Key"

		var/age = get_player_age(input["age"])
		if(isnum(age))
			if(age >= 0)
				return "[age]"
			else
				return "Ckey not found"
		else
			return "Database connection failed or not set up"


/world/Reboot(var/reason)
	/*spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy
		*/

	processScheduler.stop()

	for(var/client/C in clients)
		if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")

	..(reason)

/hook/startup/proc/loadMode()
	world.load_mode()
	return TRUE

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			log_misc("Saved mode is '[master_mode]'")

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode


/hook/startup/proc/loadMOTD()
	world.load_motd()
	return TRUE

/world/proc/load_motd()
	join_motd = russian_to_cp1251(file2text("config/motd.txt"))


/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.loadsql("config/dbconfig.txt")
	config.loadforumsql("config/forumdbconfig.txt")

/hook/startup/proc/loadMods()
	world.load_mods()
	world.load_mentors() // no need to write another hook.
	return TRUE

/world/proc/load_mods()
	if(config.admin_legacy_system)
		var/text = file2text("config/moderators.txt")
		if (!text)
			error("Failed to load config/mods.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Moderator"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(directory[ckey])

/world/proc/load_mentors()
	if(config.admin_legacy_system)
		var/text = file2text("config/mentors.txt")
		if (!text)
			error("Failed to load config/mentors.txt")
		else
			var/list/lines = splittext(text, "\n")
			for(var/line in lines)
				if (!line)
					continue
				if (copytext(line, 1, 2) == ";")
					continue

				var/title = "Mentor"
				var/rights = admin_ranks[title]

				var/ckey = copytext(line, 1, length(line)+1)
				var/datum/admins/D = new /datum/admins(title, rights, ckey)
				D.associate(directory[ckey])

/world/proc/update_status()

	var/s = "<b><font size = 3><span style = \"color:purple\"><i>Alien Isolation 13</i></span></font></b> &#8212; "
//	var/s = ""

//	if (config && config.server_name)
	//	s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"https://discord.gg/CTDTEjW\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Discord"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += "/"
	s += "<a href=\"https://github.com/Cherkir/Alien-Isolation-13\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Github"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if(ticker)
		if(master_mode)
			features += master_mode
	else
		features += "<b>STARTING</b>"
/*
	if (!config.enter_allowed)
		features += "closed"

	features += config.abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"


	if (config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"*/
 //apparently the hub fucks up with too much html and stuff so I'm removing this.
	if (features)
		s += features
	//	s += ": [jointext(features, ", ")]"

	/* does this help? I do not know */
	if (status != s)
		status = s


#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0
var/failed_old_db_connections = 0

/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."
	return TRUE

proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return FALSE

	if(!dbcon)
		dbcon = new()

	var/user = sqlfdbklogin
	var/pass = sqlfdbkpass
	var/db = sqlfdbkdb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return FALSE

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return TRUE


/hook/startup/proc/connectOldDB()
	if(!setup_old_database_connection())
		world.log << "Your server failed to establish a connection with the SQL database."
	else
		world.log << "SQL database connection established."
	return TRUE

//These two procs are for the old database, while it's being phased out. See the tgstation.sql file in the SQL folder for more information.
proc/setup_old_database_connection()

	if(failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return FALSE

	if(!dbcon_old)
		dbcon_old = new()

	var/user = sqllogin
	var/pass = sqlpass
	var/db = sqldb
	var/address = sqladdress
	var/port = sqlport

	dbcon_old.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon_old.IsConnected()
	if ( . )
		failed_old_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_old_db_connections++		//If it failed, increase the failed connections counter.
		world.log << dbcon.ErrorMsg()

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_old_db_connection()
	if(failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return FALSE

	if(!dbcon_old || !dbcon_old.IsConnected())
		return setup_old_database_connection()
	else
		return TRUE

#undef FAILED_DB_CONNECTION_CUTOFF
