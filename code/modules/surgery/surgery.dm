/* SURGERY STEPS */

/datum/surgery_step
	var/priority = 0	//steps with higher priority would be attempted first

	// type path referencing tools that can be used for this step, and how well are they suited for it
	var/list/allowed_tools = null
	// type paths referencing races that this step applies to.
	var/list/allowed_species = null
	var/list/disallowed_species = null

	// duration of the step
	var/duration = 0

	// evil infection stuff that will make everyone hate me
	var/can_infect = 0
	//How much blood this step can get on surgeon. 1 - hands, 2 - full body.
	var/blood_level = 0
	var/shock_level = 0	//what shock level will this step put patient on
	var/delicate = 0  //if this step NEEDS stable optable or can be done on any valid surface with no penalty
	var/clothes_penalty = TRUE // If the selected limb is wearing something - add a penalty.

/datum/surgery_step/proc/do_surgery_process(mob/living/carbon/M, atom/movable/user, zone, obj/item/tool, step_is_valid)
	var/status = TRUE
	if(clothes_penalty && clothes_check(user, M, zone) == SURGERY_BLOCKED)
		return TRUE
	if(step_is_valid == SURGERY_FAILURE) // This is a failure that already has a message for failing.
		return TRUE
	M.op_stage.in_progress += zone
	begin_step(user, M, zone, tool)		//start on it
	//We had proper tools! (or RNG smiled.) and user did not move or change hands.
	if(prob(success_chance(user, M, tool, zone)) &&  do_mob(user, M, duration * SURGERY_DURATION_DELTA * tool.surgery_speed))
		end_step(user, M, zone, tool)		//finish successfully
	else if ((tool in user.contents) && user.Adjacent(M))			//or
		fail_step(user, M, zone, tool)		//malpractice
	else // This failing silently was a pain.
		to_chat(user, SPAN("warning", "You must remain close to your patient to conduct surgery."))
		status = FALSE
	if (M)
		M.op_stage.in_progress -= zone 									// Clear the in-progress flag.
	if (ishuman(M))
		var/mob/living/carbon/human/H = M
		H.update_surgery()
		if(H.op_stage.current_organ)
			H.op_stage.current_organ = null						//Clearing current surgery target for the sake of internal surgery's consistency
	return status

//returns how well tool is suited for this step
/datum/surgery_step/proc/tool_quality(obj/item/tool)
	for (var/T in allowed_tools)
		if (istype(tool,T))
			return allowed_tools[T]
	return 0

// Checks if this step applies to the user mob at all
/datum/surgery_step/proc/is_valid_target(mob/living/carbon/human/target)
	if(!hasorgans(target))
		return 0

	if(allowed_species)
		for(var/species in allowed_species)
			if(target.species.name == species)
				return 1

	if(disallowed_species)
		for(var/species in disallowed_species)
			if(target.species.name == species)
				return 0

	return 1


// checks whether this step can be applied with the given user and target
/datum/surgery_step/proc/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return 0

// does stuff to begin the step, usually just printing messages. Moved germs transfering and bloodying here too
/datum/surgery_step/proc/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (can_infect && affected)
		spread_germs_to_organ(affected, user)
	if (ishuman(user) && prob(60))
		var/mob/living/carbon/human/H = user
		if (blood_level)
			H.bloody_hands(target,0)
		if (blood_level > 1)
			H.bloody_body(target,0)
	if(shock_level)
		target.shock_stage = max(target.shock_stage, shock_level)
	return

// does stuff to end the step, which is normally print a message + do whatever this step changes
/datum/surgery_step/proc/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return

// stuff that happens when the step fails
/datum/surgery_step/proc/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return null

/datum/surgery_step/proc/success_chance(mob/living/user, mob/living/carbon/human/target, obj/item/tool, target_zone)
	. = tool_quality(tool)
	if(user == target)
		. -= 10
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		. -= round(H.shock_stage * 0.5)
		if(H.eye_blurry)
			. -= 20
		if(H.eye_blind)
			. -= 60

	if(delicate)
		if(ishuman(user) && user?.slurring)
			. -= 10
		if(!target.lying)
			. -= 30
		var/turf/T = get_turf(target)
		if(locate(/obj/machinery/optable, T))
			. -= 0
		else if(locate(/obj/structure/bed, T))
			. -= 5
		else if(locate(/obj/structure/table, T))
			. -= 10
		else if(locate(/obj/effect/rune/, T))
			. -= 10
	. = max(., 0)

/proc/clothes_check(user, target, target_zone)
	var/list/clothes = get_target_clothes(target, target_zone)
	for(var/obj/item/clothing/C in clothes)
		if(!(C.body_parts_covered & body_part_flags[target_zone]))
			continue
		to_chat(user, SPAN_DANGER("Clothing on [target]'s [organ_name_by_zone(target, target_zone)] blocks surgery!"))
		return SURGERY_BLOCKED

/proc/spread_germs_to_organ(obj/item/organ/external/E, mob/living/carbon/human/user)
	if(!istype(user) || !istype(E)) return

	var/germ_level = user.germ_level
	var/obj/item/clothing/gloves/G = user.gloves
	if(istype(G) && !(G.clipped && prob(75)))
		germ_level = G.germ_level

	E.germ_level = max(germ_level,E.germ_level) //as funny as scrubbing microbes out with clean gloves is - no.

/obj/item/proc/do_surgery(mob/living/carbon/M, mob/living/user)
	if(!istype(M))
		return FALSE
	if (user.a_intent == I_HURT)	//check for Hippocratic Oath
		return FALSE
	var/zone = user.zone_sel.selecting
	if(zone in M.op_stage.in_progress) //Can't operate on someone repeatedly.
		to_chat(user, SPAN("warning", "You can't operate on this area while surgery is already in progress."))
		return TRUE
	for(var/datum/surgery_step/S in surgery_steps)
		//check if tool is right or close enough and if this step is possible
		if(S.tool_quality(src))
			var/step_is_valid = S.can_use(user, M, zone, src)
			if(step_is_valid && S.is_valid_target(M))
				S.do_surgery_process(M, user, zone, src, step_is_valid)
				return TRUE // don't want to do weapony things after surgery
	return FALSE

/proc/sort_surgeries()
	var/gap = surgery_steps.len
	var/swapped = 1
	while (gap > 1 || swapped)
		swapped = 0
		if(gap > 1)
			gap = round(gap / 1.247330950103979)
		if(gap < 1)
			gap = 1
		for(var/i = 1; gap + i <= surgery_steps.len; i++)
			var/datum/surgery_step/l = surgery_steps[i]		//Fucking hate
			var/datum/surgery_step/r = surgery_steps[gap+i]	//how lists work here
			if(l.priority < r.priority)
				surgery_steps.Swap(i, gap + i)
				swapped = 1

/datum/surgery_status/
	var/eyes	=	0
	var/face	=	0
	var/head_reattach = 0
	var/current_organ = "organ"
	var/list/in_progress = list()

/datum/surgery_status/Destroy()
	in_progress.Cut()
	return ..()
