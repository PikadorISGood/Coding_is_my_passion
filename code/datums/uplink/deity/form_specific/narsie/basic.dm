/datum/uplink_item/deity/boon/ability_dark
	category = /datum/uplink_category/deity_ability_dark
	required_feats = list(DEITY_FORM_DARK_ART)

/datum/uplink_item/deity/boon/ability_dark/shatter_mind
	name = "Eternal Darkness"
	desc = "Allows a follower to cause insanity in a target."
	item_cost = 40
	path = /datum/spell/targeted/shatter

/datum/uplink_item/deity/boon/ability_dark/torment
	name = "Torment"
	desc = "Gives a follower the ability to cause mass hysteria and pain."
	item_cost = 30
	path = /datum/spell/targeted/torment

/datum/uplink_item/deity/boon/ability_dark/blood_shard
	name = "Bloodshard"
	desc = "Lets a caster blood to literally explode out of their skin into dangerous projectiles."
	item_cost = 40
	path = /datum/spell/blood_shard

/datum/uplink_item/deity/boon/ability_dark/drain_blood
	name = "Drain Blood"
	desc = "Lets a follower drain blood from all those around them."
	item_cost = 60
	path = /datum/spell/aoe_turf/drain_blood

/datum/uplink_item/deity/feat/phenomena/exhude_blood
	name = "Phenomena: Exhude Blood"
	desc = "You extract the raw blood used in your faith and give it to one of your flock"
	item_cost = 30
	path = /datum/phenomena/exhude_blood
	category = /datum/uplink_category/deity_ability_dark
	required_feats = list(DEITY_FORM_DARK_ART)
