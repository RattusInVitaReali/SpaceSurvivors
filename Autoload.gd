extends Node

const Enemy = preload("res://Entity/Enemy/Enemy.tscn")

enum UPGRADES {
	MS,
	AOE,
	ENEMY_MS,
	INVUL,
	HEAL
} 

const upgrade_dict = {
	UPGRADES.MS : 
		["Boosters","Move faster.",preload("res://Resources/Abilities/nuke.png"), "ms_upgrades"],
	UPGRADES.AOE :
		 ["Missiles","Increase explosion radius.", preload("res://Resources/Abilities/nuke.png"), "aoe_upgrades"],
	UPGRADES.ENEMY_MS:
		["Freezing field","Slow down enemies.", preload("res://Resources/Abilities/freeze.png"), "enemy_ms_upgrades"],
	UPGRADES.INVUL:
		["Plating","Longer invulnerability when hit.", preload("res://Resources/Abilities/shield.png"), "invul_upgrades"],
	UPGRADES.HEAL:
		["Heal","Heal.",preload("res://Resources/Abilities/shield.png")] 
		
}

signal word_changed
signal enemy_died
signal get_upgrade
signal boss_layer_broken
signal start_game
signal boss_defeated
signal boss_spawned
signal defeat

var choosing_name = false


var player : Player
var paused = false

var Abilities
signal freeze
signal unfreeze
signal reset_word
signal nuke

var RANDOM = RandomNumberGenerator.new()

func _ready():
	RANDOM.randomize()

func new_word(new_word):
	emit_signal("word_changed", new_word)

func kill_enemy(enemy, first):
	emit_signal("enemy_died", enemy, first)

func get_upgrade():
	paused = true
	emit_signal("get_upgrade")
	
