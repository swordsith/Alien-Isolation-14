/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/pistol/strong

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."
	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet/pistol/strong

/obj/item/ammo_casing/a75
	desc = "A 20mm bullet casing."
	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = "38"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_casing/c38r
	desc = "A .38 rubber bullet casing."
	caliber = "38"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_casing/c9mmf
	desc = "A 9mm flash shell casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/c9mmr
	desc = "A 9mm rubber bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/c9mmp
	desc = "A 9mm practice bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/pistol/practice


/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/pistol/medium

/obj/item/ammo_casing/c45p
	desc = "A .45 practice bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/pistol/practice

/obj/item/ammo_casing/c45r
	desc = "A .45 rubber bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/c45f
	desc = "A .45 flash shell casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/a10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/pistol/medium


/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(DEFAULT_WALL_MATERIAL = 360)

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(DEFAULT_WALL_MATERIAL = 90)

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = list("metal" = 90)

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(DEFAULT_WALL_MATERIAL = 180)

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	matter = list(DEFAULT_WALL_MATERIAL = 360, "glass" = 720)

/obj/item/ammo_casing/shotgun/stunshell/emp_act(severity)
	if(prob(100/severity)) BB = null
	update_icon()

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(DEFAULT_WALL_MATERIAL = 90, "glass" = 90)

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/rifle/a762

/obj/item/ammo_casing/a145
	name = "shell casing"
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/rifle/a145
	matter = list(DEFAULT_WALL_MATERIAL = 1250)

/obj/item/ammo_casing/a556
	desc = "A 5.56mm bullet casing."
	caliber = "a556"
	projectile_type = /obj/item/projectile/bullet/rifle/a556

/obj/item/ammo_casing/a556p
	desc = "A 5.56mm practice bullet casing."
	caliber = "a556"
	projectile_type = /obj/item/projectile/bullet/rifle/a556/practice

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = /obj/item/missile
	caliber = "rocket"

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	color = "#FF0000"
	projectile_type = /obj/item/projectile/bullet/pistol/cap

/* Ironhammer stuff */

/obj/item/ammo_casing/SMG_sol/rubber
	desc = "A 9mm Ironhammer rubber bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/SMG_sol/rubber

/obj/item/ammo_casing/SMG_sol/brute
	desc = "A 9mm Ironhammer hollow point bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/SMG_sol/brute

/obj/item/ammo_casing/cl38/rubber
	desc = "A .38 Ironhammer rubber bullet casing."
	caliber = ".38"
	projectile_type = /obj/item/projectile/bullet/cl38/rubber

/obj/item/ammo_casing/cl38/brute
	desc = "A .38 Ironhammer hollow point bullet casing."
	caliber = ".38"
	projectile_type = /obj/item/projectile/bullet/cl38/brute

/obj/item/ammo_casing/cl44/rubber
	desc = "A .44 Ironhammer rubber bullet casing."
	caliber = ".44"
	projectile_type = /obj/item/projectile/bullet/cl44/rubber

/obj/item/ammo_casing/cl44/brute
	desc = "A .44 Ironhammer hollow point bullet casing."
	caliber = ".44"
	projectile_type = /obj/item/projectile/bullet/cl44/brute

//gun vendors stuff

/obj/item/ammo_casing/cl32/rubber
	desc = "A .32 FS rubber bullet casing."
	caliber = ".32"
	projectile_type = /obj/item/projectile/bullet/cl32/rubber

/obj/item/ammo_casing/cl32/brute
	desc = "A .38 FS hollow point bullet casing."
	caliber = ".38"
	projectile_type = /obj/item/projectile/bullet/cl32/brute

/obj/item/ammo_casing/m4/rubber
	desc = "A 5.56mm rubber bullet casing."
	caliber = "5.56mm"
	projectile_type = /obj/item/projectile/bullet/m4/rubber

/obj/item/ammo_casing/m4/brute
	desc = "A 5.56mm hollow point bullet casing."
	caliber = "5.56mm"
	projectile_type = /obj/item/projectile/bullet/m4/brute

/obj/item/ammo_casing/super/slug
	desc = "A slug shotgun shell for Benelli 270."
	caliber = "super12"
	projectile_type = /obj/item/projectile/bullet/super/slug