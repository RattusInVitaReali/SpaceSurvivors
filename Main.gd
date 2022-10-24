extends Node2D
class_name Main

const NormalMusic = preload("res://Resources/Chronometry.mp3")
const BossMusic = preload("res://Resources/Shortwire - Reconfig.mp3")

onready var shield_tp = $CanvasLayer/Ui/AbilitiesContainer/Shield/TextureProgress
onready var freeze_tp = $CanvasLayer/Ui/AbilitiesContainer/Freeze/TextureProgress
onready var nuke_tp = $CanvasLayer/Ui/AbilitiesContainer/Nuke/TextureProgress

# if !$AudioStreamPlayer2D.is_playing():
#        $AudioStreamPlayer2D.stream = CorrectSound
#        $AudioStreamPlayer2D.play()
onready var mainPlayer = $AudioStreamPlayer

onready var shield_timer = $Abilities/ShieldCD
onready var freeze_timer = $Abilities/FreezeCD
onready var nuke_timer = $Abilities/NukeCD

func _ready():
	Autoload.player = $Player
	Autoload.connect("boss_spawned", self, "play_boss_music")
	Autoload.connect("boss_defeated", self, "play_normal_music")

func play_boss_music():
	$AudioStreamPlayer.stream = BossMusic
	$AudioStreamPlayer.play()

func play_normal_music():
	$AudioStreamPlayer.stream = NormalMusic
	$AudioStreamPlayer.play()

const shield_cd = 15
const freeze_cd = 15
const nuke_cd = 60

func _process(delta):
	shield_tp.value = shield_timer.time_left * 100.0 / shield_cd
	freeze_tp.value = freeze_timer.time_left * 100.0 / freeze_cd
	nuke_tp.value = nuke_timer.time_left * 100.0 / nuke_cd
