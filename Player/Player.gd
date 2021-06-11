extends Area2D

#Signals
signal picked
signal hurt

# Declare member variables here. Examples:
# var a = 2
var velocity = Vector2.ZERO
var speed = 350
var pauseMenu = preload("res://PauseMenu/Pause.tscn").instance()
var paused = false


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.center_window()
	position = Vector2(240, 600)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	position += velocity * delta
	
	 #que no pueda superar los bordes de pantalla
	position.x = clamp(position.x, 0, 460)
	position.y = clamp(position.y, 0, 700)

	process_animations()

func get_input():
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		if not paused:
			velocity.x = -1
	if Input.is_action_pressed("ui_right"):
		if not paused:
			velocity.x = 1
	if Input.is_action_pressed("ui_up"):
		if not paused:
			velocity.y = -1
	if Input.is_action_pressed("ui_down"):
		if not paused:
			velocity.y = 1
	if Input.is_action_just_pressed("ui_end"):
		if not paused:
			pause()
		else:
			resume()

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

func process_animations():
	# Animaciones
	if velocity.length() != 0:
		$AnimatedSprite.play("Run")
		if velocity.x < 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.play("Idle")


func _on_Player_area_entered(area):
	if area.is_in_group("bomb"):
		$BombAudio.play()
		emit_signal("picked", "bomb")
	elif area.is_in_group("MadokaHead"):
		$MadokaHeadAudio.play()
		emit_signal("picked", "MadokaHead")
	if area.has_method("pickup"):
		area.pickup()


func game_over():
	set_process(false)
	$AnimatedSprite.animation = "Hurt"


func _on_Player_body_entered(body):
	if body.is_in_group("enemy"):
		emit_signal("hurt", "enemy")

func pause():
	if not game_over():
		Engine.time_scale = 0.0
		get_tree().current_scene.add_child(pauseMenu)
		paused = true

func resume():
	Engine.time_scale = 1.0
	get_tree().current_scene.remove_child(pauseMenu)
	paused = false
