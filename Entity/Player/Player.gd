extends Entity
class_name Player

var ms_upgrades = 0
var aoe_upgrades = 0
var invul_upgrades = 0
var enemy_ms_upgrades = 0

const Projectile = preload("res://Weapons/Projectile.tscn")

var velocity = Vector2()
var current_health
var is_flipped = false

var shield = 0

var level = 0
var xp = 0
var needed_xp = 5

func _ready():
	current_health = entity_name.length()
	Autoload.connect("enemy_died", self, "launch_projectile")
	Autoload.connect("boss_layer_broken", self, "launch_projectile")
	Autoload.connect("enemy_died", self, "gain_xp")

func set_entity_name(_en):
	entity_name = _en
	set_health(entity_name.length())

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		is_flipped = false
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		is_flipped = true
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	velocity = velocity.normalized() * MOVE_SPEED * (1 + ms_upgrades * 0.07)
	if $InvulTimer.is_stopped():
		$InvulTimer.wait_time = 1 + 0.3 * invul_upgrades
	# flip bracki
	$AnimatedSprite.flip_h = is_flipped

func _physics_process(_delta):
	$FlashTimer.paused = Autoload.paused
	$ShieldTimer.paused = Autoload.paused
	if Autoload.paused:
		return

	get_input()
	var bodies = move_and_collide(velocity * _delta)
	if bodies != null:
		if bodies.get_collider() is Enemy and $InvulTimer.is_stopped():
			take_damage()

func take_damage():
	$InvulTimer.start()
	if shield > 0:
		set_shield(shield - 1)
	else:
		set_health(current_health - 1)
	flash()

func flash():
	layers = 0
	$Label.modulate = Color.orange
	var i = 0
	while (i < 10):
		$FlashTimer.start()
		yield($FlashTimer, "timeout")
		visible = !visible
		i += 1
	show()
	$Label.modulate = Color.white
	layers = 1

func set_health(health):
	current_health = health
	$Label.text = entity_name.left(current_health)
	if current_health == 0:
		Autoload.emit_signal("defeat")
		hide()
		Autoload.paused = true

func activate_shield():
	set_shield(6)
	$ShieldTimer.start()

func launch_projectile(enemy, first):
	if first:
		$AudioStreamPlayer.play()
		var proj = Projectile.instance()
		add_child(proj)
		proj.go_to_enemy(enemy)
		
func calculate_needed_xp():
	needed_xp=level*5
	
func gain_xp(enemy, first):
	xp+=1
	if xp==needed_xp: 
		levelup()

func levelup():
	level += 1
	Autoload.get_upgrade()
	xp = 0
	calculate_needed_xp()

func set_shield(val):
	shield = val
	$Label2.text = "shield".left(shield)

func _on_ShieldTimer_timeout():
	set_shield(0)
