extends Node2D

const BASIC_LEVEL = 5
const BONUS_TIME = 5
const LEVEL_PLUS = 1


export (PackedScene) var Bomb
export (PackedScene) var Charlotte

var MadokaHead = preload("res://Bomb/MadokaHead.tscn")
var level = 0
var screensize = Vector2.ZERO
var time_left = 0
var actual_level = 1
var score = 0
var za_warudo_flag = false

var levelsSumados
var pauseMenu = preload("res://PauseMenu/Pause.tscn")
var inst : Node = null
var paused = false
var touch_pause = false

onready var GameOverTimer = Timer.new()

#Volver a activar musica
func _ready():
	$Charlotte.visible = false
	randomize()
	OS.center_window()
	$GameBackgroundMusic.play()
	timer_settings()
	$HUD/GameOverLabel.visible = false
	time_left = 30 # Caution : De no estar en 30s , devolverlo a ese valor
	$HUD.update_timer(time_left)
	screensize = get_viewport().get_visible_rect().size
	spawn_bombs()
	set_MadokaHead_timer()
	$Charlotte.visible = true


func timer_settings():
	GameOverTimer.wait_time = 2
	GameOverTimer.connect("timeout",self, "_onGamerOverTimer_timeout")
	self.add_child(GameOverTimer)



func _onGamerOverTimer_timeout():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Menu/Menu.tscn")


func _process(_delta):
	update_plataform_position()
	if $BombContainer.get_child_count() == 0:
		level += LEVEL_PLUS
		time_left += BONUS_TIME
		_audio_next_level()
		_next_level()
		spawn_bombs()

#Funcion que permite a la plataforma seguir a Charlotte
func update_plataform_position():
	$Plataform.position.x = $Charlotte.position.x


#Metodo para spawnear bombas
func spawn_bombs():
	for _index in range(BASIC_LEVEL + level):
		var Bomba = Bomb.instance()
		##La linea 29 asegura que las bombas no salgan del rango visible del jugador
		Bomba.position = Vector2(rand_range(0,screensize.x), rand_range(0,screensize.y))
		$BombContainer.add_child(Bomba)



func _on_GameTimer_timeout():
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_Player_picked(type): #Type puede ser "bomb" o "MadokaHead"
	match type:
		"bomb":
			score += 1
			$HUD.update_score(score)
		"MadokaHead":
			za_warudo()
			#$HUD.update_timer(time_left)

func _on_Player_hurt(type):
	if type == "enemy":
		game_over()


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
	Audio.connect("finished",self,"remove_audio", [Audio])


func _audio_lose():
	var Audio = AudioStreamPlayer.new()
	Audio.stream = preload("res://assets/Sonidos/Perder_v2.wav")
	add_child(Audio)
	Audio.volume_db = -20
	Audio.play()
	Audio.connect("finished",self,"remove_audio", [Audio])


func remove_audio(node):
	node.queue_free()

func set_MadokaHead_timer():
	var interval = rand_range(10, 15)
	$MadokaHeadTimer.wait_time = interval
	$MadokaHeadTimer.start()



func _on_MadokaHeadTimer_timeout():
	# 1. Se apaga el timer : stop()
	$MadokaHeadTimer.stop()
	# 2. crear la escena MadokaHead
	var madokaHead = MadokaHead.instance()
	madokaHead.position.x = rand_range(25, 460)
	madokaHead.position.y = rand_range(25, 700)
	# 3. agregar la escena MadokaHead al juego con : add_child("MadokaHead")
	$BombContainer.add_child(madokaHead)
		# 4. Ajustar el timeOut
	set_MadokaHead_timer()
 
func za_warudo():
	#1. Parar el contador de tiempo
	za_warudo_flag = true
	$EnterZaWarudo.play()
	$GameTimer.stop()
	_enemy_actions_stop()
	if $GameTimer.is_stopped():
		#2. Que se mantenga en stop por 5s
		yield(get_tree().create_timer(5.0), "timeout")
		$OutZaWarudo.play()
		#3. Luego de los 3s el contador debe volver a iniciarse desde donde quedo
		$GameTimer.start()
		za_warudo_flag = false
		_enemy_actions_return()


func _enemy_actions_stop():
	var anim = $Charlotte/AnimatedSprite
	#1. comprobar si se esta moviendo. 
	#2.si lo esta, detener la animacion en el frame exacto
	if anim.is_playing():
		anim.stop()

func _enemy_actions_return():
	var anim = $Charlotte/AnimatedSprite

	if anim.is_playing() == false :
		anim.play()



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_end"):
		if not paused:
			pause()
		else: resume()

func pause():
	inst = pauseMenu.instance()
	$GameBackgroundMusic.stop()
	Engine.time_scale = 0.0
	get_tree().current_scene.add_child(inst)
	paused = true

func resume():
	Engine.time_scale = 1.0
	get_tree().current_scene.remove_child(inst)
	$GameBackgroundMusic.play()
	paused = false
