extends KinematicBody2D
export (int) var gravity_power
export (int) var jump_power
export (int) var speed

var velocity = Vector2.ZERO # = Vector2(0, 0)

enum {IDLE, RUN, RUN_BACKWARD, KNIFE_ATTACK, MOCK, JUMP, LANDING}

var state
var current_anim
var new_anim
onready var Star_platinum = get_parent() 



#ARREGLAR EL ENEMIGO
func _ready():
	$Attack_hitbox.disabled = true
	randomize()
	set_timer_interval()
	$JumpTimer.wait_time = rand_range(2,4)
	$JumpTimer.start()
	transition_to(IDLE)


func transition_to(new_state):
	state = new_state
	match (state):
		IDLE:
			new_anim = "Idle"
		RUN:
			new_anim = "Run"
		RUN_BACKWARD:
			new_anim = "Run_Backward"
		KNIFE_ATTACK:
			new_anim = "KnifeAttack"
		MOCK:
			new_anim = "Mock"
		JUMP:
			new_anim = "Jump"
		LANDING:
			new_anim = "Landing"
 

func _process(_delta):
	if new_anim != current_anim:
		current_anim = new_anim
		$AnimatedSprite.play(current_anim)
	
#Si no estas en el piso, debes moverte
	if not is_on_floor() :
		velocity.x = speed
	else:
		velocity.x = 0
	
	$AnimatedSprite.flip_h = (speed < 0)
	
#Transicion al estado de caer; si "no estamos en el suelo"
#Y la velocidad de "Y" es mayor a 0; 
	if not is_on_floor() and velocity.y > 0 and Star_platinum.za_warudo_flag == false:
		transition_to(LANDING)
	if is_on_floor() and state == LANDING and Star_platinum.za_warudo_flag == false:
		transition_to(IDLE)




func _physics_process(delta):
	velocity.y += gravity_power * delta
	velocity = move_and_slide(velocity, Vector2.UP)




func set_timer_interval():
	#Timer de "Mock"
	var interval = rand_range(4, 6)
	$Timer.wait_time = interval
	$Timer.start()


#Timer para respirar ()
func _on_Timer_timeout():
	var Star_platinum = get_parent() 
	$Timer.stop()
	if state == IDLE and Star_platinum.za_warudo_flag == false:
		transition_to(MOCK)
		$Mock_audio.play()
	set_timer_interval() 


func _enable_hitbox():
	if $AnimatedSprite.animation == "Mock" and $AnimatedSprite.frame == 4 :
		$Attack_hitbox.disabled = true #Devolver false, para activar la Hitbox


func _on_AnimatedSprite_animation_finished():
	#Si una vez que la animacion que es igual a "Mock" finaliza se transiciona a "Idle"
	if $AnimatedSprite.animation == "Mock":
		$Attack_hitbox.disabled = true
		transition_to(IDLE)


func _on_Jump_timeout():
	$JumpTimer.stop() #Se apaga
	if state == IDLE and Star_platinum.za_warudo_flag == false:
		velocity.y = jump_power
		transition_to(JUMP)
		$Jump_audio.play()
		update_speed_direccion()
	
	#Timer de "Jump"
	$JumpTimer.wait_time =  rand_range(2, 4)
	$JumpTimer.start()


func update_speed_direccion():
	var pulso = bool(randi() % 2) #Devuelve un entero entre los intervalos 0 | 1
	if pulso == true and Star_platinum.za_warudo_flag == false:
		speed = speed * 1
		$Attack_hitbox.position.x *= 1
	else:#False
		speed = speed * -1
		$Attack_hitbox.position.x *= -1







