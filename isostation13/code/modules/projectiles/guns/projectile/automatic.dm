/obj/item/weapon/gun/projectile/automatic //Hopefully someone will find a way to make these fire in bursts or something. --Superxpdude
	name = "prototype SMG"
	desc = "A protoype lightweight, fast firing gun. Uses 9mm rounds."
	icon_state = "saber"	//ugly
	w_class = 3
	load_method = SPEEDLOADER //yup. until someone sprites a magazine for it.
	max_shells = 22
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/c9mm
	multi_aim = 1
	burst_delay = 2
	fire_sound = 'sound/weapons/guns/fire/smg_fire.ogg'
	unload_sound = 'sound/weapons/guns/interact/smg_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/smg_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/smg_cock.ogg'

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		list(mode_name="short bursts",   burst=5, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1,-2,-2), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/mini_uzi
	name = "\improper Uzi"
	desc = "The UZI is a lightweight, fast firing gun. For when you want someone dead. Uses .45 rounds."
	icon_state = "mini-uzi"
	w_class = 3
	load_method = SPEEDLOADER //yup. until someone sprites a magazine for it.
	max_shells = 15
	caliber = ".45"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	ammo_type = /obj/item/ammo_casing/c45

/obj/item/weapon/gun/projectile/automatic/c20r
	name = "submachine gun"
	desc = "The C-20r is a lightweight and rapid firing SMG, for when you REALLY need someone dead. Uses 10mm rounds. Has a 'Scarborough Arms - Per falcis, per pravitas' buttstamp."
	icon_state = "c20r"
	item_state = "c20r"
	w_class = 3
	force = WEAPON_FORCE_PAINFULL
	caliber = "10mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	slot_flags = SLOT_BELT|SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a10mm
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/sfrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/sfrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/sfrifle_cock.ogg'

/obj/item/weapon/gun/projectile/automatic/c20r/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "c20r"
	return

/obj/item/weapon/gun/projectile/automatic/sts35
	name = "assault rifle"
	desc = "The rugged STS-35 is a durable automatic weapon of a make popular on the frontier worlds. Uses 7.62mm rounds. This one is unmarked."
	icon_state = "arifle"
	item_state = null
	w_class = 4
	force = 10
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/c762
	fire_sound = 'sound/weapons/guns/fire/ltrifle_fire.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/ltrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/ltrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/ltrifle_cock.ogg'

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-1,-2),       dispersion=list(0.0, 0.6, 0.6)),
		list(mode_name="short bursts", 	burst=5, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-1,-2,-2,-3), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/weapon/gun/projectile/automatic/sts35/update_icon(var/ignore_inhands)
	..()
	icon_state = (ammo_magazine)? "arifle" : "arifle-empty"
	if(!ignore_inhands) update_held_icon()

/obj/item/weapon/gun/projectile/automatic/wt550
	name = "machine pistol"
	desc = "The W-T 550 Saber is a cheap self-defense weapon, mass-produced by Ward-Takahashi for paramilitary and private use. Uses 9mm rounds."
	icon_state = "wt550"
	item_state = "wt550"
	w_class = 3
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/c9mmr"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mc9mmt/rubber

/obj/item/weapon/gun/projectile/automatic/wt550/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "wt550-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "wt550"
	return

/obj/item/weapon/gun/projectile/automatic/z8
	name = "bullpup assault rifle"
	desc = "The Z8 Bulldog is an older model bullpup carbine, made by the now defunct Zendai Foundries. Uses armor piercing 5.56mm rounds. Makes you feel like a space marine when you hold it."
	icon_state = "carbine"
	item_state = "z8carbine"
	w_class = 4
	force = WEAPON_FORCE_PAINFULL
	caliber = "a556"
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 3)
	ammo_type = "/obj/item/ammo_casing/a556"
	fire_sound = 'sound/weapons/guns/fire/batrifle_fire.ogg'
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a556
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/batrifle_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/batrifle_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/batrifle_cock.ogg'

	burst_delay = 4
	firemodes = list(
		list(mode_name="semiauto",       burst=1,    fire_delay=0,    move_delay=null, use_launcher=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3,    fire_delay=null, move_delay=6,    use_launcher=null, burst_accuracy=list(0,-1,-1), dispersion=list(0.0, 0.6, 0.6)),
		list(mode_name="fire grenades",  burst=null, fire_delay=null, move_delay=null, use_launcher=1,    burst_accuracy=null, dispersion=null)
		)

	var/use_launcher = 0
	var/obj/item/weapon/gun/launcher/grenade/underslung/launcher

