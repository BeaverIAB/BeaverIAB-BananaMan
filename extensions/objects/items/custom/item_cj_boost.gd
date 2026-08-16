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
	var min_trap_level: int = 0    # No minimum Trap level no matter what floor the player is on.
	var max_trap_level: int = mini(Util.floor_number + 1, 6)    # Max Trap level is two tiers higher than the current floor. Hardcap at tier 7 for Endless Mode compat.
	idx = randi_range(min_trap_level, max_trap_level)
	return TRAP_GAGS.gags[idx].duplicate(true)
