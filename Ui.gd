extends Control

var start_time

# Called when the node enters the scene tree for the first time.
func _ready():
	Autoload.paused = true
	start_time = OS.get_unix_time()
	Autoload.connect("word_changed", self, "_on_word_changed")
	Autoload.connect("start_game", self, "_on_start_game")
	Autoload.connect("defeat",self,"_on_defeat")

func _process(delta):
	if Autoload.paused: return
	$Level.text = "Level " + str(Autoload.player.level)
	var elapsed_time = OS.get_unix_time() - start_time
	var mins = elapsed_time / 60
	var secs = elapsed_time % 60
	$Time.text = "%02d:%02d" % [mins, secs]
	$XP.value = float(Autoload.player.xp) / Autoload.player.needed_xp * 100

func _on_word_changed(word):
	if not visible:
		return
	match word.to_lower():
		"start":
			Autoload.choosing_name = true
			$StartMenu/CenterContainer/VBoxContainer/StartScreen.hide()
			$StartMenu/CenterContainer/VBoxContainer/NameScreen.show()
			Autoload.emit_signal("reset_word")
		"pause": 
			$PauseMenu.show()
			Autoload.paused=true
			Autoload.emit_signal("reset_word")
		"continue":
			if Autoload.paused: 
				Autoload.paused=false
				$PauseMenu.hide()
				Autoload.emit_signal("reset_word")
		"exit":
			if Autoload.paused:
				get_tree().quit()

func _on_start_game():
	Autoload.paused = false
	$StartMenu.hide()
	Autoload.choosing_name = false
	start_time = OS.get_unix_time()

func _on_defeat():
	var time = $Time.text
	var totalTime = "You survived for a total of " + time 
	$DeathMenu.show()
	$DeathMenu/CenterContainer/VBoxContainer/ScoreLabel.text = totalTime

