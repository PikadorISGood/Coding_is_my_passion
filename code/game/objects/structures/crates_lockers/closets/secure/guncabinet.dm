/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	req_access = list(access_armory)
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	icon_off = "base"
	icon_broken = "sparks"
	icon_locked = "base"
	icon_closed = "base"
	icon_opened = "base"
	dremovable = FALSE

/obj/structure/closet/secure_closet/guncabinet/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	overlays.Cut()
	if(opened)
		overlays += icon(icon,"door_open")
	else
		var/lazors = 0
		var/shottas = 0
		for(var/obj/item/gun/G in contents)
			if(istype(G, /obj/item/gun/energy))
				lazors++
			if(istype(G, /obj/item/gun/projectile))
				shottas++
		for(var/i = 0 to 2)
			if(lazors || shottas) // only make icons if we have one of the two types.
				var/image/gun = image(icon(src.icon))
				if(lazors > shottas)
					lazors--
					gun.icon_state = "laser"
				else if(shottas)
					shottas--
					gun.icon_state = "projectile"
				gun.pixel_x = i * 4
				overlays += gun

		overlays += icon(src.icon, "door")

		if(welded)
			overlays += icon(src.icon, "welded")

		if(broken)
			overlays += icon(src.icon, "broken")
			overlays += icon(src.icon, icon_broken)
		else if(locked)
			overlays += icon(src.icon, "locked")
		else
			overlays += icon(src.icon, "open")
