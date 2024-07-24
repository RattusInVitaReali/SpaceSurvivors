extends Entity
class_name Enemy

var velocity = Vector2(0,0)

export var bonus_letters = 0

const death_sounds = [
	preload("res://Resources/SoundEffects/mdeath1.wav"),
	preload("res://Resources/SoundEffects/mdeath2.wav"),
	preload("res://Resources/SoundEffects/mdeath3.wav")
]

func _ready():
	Autoload.connect("word_changed", self, "_on_word_changed")
	Autoload.connect("freeze", self, "_on_freeze")
	Autoload.connect("unfreeze", self, "_on_unfreeze")
	Autoload.connect("nuke", self, "_on_nuke")
	$AudioStreamPlayer.stream = death_sounds[Autoload.RANDOM.randi() % 3]
	
func _on_freeze():
	set_physics_process(false)
	$AnimatedSprite.self_modulate = Color.blue
	
func _on_unfreeze():
	set_physics_process(true)
	$AnimatedSprite.self_modulate = Color.white

func _physics_process(delta):
	if Autoload.paused:
		return
	var dir = Autoload.player.global_position - global_position
	velocity = velocity.normalized() + dir.normalized()
	velocity = velocity.normalized()
	velocity = move_and_slide(velocity * MOVE_SPEED * (1 - 0.05 * Autoload.player.enemy_ms_upgrades))
	$Area2D/CollisionShape2D.shape.radius = 120 * (1 + 0.15 * Autoload.player.aoe_upgrades)
	$DeathExplosion.scale.x = 1.5 * (1 + Autoload.player.aoe_upgrades * 0.15)
	$DeathExplosion.scale.y = 1.5 * (1 + Autoload.player.aoe_upgrades * 0.15)

	# update facing
	if dir.x < 0:
		$AnimatedSprite.flip_h = true
		$Shadow.position.x = abs($Shadow.position.x)
	else:
		$AnimatedSprite.flip_h = false
		$Shadow.position.x = -abs($Shadow.position.x)

func _on_word_changed(new_word):
	if Autoload.paused:
		return
	check_name(new_word)

func check_name(word):
	if word.to_lower() == entity_name.to_lower():
		Autoload.kill_enemy(self, true)

const CHARS = "abcdefghijklmnopqrstuvwxyz"
func nuke_me():
	if entity_name_instance == null:
		return
	entity_name = CHARS[Autoload.RANDOM.randi() % 26]
	entity_name_instance.change_name(self)

func _on_nuke():
	nuke_me()

func die(first=true):
	set_process(false)
	if Autoload.RANDOM.randf_range(0, 1) < 0.5 or first:
		$AudioStreamPlayer.play()
	layers = 0
	$Shadow.hide()
	var wr = weakref(entity_name_instance)
	if wr.get_ref() == null:
		return
	entity_name_instance.queue_free()
	$AnimatedSprite.hide()
	if not first:
		set_physics_process(false)
		var sleep_time = Autoload.RANDOM.randf_range(0.25, 0.75)
		yield(get_tree().create_timer(sleep_time), "timeout")
		$BloodSplatter.show()
		$BloodSplatter.play("blood_splatter")
		return
	$DeathExplosion.show()
	$DeathExplosion.play("blue_explosion")
	var bodies_to_kill = $Area2D.get_overlapping_bodies()
	for body in bodies_to_kill:
		if not body.is_in_group("Players") and body.entity_name.length() <= entity_name.length() and body != self:
			body.die(false)
			Autoload.kill_enemy(body, false)
	

func _on_DeathAnimations_animation_finished():
	hide()
	yield($AudioStreamPlayer, "finished")
	queue_free()

func _on_BloodSplatter_animation_finished():
	hide()
	yield($AudioStreamPlayer, "finished")
	queue_free()
