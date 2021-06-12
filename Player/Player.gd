extends Area2D

#Signals
signal picked
signal hurt

# Declare member variables here. Examples:
# var a = 2
var velocity = Vector2.ZERO
var speed = 350

#touch section

var touch_left = false
var touch_right = false
var touch_up = false
var touch_down = false


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
	if Input.is_action_pressed("ui_left") or touch_left:
		velocity.x = -1
	if Input.is_action_pressed("ui_right") or touch_right:
		velocity.x = 1
	if Input.is_action_pressed("ui_up") or touch_up:
		velocity.y = -1
	if Input.is_action_pressed("ui_down") or touch_down:
		velocity.y = 1

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



func _on_LeftButton_pressed():
	touch_left = true


func _on_LeftButton_released():
	touch_left = false


func _on_RightButton_pressed():
	touch_right = true


func _on_RightButton_released():
	touch_right = false


func _on_UpButton_pressed():
	touch_up = true


func _on_UpButton_released():
	touch_up = false


func _on_DownButton_pressed():
	touch_down = true


func _on_DownButton_released():
	touch_down = false