/obj/item/weapon/gun/projectile/automatic/z8/New()
	..()
	launcher = new(src)

/obj/item/weapon/gun/projectile/automatic/z8/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/weapon/grenade)))
		launcher.load(I, user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/attack_hand(mob/user)
	if(user.get_inactive_hand() == src && use_launcher)
		launcher.unload(user)
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/Fire(atom/target, mob/living/user, params, pointblank=0, reflex=0)
	if(use_launcher)
		launcher.Fire(target, user, params, pointblank, reflex)
		if(!launcher.chambered)
			switch_firemodes() //switch back automatically
	else
		..()

/obj/item/weapon/gun/projectile/automatic/z8/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "carbine-[round(ammo_magazine.stored_ammo.len,2)]"
	else
		icon_state = "carbine"
	return

/obj/item/weapon/gun/projectile/automatic/z8/examine(mob/user)
	..()
	if(launcher.chambered)
		user << "\The [launcher] has \a [launcher.chambered] loaded."
	else
		user << "\The [launcher] is empty."

/obj/item/weapon/gun/projectile/automatic/l6_saw
	name = "light machine gun"
	desc = "A rather traditionally made L6 SAW with a pleasantly lacquered wooden pistol grip. Has 'Aussec Armoury- 2531' engraved on the reciever"
	icon_state = "l6closed100"
	item_state = "l6closedmag"
	w_class = 4
	force = 10
	slot_flags = 0
	max_shells = 50
	caliber = "a762"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 2)
	slot_flags = SLOT_BACK
	ammo_type = "/obj/item/ammo_casing/a762"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/a762
	unload_sound 	= 'sound/weapons/guns/interact/lmg_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/lmg_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/lmg_cock.ogg'
	fire_sound = 'sound/weapons/guns/fire/lmg_fire.ogg'

	firemodes = list(
		list(mode_name="short bursts",	burst=5, move_delay=6, burst_accuracy = list(0,-1,-1,-2,-2),          dispersion = list(0.6, 1.0, 1.0, 1.0, 1.2)),
		list(mode_name="long bursts",	burst=8, move_delay=8, burst_accuracy = list(0,-1,-1,-2,-2,-2,-3,-3), dispersion = list(1.0, 1.0, 1.0, 1.0, 1.2)),
		)

	var/cover_open = 0

/obj/item/weapon/gun/projectile/automatic/l6_saw/special_check(mob/user)
	if(cover_open)
		user << "<span class='warning'>[src]'s cover is open! Close it before firing!</span>"
		return 0
	return ..()

/obj/item/weapon/gun/projectile/automatic/l6_saw/proc/toggle_cover(mob/user)
	cover_open = !cover_open
	user << "<span class='notice'>You [cover_open ? "open" : "close"] [src]'s cover.</span>"
	update_icon()

/obj/item/weapon/gun/projectile/automatic/l6_saw/attack_self(mob/user as mob)
	if(cover_open)
		toggle_cover(user) //close the cover
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, 1)
	else
		return ..() //once closed, behave like normal

/obj/item/weapon/gun/projectile/automatic/l6_saw/attack_hand(mob/user as mob)
	if(!cover_open && user.get_inactive_hand() == src)
		toggle_cover(user) //open the cover
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, 1)
	else
		return ..() //once open, behave like normal

/obj/item/weapon/gun/projectile/automatic/l6_saw/update_icon()
	icon_state = "l6[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 25) : "-empty"]"

/obj/item/weapon/gun/projectile/automatic/l6_saw/load_ammo(var/obj/item/A, mob/user)
	if(!cover_open)
		user << "<span class='warning'>You need to open the cover to load [src].</span>"
		return
	..()

/obj/item/weapon/gun/projectile/automatic/l6_saw/unload_ammo(mob/user, var/allow_dump=1)
	if(!cover_open)
		user << "<span class='warning'>You need to open the cover to unload [src].</span>"
		return
	..()


/* Ironhammer stuff */

