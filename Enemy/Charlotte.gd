extends KinematicBody2D
export (int) var gravity_power
export (int) var jump_power
export (int) var speed

var velocity = Vector2.ZERO # = Vector2(0, 0)

enum {IDLE, RUN, RUN_BACKWARD, KNIFE_ATTACK, MOCK, JUMP, LANDING}

var state
var current_anim
var new_anim




#ARREGLAR EL ENEMIGO
func _ready():
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
 

func _process(delta):
	if new_anim != current_anim:
		current_anim = new_anim
		$AnimatedSprite.play(current_anim)
	
#Si no estas en el piso, debes moverte
	if not is_on_floor():
		velocity.x = speed
	else:
		velocity.x = 0
	
	$AnimatedSprite.flip_h = (speed < 0)
	
#Transicion al estado de caer; si "no estamos en el suelo"
#Y la velocidad de "Y" es mayor a 0; 
	if not is_on_floor() and velocity.y > 0:
		transition_to(LANDING)
	if is_on_floor() and state == LANDING:
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
	$Timer.stop()
	if state == IDLE:
		transition_to(MOCK)
		$Mock_audio.play()
	set_timer_interval() 



func _on_AnimatedSprite_animation_finished():
	#Si una vez que la animacion que es igual a "Mock" finaliza se transiciona a "Idle"
	if $AnimatedSprite.animation == "Mock":
		transition_to(IDLE)


func _on_Jump_timeout():
	$JumpTimer.stop() #Se apaga
	if state == IDLE:
		velocity.y = jump_power
		transition_to(JUMP)
		$Jump_audio.play()
		update_speed_direccion()
	
	#Timer de "Jump"
	$JumpTimer.wait_time =  rand_range(2, 4)
	$JumpTimer.start()


func update_speed_direccion():
	var pulso = bool(randi() % 2) #Devuelve un entero entre los intervalos 0 | 1
	if pulso == true :
		speed = speed * 1
	else:#False
		speed = speed * -1 
