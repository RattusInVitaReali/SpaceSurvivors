extends Node2D
class_name Spawner

const Monster1 = preload("res://Entity/Enemy/Variants/Monster1.tscn")
const Monster2 = preload("res://Entity/Enemy/Variants/Monster2.tscn")
const Monster3 = preload("res://Entity/Enemy/Variants/Monster3.tscn")
const Monster4 = preload("res://Entity/Enemy/Variants/Monster4.tscn")
const EntityName = preload("res://EntityName/EntityName.tscn")

const monsters = [Monster1, Monster2, Monster3, Monster4]

const CHARS = "abcdefghijklmnopqrstuvwxyz"
const RANGE_LOW = 1000
const RANGE_HIGH = 1500

var min_length = 2
var max_length = 5

var difficulty_counter = 0

signal new_enemy

func make_enemy():
	var monster_type = Autoload.RANDOM.randi() % 4
	if monster_type == 3:
		monster_type = Autoload.RANDOM.randi() % 4
	var enemy_scene = monsters[monster_type]
	var new_enemy = enemy_scene.instance()
	new_enemy.entity_name = make_new_name(new_enemy)
	return new_enemy

func make_new_name(enemy):
	var length = Autoload.RANDOM.randi() % (max_length - min_length + 1) + min_length + enemy.bonus_letters
	return generate_word(CHARS, max(length, 1))

func make_entity_name(entity):
	var entity_name = EntityName.instance()
	entity_name.set_entity(entity)
	return entity_name

func generate_word(chars, length):
	var word = ""
	var n_char = len(chars)
	for _i in range(length):
		word += chars[randi()% n_char]
	return word

func _on_Timer_timeout():
	if Autoload.paused:
		return
	var new_enemy = make_enemy()
	var entity_name = make_entity_name(new_enemy)
	new_enemy.entity_name_instance = entity_name
	$Timer.start()
	add_enemy(new_enemy, entity_name)
	

func add_enemy(new_enemy,entity_name):
	if Autoload.paused:
		return
		
	var angle = deg2rad(Autoload.RANDOM.randi() % 360)
	var distance = Autoload.RANDOM.randi() % (RANGE_HIGH - RANGE_LOW) + RANGE_LOW
	var pos = Autoload.player.position + Vector2(0, distance).rotated(angle)
	
	new_enemy.position = pos
	entity_name.position = new_enemy.position
	$Enemies.add_child(new_enemy)
	$EnemyNames.add_child(entity_name)	


func _on_DifficultyTimer_timeout():
	$Timer.wait_time = max(0.7, $Timer.wait_time - 0.1)
	max_length += 1
	difficulty_counter += 1
	if difficulty_counter == 3:
		min_length += 1
		difficulty_counter = 0


func _on_BossTimer_timeout():
	if Autoload.paused:
		return
		
	var angle = deg2rad(Autoload.RANDOM.randi() % 360)
	var distance = Autoload.RANDOM.randi() % (RANGE_HIGH - RANGE_LOW) + RANGE_LOW - 1000
	var pos = Autoload.player.position + Vector2(0, distance).rotated(angle)
	var boss = preload("res://Entity/Enemy/Boss.tscn").instance()
	boss.position = pos
	$Enemies.add_child(boss)
	Autoload.emit_signal("boss_spawned")
