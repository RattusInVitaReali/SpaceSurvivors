extends KinematicBody2D
class_name EntityName

const MOVE_SPEED = 1000

const bbc = "[center][color=red][wave amp=20 freq=5][b]TYPED[/b][/wave][/color]REST[/center]"

var entity_name = ""
var entity = null

var velocity = Vector2(0,0)

func _ready():
	Autoload.connect("word_changed", self, "_on_word_changed")
	$Label.bbcode_text = bbc.replace("TYPED","").replace("REST", entity_name)
	$CollisionShape2D.shape.height = 20 * entity_name.length()

var flag = false

func _on_word_changed(new_word):
	check_match(new_word)

func check_match(word):
	yield(get_tree(), "idle_frame")
	if entity_name.to_lower().begins_with(word.to_lower()):
		var temp_string = bbc.replace("TYPED",word).replace("REST", entity_name.right(word.length()))
		$Label.bbcode_text=temp_string
	else:
		$Label.bbcode_text = bbc.replace("TYPED","").replace("REST", entity_name)
	
func set_entity(_entity):
	entity = _entity
	entity_name = entity.entity_name

func change_name(entity):
	set_entity(entity)
	$Label.bbcode_text = bbc.replace("TYPED","").replace("REST", entity_name)
	print(entity_name)

func _physics_process(delta):
	if entity == null:
		return
	var dir = entity.global_position - global_position + Vector2(0, -50)
	velocity = velocity.normalized() + dir.normalized()
	velocity = velocity.normalized()
	move_and_collide(velocity * MOVE_SPEED * (min(1, dir.length() / 50)) * delta)
