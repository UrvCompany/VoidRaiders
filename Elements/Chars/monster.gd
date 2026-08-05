extends CharacterBody2D

const BULLET_SCENE = preload("res://Elements/Misc_objects/enemy_bullet.tscn")
@onready var raycast_left := $RayCast_left
@onready var raycast_right := $RayCast_right

var is_destroyed := false


func _physics_process(delta):
	if raycast_left.is_colliding() or raycast_right.is_colliding():
		get_tree().call_group("enemy_group", "change_direction")

func destroy():
	Globals.change_points(1)
	queue_free()
	Events.enemy_died.emit()
	
func shot():
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position += global_position + Vector2(0, 20.0)
	add_child(bullet)
