@tool
extends StatusEffect
class_name StatusAutoTrap

@export var trap_gag: GagTrap

func apply() -> void:
	manager.s_round_started.connect(round_started)

func cleanup() -> void:
	if manager.s_round_started.is_connected(round_started):
		manager.s_round_started.disconnect(round_started)

func round_started(actions: Array[BattleAction]) -> void:
	var new_trap: GagTrap = trap_gag.duplicate(true)
	new_trap.targets = [target]
	new_trap.user = Util.get_player()
	new_trap.special_action_exclude = true
	new_trap.track = load('res://mods-unpacked/BeaverIAB-BananaMan/extensions/objects/battle/battle_resources/gag_loadouts/gag_tracks/trap_b.tres')
	var trap_index := find_inject_pos(actions)

	manager.inject_battle_action(new_trap, trap_index)

func find_inject_pos(actions: Array[BattleAction]) -> int:
	var trap_index := 0
	var found_player := false
	while trap_index < actions.size():
		var action: BattleAction = actions[trap_index]
		if action is ToonAttack:
			found_player = true
		if action is CogAttack and found_player:
			break
		trap_index += 1
	if found_player == false:
		trap_index = 0
		while trap_index < actions.size() and BattleAction.ActionTag.PRIORITY_ACTION in actions[trap_index].action_tags:
			trap_index += 1
	return trap_index

func get_icon() -> Texture2D:
	return trap_gag.icon

func get_status_name() -> String:
	return "Incoming Banana!"

func get_description() -> String:
	return "Will be hit by %s\nDamage: %s" % [trap_gag.action_name, trap_gag.get_true_damage(1.0, 0, load('res://mods-unpacked/BeaverIAB-BananaMan/extensions/objects/battle/battle_resources/gag_loadouts/gag_tracks/trap_b.tres'))]