/obj/item/weapon/gun/projectile/automatic/SMG_sol
	name = "FS SMG 9x19 \"Sol\""
	desc = "A standard-issued weapon used by Ironhammer operatives. Compact and reliable. Uses 9mm rounds."
	icon_state = "SMG-IS"
	item_state = "wt550"
	w_class = 4
	ammo_mag = "ih_smg"
	load_method = MAGAZINE //yup. until someone sprites a magazine for it.
	max_shells = 21
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	multi_aim = 1
	burst_delay = 2

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/weapon/gun/projectile/automatic/SMG_sol/proc/update_charge()
	if(!ammo_magazine)
		return
	var/ratio = ammo_magazine.stored_ammo.len / ammo_magazine.max_ammo
	if(ratio < 0.25 && ratio != 0)
		ratio = 0.25
	ratio = round(ratio, 0.25) * 100
	overlays += "smg_[ratio]"


/obj/item/weapon/gun/projectile/automatic/SMG_sol/update_icon()
	icon_state = (ammo_magazine)? "SMG-IS" : "SMG-IS-empty"
	overlays.Cut()
	update_charge()

/obj/item/weapon/gun/projectile/automatic/SMG_sol/toby
	name = "FS SMG 9x19 \"Warlord\""
	desc = "A customized FS SMG used by a specific Ironhammer Operative. There is a small scrape covering the name of the owner."
	icon_state = "SMG_toby"
	item_state = "wt550"
	w_class = 4
	ammo_mag = "ih_smg"
	load_method = MAGAZINE //yup. until someone sprites a magazine for it.
	max_shells = 30
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	multi_aim = 1
	burst_delay = 2

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="5-round bursts", burst=5, fire_delay=null, move_delay=4,    burst_accuracy=list(0,-1,-1),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/weapon/gun/projectile/automatic/SMG_sol/toby/update_icon()
	icon_state = (ammo_magazine)? "SMG_toby" : "SMG_toby_empty"
	overlays.Cut()
	update_charge()

/obj/item/weapon/gun/projectile/automatic/m4a1
	name = "M4A1 semi-automatic rifle"
	desc = "A semi-automatic rifle part of the M4 series."
	icon_state = "M4A1"
	item_state = "wt550"
	w_class = 4
	ammo_mag = "5.56mm"
	load_method = MAGAZINE
	max_shells = 25
	caliber = "5.56mm"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	multi_aim = 1
	burst_delay = 2

	firemodes = list(
		list(mode_name="semiauto",		burst=1, fire_delay=0,	move_delay=null, burst_accuracy_=null, dispersion=null)
		)

/obj/item/weapon/gun/projectile/automatic/m4a1/update_icon()
	icon_state = (ammo_magazine)? "M4A1" : "M4A1_empty"
	overlays.Cut()

/obj/item/weapon/gun/projectile/automatic/m4a4
	name = "M4A4 automatic rifle"
	desc = "An automatic rifle part of the M4 series."
	icon_state = "M4A4"
	item_state = "wt550"
	w_class = 4
	ammo_mag = "5.56mm"
	load_method = MAGAZINE
	max_shells = 25
	caliber = "5.56mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3)
	multi_aim = 1
	burst_delay = 2

	firemodes = list(
		list(mode_name="3-round bursts",		burst=3, fire_delay=0,	mode_delay=null, burst_accuracy=list(0, -1, -1),       dispersion=list(0.0, 0.6, 1.0)),
		)

/obj/item/weapon/gun/projectile/automatic/m4a4/update_icon()
	icon_state = (ammo_magazine)? "M4A4" : "M4A4_empty"
	overlays.Cut ()

/obj/item/weapon/gun/projectile/automatic/m4a10
	name = "M4A10 advanced rifle"
	desc = "An advanced version of earlier M4 series guns. Has burst and singleshot firemode."
	icon_state = "M4A10"
	item_state = "wt550"
	w_class = 4
	ammo_mag = "5.56mm"
	load_method = MAGAZINE
	max_shells = 25
	caliber = "5.56mm"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4)
	multi_aim = 1
	burst_delay = 2

	firemodes = list(
		list(mode_name="semiauto",		burst =1, fire_delay=0, mode_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts",	burst=3, fire_delay=0, mode_delay=null, burst_accuracy=list(0, -1, -1), dispersion=list(0.0, 0.6, 1.0))
		)

/obj/item/weapon/gun/projectile/automatic/m4a10/update_icon()
	icon_state = (ammo_magazine)? "M4A10" : "M4A10_empty"
	overlays.Cut ()