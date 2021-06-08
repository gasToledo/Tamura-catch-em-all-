extends Node2D

const BASIC_LEVEL = 5
export (PackedScene) var Bomb

var level = 0
var screensize = Vector2.ZERO


func _ready():
	randomize()
	OS.center_window()
	screensize = get_viewport().get_visible_rect().size
	print(str(screensize.x) + "X" + str(screensize.y))
	spawn_bombs()


func _process(delta):
	if $BombContainer.get_child_count() == 0:
		level += 1
		spawn_bombs()


##Metodo para spawnear bombas
func spawn_bombs():
	for index in range(BASIC_LEVEL + level):
		var Bomba = Bomb.instance()
		##La linea 29 asegura que las bombas no salgan del rango visible del jugador
		Bomba.position = Vector2(rand_range(0,screensize.x), rand_range(0,screensize.y))
		$BombContainer.add_child(Bomba)

