extends Sprite
class_name Projectile

const MOVE_SPEED = 700

var target

func go_to_enemy(enemy):
	target = enemy

func _process(delta):
	if Autoload.paused:
		return
	var wr = weakref(target)
	if target != null and wr.get_ref() != null:
		global_position = global_position.move_toward(target.global_position, delta * MOVE_SPEED)
		look_at(target.position)
		if (global_position - target.global_position).length() < 10:
			$AudioStreamPlayer.play()
			target.die()
			queue_free()
	else:
		queue_free()
