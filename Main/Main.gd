extends Node2D

const BASIC_LEVEL = 5
export (PackedScene) var Bomb

var level = 0
var screensize = Vector2.ZERO
var time_left = 0
var actual_level = 1
var score = 0
var time_plus = 5
var level_plus = 1


func _ready():
	randomize()
	OS.center_window()
	time_left = 30
	$HUD.update_timer(time_left)
	screensize = get_viewport().get_visible_rect().size
	spawn_bombs()


func _process(delta):
	if $BombContainer.get_child_count() == 0:
		level += level_plus
		time_left += time_plus
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
		$GameTimer.stop()
		print("Game Over!")


func _on_Player_picked():
	score += 1
	$HUD.update_score(score)

func _next_level():
	actual_level += 1
	$HUD.update_level(actual_level)
