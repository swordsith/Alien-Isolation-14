/mob/living/silicon
	gender = NEUTER
	voice_name = "synthesized voice"
	var/syndicate = 0
	var/const/MAIN_CHANNEL = "Main Frequency"
	var/lawchannel = MAIN_CHANNEL // Default channel on which to state laws
	var/list/stating_laws = list()// Channels laws are currently being stated on
	var/obj/item/device/radio/common_radio

	var/list/hud_list[10]
	var/list/speech_synthesizer_langs = list()	//which languages can be vocalized by the speech synthesizer

	//Used in say.dm.
	var/speak_statement = "states"
	var/speak_exclamation = "declares"
	var/speak_query = "queries"
	var/pose //Yes, now AIs can pose too.
	var/obj/item/device/camera/siliconcam/aiCamera = null //photography
	var/local_transmit //If set, can only speak to others of the same type within a short range.

	var/sensor_mode = 0 //Determines the current HUD.

	var/next_alarm_notice
	var/list/datum/alarm/queued_alarms = new()

	var/list/access_rights
	var/obj/item/weapon/card/id/idcard
	var/idcard_type = /obj/item/weapon/card/id/synthetic

	#define SEC_HUD 1 //Security HUD mode
	#define MED_HUD 2 //Medical HUD mode

/mob/living/silicon/New()
	silicon_mob_list |= src
	..()
	add_language("Galactic Common")
	init_id()
	init_subsystems()

/mob/living/silicon/Destroy()
	silicon_mob_list -= src
	for(var/datum/alarm_handler/AH in alarm_manager.all_handlers)
		AH.unregister_alarm(src)
	..()

/mob/living/silicon/proc/init_id()
	if(idcard)
		return
	idcard = new idcard_type(src)
	set_id_info(idcard)

/mob/living/silicon/proc/SetName(pickedName as text)
	real_name = pickedName
	name = real_name

/mob/living/silicon/proc/show_laws()
	return

/mob/living/silicon/drop_item()
	return

/mob/living/silicon/emp_act(severity)
	switch(severity)
		if(1)
			src.take_organ_damage(0,20,emp=1)
			Stun(rand(5,10))
		if(2)
			src.take_organ_damage(0,10,emp=1)
			confused = (min(confused + 2, 30))
//	flick("noise", src.flash)
	if (HUDtech.Find("flash"))
		flick("noise", HUDtech["flash"])
	src << "<span class='danger'><B>*BZZZT*</B></span>"
	src << "<span class='danger'>Warning: Electromagnetic pulse detected.</span>"
	..()

/mob/living/silicon/stun_effect_act(var/stun_amount, var/agony_amount)
	return	//immune

/mob/living/silicon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0)

	if (istype(source, /obj/machinery/containment_field))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, loc)
		s.start()

		shock_damage *= 0.75	//take reduced damage
		take_overall_damage(0, shock_damage)
		visible_message("\red [src] was shocked by \the [source]!", \
			"\red <B>Energy pulse detected, system damaged!</B>", \
			"\red You hear an electrical crack")
		if(prob(20))
			Stun(2)
		return

/mob/living/silicon/proc/damage_mob(var/brute = 0, var/fire = 0, var/tox = 0)
	return

/mob/living/silicon/IsAdvancedToolUser()
	return TRUE

/mob/living/silicon/bullet_act(var/obj/item/projectile/Proj)

	if(!Proj.nodamage)
		switch(Proj.damage_type)
			if(BRUTE)
				adjustBruteLoss(Proj.damage)
			if(BURN)
				adjustFireLoss(Proj.damage)

	Proj.on_hit(src,2)
	updatehealth()
	return 2

