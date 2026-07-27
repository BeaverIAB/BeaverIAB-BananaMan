extends Node


const MOD_DIR := "BeaverIAB-BananaMan"
const LOG_NAME := "BeaverIAB-BananaMan:Main"

var mod_dir_path := ""

func _init() -> void:
	ModLoaderLog.info("Init", LOG_NAME)
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)

func _ready() -> void:
	ModLoaderLog.info("Ready", LOG_NAME)
	Globals.ADDITIONAL_TOON_PATHS.append("res://mods-unpacked/BeaverIAB-BananaMan/extensions/objects/player/characters/sir_cj_rhinoscooter.tres")
