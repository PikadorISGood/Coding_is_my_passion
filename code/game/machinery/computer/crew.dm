/obj/machinery/computer/crew
	name = "crew monitoring computer"
	desc = "Used to monitor active health sensors built into most of the crew's uniforms."
	icon_keyboard = "med_key"
	icon_screen = "crew"
	light_color = "#315ab4"
	idle_power_usage = 250 WATTS
	active_power_usage = 500 WATTS
	circuit = /obj/item/circuitboard/crew
	var/datum/nano_module/crew_monitor/crew_monitor

/obj/machinery/computer/crew/New()
	crew_monitor = new(src)
	..()

/obj/machinery/computer/crew/Destroy()
	qdel(crew_monitor)
	crew_monitor = null

	return ..()

/obj/machinery/computer/crew/attack_ai(mob/user)
	ui_interact(user)

/obj/machinery/computer/crew/attack_hand(mob/user)
	..()
	if(stat & (BROKEN|NOPOWER))
		return
	ui_interact(user)

/obj/machinery/computer/crew/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	crew_monitor.ui_interact(user, ui_key, ui, force_open, state)

/obj/machinery/computer/crew/nano_container()
	return crew_monitor

/obj/machinery/computer/crew/interact(mob/user)
	crew_monitor.ui_interact(user)
