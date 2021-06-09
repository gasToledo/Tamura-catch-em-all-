extends Control

func _ready():
	OS.center_window()
	$BackgroundMusic.play()


func _on_Button_pressed():
	get_tree().change_scene("res://Main/Main.tscn")
