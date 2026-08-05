extends CanvasLayer


func _on_restart_button_pressed():
	get_tree().paused = false
	Globals.lives = 3
	Globals.points = 0
	get_tree().reload_current_scene()
