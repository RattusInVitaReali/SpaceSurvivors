extends Node2D

#abilities
var unlocked_abilities = {'freeze': true, 'nuke': true, 'shield': false}

var unlock_order = ['shield', 'freeze', 'nuke']
var unlocked = 0

func activate_freeze():
	if $FreezeCD.is_stopped() and unlocked_abilities["freeze"]:
		Autoload.emit_signal("freeze")
		$FreezeTimer.start()
		$FreezeCD.start()
		
func activate_shield():
	if $ShieldCD.is_stopped() and unlocked_abilities["shield"]:
		Autoload.player.activate_shield()
		$ShieldCD.start()

func activate_nuke():
	if $NukeCD.is_stopped() and unlocked_abilities["nuke"]:
		Autoload.emit_signal("nuke")
		$NukeCD.start()

func _process(_delta):
	$ShieldCD.paused = Autoload.paused
	$FreezeCD.paused = Autoload.paused
	$FreezeTimer.paused = Autoload.paused
	$NukeCD.paused = Autoload.paused

func _ready():
	Autoload.Abilities = self
	Autoload.connect("word_changed", self, "_on_word_changed")
	Autoload.connect("boss_defeated", self, "_on_boss_defeated")
	
func _on_word_changed(word):
	if Autoload.paused:
		return
	match word.to_lower():
		"freeze":
			activate_freeze()
			Autoload.emit_signal("reset_word")
		"shield":
			activate_shield()
			Autoload.emit_signal("reset_word")
		"spacevirus":
			activate_nuke()
			Autoload.emit_signal("reset_word")

func _on_boss_defeated():
	if unlocked <= 2:
		unlocked_abilities[unlock_order[unlocked]] = true
		unlocked += 1

func _on_FreezeTimer_timeout():
	Autoload.emit_signal("unfreeze")
