extends Node2D
@onready var shoot_sound = $AudioStreamPlayer

const GAME_OVER_SCENE = preload("res://UI/GameOver/game_over.tscn")

func gameover(lives): 
	print("CHECK GAME OVER")
	check_game_over()

func _ready():
	Events.lives_changed.connect(gameover)
	Events.enemy_died.connect(check_game_over)

func check_game_over():	
	var enemies = get_tree().get_nodes_in_group('enemy')
	if Globals.lives <= 0 or enemies.size() <= 1:
		shoot_sound.play()
		add_child(GAME_OVER_SCENE.instantiate())
		
