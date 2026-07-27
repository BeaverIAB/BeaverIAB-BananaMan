extends ItemCharSetup


func first_time_setup(player : Player) -> void:
	# CJ does not naturally get this set since Trap is not in his loadout
	player.stats.gag_effectiveness['Trap'] = 1.0
