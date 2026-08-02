extends CharacterBody2D

const BULLET_SCENE = preload("res://Elements/Misc_objects/enemy_bullet.tscn")
@onready var raycast_left := $RayCast_left
@onready var raycast_right := $RayCast_right

func _physics_process(delta):
	if raycast_left.is_colliding() or raycast_right.is_colliding():
		get_tree().call_group("enemy_group", "change_direction")

func destroy():
	queue_free()

func shot():
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position += global_position + Vector2(0, 20.0)
	add_child(bullet)
