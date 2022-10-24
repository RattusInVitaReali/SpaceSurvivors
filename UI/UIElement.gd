extends RichTextLabel

export var entity_name = ""

const bbc = "[center][color=yellow][wave amp=20 freq=5][b]TYPED[/b][/wave][/color]REST[/center]"

var velocity = Vector2(0,0)

func _ready():
	Autoload.connect("word_changed", self, "_on_word_changed")
	bbcode_enabled=true
	bbcode_text = bbc.replace("TYPED","").replace("REST", entity_name)


func _on_word_changed(new_word):
	check_match(new_word)

func check_match(word):
	yield(get_tree(), "idle_frame")
	if entity_name.to_lower().begins_with(word.to_lower()):
		var temp_string = bbc.replace("TYPED",word).replace("REST", entity_name.right(word.length()))
		bbcode_text=temp_string
	else:
		bbcode_text = bbc.replace("TYPED","").replace("REST", entity_name)
