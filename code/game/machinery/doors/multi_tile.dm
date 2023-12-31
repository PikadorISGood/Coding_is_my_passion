//Terribly sorry for the code doubling, but things go derpy otherwise.
/obj/machinery/door/airlock/multi_tile
	dir = EAST
	width = 2
	appearance_flags = DEFAULT_APPEARANCE_FLAGS

/obj/machinery/door/airlock/multi_tile/New()
	..()
	SetBounds()

/obj/machinery/door/airlock/multi_tile/Move()
	. = ..()
	SetBounds()


/obj/machinery/door/airlock/multi_tile/proc/SetBounds()
	if(dir in list(EAST, WEST))
		bound_width = width * world.icon_size
		bound_height = world.icon_size
	else
		bound_width = world.icon_size
		bound_height = width * world.icon_size

/obj/machinery/door/airlock/multi_tile/glass
	name = "Glass Airlock"
	icon = 'icons/obj/doors/door2x1glass.dmi'
	opacity = 0
	glass = 1
	assembly_type = /obj/structure/door_assembly/multi_tile
	open_sound_powered = 'sound/machines/airlock/glass_open1.ogg'
	close_sound_powered = 'sound/machines/airlock/glass_close1.ogg'

/obj/machinery/door/airlock/multi_tile/glass/medbay
	icon = 'icons/obj/doors/door2x1medglass.dmi'
