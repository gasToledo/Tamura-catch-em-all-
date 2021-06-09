extends KinematicBody2D
export (int) var gravity_power
export (int) var jump_power
export (int) var speed

var velocity = Vector2.ZERO # = Vector2(0, 0)

enum {IDLE, RUN, RUN_BACKWARD, KNIFE_ATTACK, MOCK}

var state
var current_anim
var new_anim




#ARREGLAR EL ENEMIGO
func _ready():
	set_timer_interval()
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
 

func _process(delta):
	if new_anim != current_anim:
		current_anim = new_anim
		$AnimatedSprite.play(current_anim)


func _physics_process(delta):
	velocity.y += gravity_power * delta
	velocity = move_and_slide(velocity, Vector2.UP)




func set_timer_interval():
	var interval = rand_range(5, 8)
	$Timer.wait_time = interval
	$Timer.start()


#Timer para respirar ()
func _on_Timer_timeout():
	$Timer.stop()
	if state == IDLE:
		transition_to(MOCK)
	set_timer_interval() 



func _on_AnimatedSprite_animation_finished():
	#Si una vez que la animacion que es igual a "Mock" finaliza se transiciona a "Idle"
	if $AnimatedSprite.animation == "Mock":
		transition_to(IDLE)
