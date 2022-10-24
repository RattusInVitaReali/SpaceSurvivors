extends Enemy
class_name Boss


const bbc = "[center][color=red][wave amp=20 freq=5][b]TYPED[/b][/wave][/color]REST[/center]"

var current_boss_name = ""
var current_stage = 0

func _ready():
	change_name()
	Autoload.connect("word_changed", self, "_on_word_changed")
	$Label.bbcode_text = bbc.replace("TYPED","").replace("REST", current_boss_name)

var flag = false

var chars1 = "abcdefghijklmnopqrstuvwxyz"
var chars2 = chars1 + "1234567890"
var chars3 = chars2 + "[];/.,"
var chars4 = chars3 + "<>?{}|~`"
var chars5 = chars4 + "!@#$%^&*()_+-"

func generate_name():
	match current_stage:
		1:
			return generate_word(chars1, 4)
		2:
			return generate_word(chars2, 5)
		3:
			return generate_word(chars3, 6)
		4:
			return generate_word(chars4, 7)
		5:
			return generate_word(chars5, 9)

func generate_word(chars, length):
	var word = ""
	var n_char = len(chars)
	for _i in range(length):
		word += chars[randi()% n_char]
	return word


func _on_word_changed(new_word):
	check_match(new_word)

func give_ability():
	pass

func nuke_me():
	pass

func freeze():
	pass

func check_match(word):
	yield(get_tree(), "idle_frame")
	if current_boss_name.to_lower().begins_with(word.to_lower()):
		var temp_string = bbc.replace("TYPED",word).replace("REST", current_boss_name.right(word.length()))
		$Label.bbcode_text=temp_string
	else:
		$Label.bbcode_text = bbc.replace("TYPED","").replace("REST", current_boss_name)
	
	if word.to_lower() == current_boss_name and current_stage == 5:
		Autoload.emit_signal("reset_word")
		Autoload.emit_signal("boss_layer_broken",self, true)
	elif word.to_lower() == current_boss_name:
		Autoload.emit_signal("reset_word")
		Autoload.emit_signal("boss_layer_broken",self,true)
		
func change_name():
	current_stage += 1
	if current_stage > 5:
		return
	var new_name = generate_name()
	current_boss_name = new_name
	$Label.bbcode_text = bbc.replace("TYPED","").replace("REST", current_boss_name)
	print(current_boss_name)
	
func die(first=true):
	print(current_stage)
	if  current_stage == 5: 
		print("dying")
		$AnimatedSprite2.show()
		$AnimatedSprite2.play("default")
		yield(get_tree().create_timer(0.4),"timeout")
		$AnimatedSprite3.show()
		$AnimatedSprite3.play("default")
		yield(get_tree().create_timer(0.4),"timeout")
		$AnimatedSprite4.show()
		$AnimatedSprite4.play("default")
		yield($AnimatedSprite4, "animation_finished")
		queue_free()
		Autoload.emit_signal("boss_defeated")
	else:
		change_name()
		$AnimatedSprite3.show()
		$AnimatedSprite3.frame = 0
		$AnimatedSprite3.play("default")

func _on_AnimatedSprite3_animation_finished():
	$AnimatedSprite3.hide()
