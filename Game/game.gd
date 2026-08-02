extends Node2D
@onready var shoot_sound = $AudioStreamPlayer

const GAME_OVER_SCENE = preload("res://UI/GameOver/game_over.tscn")

func _ready():
	Events.lives_changed.connect(_on_lives_changed)
	Events.enemy_died.connect(_on_enemy_died)

func _on_lives_changed(lives: int):
	if lives <= 0:
		show_game_over()

func _on_enemy_died():
	var enemies = get_tree().get_nodes_in_group('enemy')
	print(enemies.size())
	if enemies.size() <= 1:
		show_game_over() # TODO: заменить на экран победы, когда появится

func show_game_over():
	shoot_sound.play()
	add_child(GAME_OVER_SCENE.instantiate())