/mob/living/silicon/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	return FALSE//The only effect that can hit them atm is flashes and they still directly edit so this works for now
/*
	if(!effect || (blocked >= 2))	return FALSE
	switch(effecttype)
		if(STUN)
			stunned = max(stunned,(effect/(blocked+1)))
		if(WEAKEN)
			weakened = max(weakened,(effect/(blocked+1)))
		if(PARALYZE)
			paralysis = max(paralysis,(effect/(blocked+1)))
		if(IRRADIATE)
			radiation += min((effect - (effect*getarmor(null, "rad"))), 0)//Rads auto check armor
		if(STUTTER)
			stuttering = max(stuttering,(effect/(blocked+1)))
		if(EYE_BLUR)
			eye_blurry = max(eye_blurry,(effect/(blocked+1)))
		if(DROWSY)
			drowsyness = max(drowsyness,(effect/(blocked+1)))
	updatehealth()
	return TRUE*/

/proc/islinked(var/mob/living/silicon/robot/bot, var/mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return FALSE
	if (bot.connected_ai == ai)
		return TRUE
	return FALSE


// this function shows the health of the AI in the Status panel
/mob/living/silicon/proc/show_system_integrity()
	if(!src.stat)
		stat(null, text("System integrity: [round((health/maxHealth)*100)]%"))
	else
		stat(null, text("Systems nonfunctional"))


// This is a pure virtual function, it should be overwritten by all subclasses
/mob/living/silicon/proc/show_malf_ai()
	return FALSE

// this function displays the shuttles ETA in the status panel if the shuttle has been called
/mob/living/silicon/proc/show_emergency_shuttle_eta()
	if(emergency_shuttle)
		var/eta_status = emergency_shuttle.get_status_panel_eta()
		if(eta_status)
			stat(null, eta_status)


// This adds the basic clock, shuttle recall timer, and malf_ai info to all silicon lifeforms
/mob/living/silicon/Stat()
	if(statpanel("Status"))
		show_emergency_shuttle_eta()
		show_system_integrity()
		show_malf_ai()
	. = ..()

// this function displays the stations manifest in a separate window
/mob/living/silicon/proc/show_station_manifest()
	var/dat
	dat += "<h4>Crew Manifest</h4>"
	if(data_core)
		dat += data_core.get_manifest(1) // make it monochrome
	dat += "<br>"
	src << browse(dat, "window=airoster")
	onclose(src, "airoster")

//can't inject synths
/mob/living/silicon/can_inject(var/mob/user, var/error_msg)
	if(error_msg)
		user << "<span class='alert'>The armoured plating is too tough.</span>"
	return FALSE


//Silicon mob language procs

/mob/living/silicon/can_speak(datum/language/speaking)
	return universal_speak || (speaking in src.speech_synthesizer_langs)	//need speech synthesizer support to vocalize a language

/mob/living/silicon/add_language(var/language, var/can_speak=1)
	var/var/datum/language/added_language = all_languages[language]
	if(!added_language)
		return

	. = ..(language)
	if (can_speak && (added_language in languages) && !(added_language in speech_synthesizer_langs))
		speech_synthesizer_langs += added_language
		return TRUE

/mob/living/silicon/remove_language(var/rem_language)
	var/var/datum/language/removed_language = all_languages[rem_language]
	if(!removed_language)
		return

	..(rem_language)
	speech_synthesizer_langs -= removed_language

/mob/living/silicon/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat = "<b><font size = 5>Known Languages</font></b><br/><br/>"

	if(default_language)
		dat += "Current default language: [default_language] - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a><br/><br/>"

	for(var/datum/language/L in languages)
		if(!(L.flags & NONGLOBAL))
			var/default_str
			if(L == default_language)
				default_str = " - default - <a href='byond://?src=\ref[src];default_lang=reset'>reset</a>"
			else
				default_str = " - <a href='byond://?src=\ref[src];default_lang=\ref[L]'>set default</a>"

			var/synth = (L in speech_synthesizer_langs)
			dat += "<b>[L.name] ([get_language_prefix()][L.key])</b>[synth ? default_str : null]<br/>Speech Synthesizer: <i>[synth ? "YES" : "NOT SUPPORTED"]</i><br/>[L.desc]<br/><br/>"

	src << browse(dat, "window=checklanguage")
	return

/mob/living/silicon/proc/toggle_sensor_mode()
	var/sensor_type = input("Please select sensor type.", "Sensor Integration", null) in list("Security", "Medical","Disable")
	switch(sensor_type)
		if ("Security")
			sensor_mode = SEC_HUD
			src << "<span class='notice'>Security records overlay enabled.</span>"
		if ("Medical")
			sensor_mode = MED_HUD
			src << "<span class='notice'>Life signs monitor overlay enabled.</span>"
		if ("Disable")
			sensor_mode = 0
			src << "Sensor augmentations disabled."

/mob/living/silicon/verb/pose()
	set name = "Set Pose"
	set desc = "Sets a description which will be shown when someone examines you."
	set category = "IC"

	pose =  sanitize(input(usr, "This is [src]. It is...", "Pose", null)  as text)

/mob/living/silicon/verb/set_flavor()
	set name = "Set Flavour Text"
	set desc = "Sets an extended description of your character's features."
	set category = "IC"

	flavor_text =  sanitize(input(usr, "Please enter your new flavour text.", "Flavour text", null)  as text)

/mob/living/silicon/binarycheck()
	return TRUE

/mob/living/silicon/ex_act(severity)
	if(!blinded)
		if (HUDtech.Find("flash"))
			flick("flash", HUDtech["flash"])

	switch(severity)
		if(1.0)
			if (stat != 2)
				adjustBruteLoss(100)
				adjustFireLoss(100)
				if(!anchored)
					gib()
		if(2.0)
			if (stat != 2)
				adjustBruteLoss(60)
				adjustFireLoss(60)
		if(3.0)
			if (stat != 2)
				adjustBruteLoss(30)

	updatehealth()

/mob/living/silicon/proc/receive_alarm(var/datum/alarm_handler/alarm_handler, var/datum/alarm/alarm, was_raised)
	if(!next_alarm_notice)
		next_alarm_notice = world.time + SecondsToTicks(10)

	var/list/alarms = queued_alarms[alarm_handler]
	if(was_raised)
		// Raised alarms are always set
		alarms[alarm] = 1
	else
		// Alarms that were raised but then cleared before the next notice are instead removed
		if(alarm in alarms)
			alarms -= alarm
		// And alarms that have only been cleared thus far are set as such
		else
			alarms[alarm] = -1

/mob/living/silicon/proc/process_queued_alarms()
	if(next_alarm_notice && (world.time > next_alarm_notice))
		next_alarm_notice = 0

		var/alarm_raised = 0
		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == 1)
					alarm_raised = 1
					if(!reported)
						reported = 1
						src << "<span class='warning'>--- [AH.category] Detected ---</span>"
					raised_alarm(A)

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			var/reported = 0
			for(var/datum/alarm/A in alarms)
				if(alarms[A] == -1)
					if(!reported)
						reported = 1
						src << "<span class='notice'>--- [AH.category] Cleared ---</span>"
					src << "\The [A.alarm_name()]."

		if(alarm_raised)
			src << "<A HREF=?src=\ref[src];showalerts=1>\[Show Alerts\]</A>"

		for(var/datum/alarm_handler/AH in queued_alarms)
			var/list/alarms = queued_alarms[AH]
			alarms.Cut()

/mob/living/silicon/proc/raised_alarm(var/datum/alarm/A)
	src << "[A.alarm_name()]!"

/mob/living/silicon/ai/raised_alarm(var/datum/alarm/A)
	var/cameratext = ""
	for(var/obj/machinery/camera/C in A.cameras())
		cameratext += "[(cameratext == "")? "" : "|"]<A HREF=?src=\ref[src];switchcamera=\ref[C]>[C.c_tag]</A>"
	src << "[A.alarm_name()]! ([(cameratext)? cameratext : "No Camera"])"


/mob/living/silicon/proc/is_traitor()
	return mind && (mind in traitors.current_antagonists)

/mob/living/silicon/proc/is_malf()
	return mind && (mind in malf.current_antagonists)

/mob/living/silicon/proc/is_malf_or_traitor()
	return is_traitor() || is_malf()

/mob/living/silicon/adjustEarDamage()
	return

/mob/living/silicon/setEarDamage()
	return

/mob/living/silicon/reset_view()
	..()
	if(cameraFollow)
		cameraFollow = null
