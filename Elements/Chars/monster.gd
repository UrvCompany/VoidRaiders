extends CharacterBody2D

const BULLET_SCENE = preload("res://Elements/Misc_objects/enemy_bullet.tscn")
const COIN_SCENE = preload("res://Elements/Misc_objects/coin_scene.tscn")

@onready var raycast_left := $RayCast_left
@onready var raycast_right := $RayCast_right

var is_destroyed := false


func _physics_process(delta):
	if raycast_left.is_colliding() or raycast_right.is_colliding():
		get_tree().call_group("enemy_group", "change_direction")

func destroy():
	Globals.no_coin_count += 1

	if randf() < 0.3 or Globals.no_coin_count >= 3:
		var coin = COIN_SCENE.instantiate()
		coin.global_position = global_position
		get_tree().current_scene.add_child(coin)
		Globals.no_coin_count = 0

	Globals.change_points(1)
	queue_free()
	Events.enemy_died.emit()
	
func shot():
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position += global_position + Vector2(0, 20.0)
	add_child(bullet)
