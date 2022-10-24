extends Panel

onready var u1_name = $HBoxContainer/Panel/VBoxContainer/Name
onready var u2_name = $HBoxContainer/Panel2/VBoxContainer/Name

onready var u1_icon = $HBoxContainer/Panel/VBoxContainer/Icon
onready var u2_icon = $HBoxContainer/Panel2/VBoxContainer/Icon

onready var u1_desc = $HBoxContainer/Panel/VBoxContainer/Desc
onready var u2_desc = $HBoxContainer/Panel2/VBoxContainer/Desc

func _ready():
	Autoload.connect("word_changed", self, "_on_word_changed")
	Autoload.connect("get_upgrade", self, "generate_upgrades")

var upgrade1
var upgrade2

func generate_upgrades():
	show()
	upgrade1 = Autoload.RANDOM.randi() % 4
	upgrade2 = Autoload.RANDOM.randi() % 4
	if upgrade2 == upgrade1:
		upgrade2 += 1
		upgrade2 %= 4

	u1_name.text = Autoload.upgrade_dict[upgrade1][0]
	u1_desc.text = Autoload.upgrade_dict[upgrade1][1]
	u1_icon.texture = Autoload.upgrade_dict[upgrade1][2]
	
	u2_name.text = Autoload.upgrade_dict[upgrade2][0]
	u2_desc.text = Autoload.upgrade_dict[upgrade2][1]
	u2_icon.texture = Autoload.upgrade_dict[upgrade2][2]

func _on_Upgrade2_pressed():
	Autoload.player.set(
		Autoload.upgrade_dict[upgrade2][3], 
		Autoload.player.get(Autoload.upgrade_dict[upgrade2][3]) + 1)
	hide()
	Autoload.paused = false


func _on_Upgrade1_pressed():
	Autoload.player.set(
		Autoload.upgrade_dict[upgrade1][3], 
		Autoload.player.get(Autoload.upgrade_dict[upgrade1][3]) + 1)
	hide()
	Autoload.paused = false
	

func _on_word_changed(word):
	if not visible:
		return
	match word.to_lower():
		"left": 
			_on_Upgrade1_pressed()
			Autoload.emit_signal("reset_word")
		"right":
			_on_Upgrade2_pressed()
			Autoload.emit_signal("reset_word")
