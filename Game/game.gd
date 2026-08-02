extends Node2D

@onready var shoot_sound = $GameOverSound
@onready var victory_sound = $VictorySound

var enemies_left := 0


const GAME_OVER_SCENE = preload("res://UI/GameOver/game_over.tscn")
const VICTORY_SCENE = preload("res://UI/VictoryScreen/victory.tscn")


func _ready():
	Events.lives_changed.connect(_on_lives_changed)
	Events.enemy_died.connect(_on_enemy_died)
	enemies_left = get_tree().get_nodes_in_group('enemy').size()


func _on_lives_changed(lives: int):
	if lives <= 0:
		show_game_over()

func _on_enemy_died():
	var enemies = get_tree().get_nodes_in_group('enemy')
	enemies_left -= 1
	print(enemies_left)
		
	if enemies_left <= 0:
		show_victory()

func show_game_over():
	shoot_sound.play()
	add_child(GAME_OVER_SCENE.instantiate())

func show_victory():
	victory_sound.play()
	add_child(VICTORY_SCENE.instantiate())
