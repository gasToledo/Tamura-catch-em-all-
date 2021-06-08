extends Node2D

const BASIC_LEVEL = 5
const BONUS_TIME = 5
const LEVEL_PLUS = 1
export (PackedScene) var Bomb

var level = 0
var screensize = Vector2.ZERO
var time_left = 0
var actual_level = 1
var score = 0
onready var GameOverTimer = Timer.new()


func _ready():
	randomize()
	OS.center_window()
	timer_settings()
	$HUD/GameOverLabel.visible = false
	time_left = 5 # Caution : Devolver a 30 sec
	$HUD.update_timer(time_left)
	screensize = get_viewport().get_visible_rect().size
	spawn_bombs()


func timer_settings():
	GameOverTimer.wait_time = 2
	GameOverTimer.connect("timeout",self, "_onGamerOverTimer_timeout")
	self.add_child(GameOverTimer)


func _onGamerOverTimer_timeout():
	get_tree().change_scene("res://Menu/Menu.tscn")



func _process(delta):
	if $BombContainer.get_child_count() == 0:
		level += LEVEL_PLUS
		time_left += BONUS_TIME
		_audio_next_level()
		_next_level()
		spawn_bombs()


#Metodo para spawnear bombas
func spawn_bombs():
	for index in range(BASIC_LEVEL + level):
		var Bomba = Bomb.instance()
		##La linea 29 asegura que las bombas no salgan del rango visible del jugador
		Bomba.position = Vector2(rand_range(0,screensize.x), rand_range(0,screensize.y))
		$BombContainer.add_child(Bomba)



func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_Player_picked():
	score += 1
	$HUD.update_score(score)

func _next_level():
	actual_level += 1
	$HUD.update_level(actual_level)

func game_over():
	$GameTimer.stop()
	$HUD/GameOverLabel.visible = true
	$Player.game_over()
	_audio_lose()
	GameOverTimer.start()

func _audio_next_level():
	var Audio = AudioStreamPlayer.new()
	Audio.stream = preload("res://assets/Sonidos/PasarNivel_v1.wav")
	add_child(Audio)
	Audio.volume_db = -20
	Audio.play()


func _audio_lose():
	var Audio = AudioStreamPlayer.new()
	Audio.stream = preload("res://assets/Sonidos/Perder_v2.wav")
	add_child(Audio)
	Audio.volume_db = -20
	Audio.play()
