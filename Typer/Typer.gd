extends Node2D
class_name Typer

onready var label = $CanvasLayer/Label

var word = '' setget set_word

func _ready():
	Autoload.connect("enemy_died", self, "_on_enemy_died")
	Autoload.connect("reset_word", self, "reset_word")

func set_word(_word):
	word = _word
	label.text = word
	Autoload.new_word(word)

func _unhandled_key_input(event):
	if event.is_action_pressed("ui_accept"):
		if Autoload.choosing_name:
			Autoload.player.set_entity_name(word)
			reset_word()
			Autoload.emit_signal("start_game")
			return
	var text = event.as_text()
	var temp_word = word
	if not event.pressed:
		return
	if event.scancode == KEY_BACKSPACE:
		temp_word.erase(word.length() - 1, 1)
	elif text.length() == 1:
		temp_word += event.as_text()
	elif event is InputEventKey:
		temp_word += char(event.unicode)
	set_word(temp_word)

func _on_enemy_died(_enemy, first):
	if first:
		reset_word()

func reset_word():
	set_word("")
