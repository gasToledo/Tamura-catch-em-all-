extends Area2D
#1. Ajustar el timer(random, de 5s a 8s).
#2. Reproducir la animacion KnifeAttack.

#ARREGLAR EL ENEMIGO
func _ready():
	set_timer_interval()

func set_timer_interval():
	var interval = rand_range(5, 8)
	$Timer.wait_time = interval
	$Timer.start()



func _on_Timer_timeout():
	$Timer.stop()
	$AnimatedSprite.play("KnifeAttack")
	set_timer_interval() 

