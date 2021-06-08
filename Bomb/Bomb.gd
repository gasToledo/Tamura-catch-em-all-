extends Area2D
 
func _ready():
	#Efecto de escalado x2
	$Tween.interpolate_property(
		$AnimatedSprite,
		'scale', 
		$AnimatedSprite.scale, 
		$AnimatedSprite.scale * 3, 
		0.3,
		Tween.TRANS_QUAD, 
		Tween.EASE_IN_OUT
	)
	#Efecto de desvanecimiento
	$Tween.interpolate_property(
		$AnimatedSprite,
		'modulate', 
		Color(1, 1, 1, 1), 
		Color(1, 1, 1, 0), 
		0.3,
		Tween.TRANS_QUAD, 
		Tween.EASE_IN_OUT
	)


func pickup():
	$Tween.start() #Comienza lo que sea que tengas dentro del Tween
	yield($Tween, "tween_completed") # Permite que la funcion termine antes de seguir con la siguiente
	call_deferred("queue_free") #Elimina el nodo

