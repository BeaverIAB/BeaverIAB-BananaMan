extends ItemScript

const TRAP_GAGS := preload("res://mods-unpacked/BeaverIAB-BananaMan/extensions/objects/battle/battle_resources/gag_loadouts/gag_tracks/trap_b.tres")    # Trap_b is a modified version of Trap where all tiers are Banana Peels. Uses damage values from original Trap track.
const AUTO_TRAP := preload("res://mods-unpacked/BeaverIAB-BananaMan/extensions/objects/battle/battle_resources/status_effects/resources/auto_trap.tres")

var player: Player


func on_collect(_item: Item, _object: Node3D) -> void:
	var _player: Player
	if not Util.get_player():
		_player = await Util.s_player_assigned
	else:
		_player = Util.get_player()
	setup(_player)

func on_load(item: Item) -> void:
	on_collect(item, null)

func setup(_player: Player) -> void:
	player = _player
	BattleService.s_battle_started.connect(try_apply_trap)
	BattleService.s_round_ended.connect(try_apply_trap)

func try_apply_trap(manager: BattleManager) -> void:
	if manager.cogs:    # Pick a random cog in the battle and apply the auto-trap status onto them.
		var cog: Cog = manager.cogs.pick_random()
		var new_status := AUTO_TRAP.duplicate(true)
		new_status.trap_gag = get_random_trap_resource()
		new_status.target = cog
		manager.add_status_effect(new_status)

func get_random_trap_resource() -> GagTrap:
	var idx: int = 0
	var min_trap_level: int = 0    # No minimum Trap level, got a weak Trap? Find another method to kill or Lure and roll the dice again!
	var max_trap_level: int = Util.floor_number + 1    # Tier 3 unlocks on Floor 1    Tier 4 unlocks on Floor 2    ...    Tier 7 unlocks on Floor 5!
	idx = randi_range(min_trap_level, max_trap_level)
	return TRAP_GAGS.gags[idx].duplicate(true)
