/mob/observer/ghost/Login()
	..()

	if(ghost_image)
		ghost_image.appearance = src
		ghost_image.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_ALPHA

	updateghostprefs()
	updateghostsight()
	updateghostimages()
