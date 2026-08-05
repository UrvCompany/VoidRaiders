extends CharacterBody2D

const ROCKET_SCENE = preload("res://Elements/Misc_objects/Fireball.tscn")
@onready var shoot_sound = $AudioStreamPlayer2D
@onready var sprite = $Sprite2D

const SPEED = 300.0
const MAX_TILT = 12.0
const TILT_SPEED = 8.0

func _physics_process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		shot()
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED
	
	move_and_slide()
	
	var target_rotation = (velocity.x / SPEED) * deg_to_rad(MAX_TILT)
	sprite.rotation = lerp_angle(sprite.rotation, target_rotation, TILT_SPEED * delta)
	
	
func shot():
	var rocket = ROCKET_SCENE.instantiate()
	rocket.global_position = global_position + Vector2(0, -95)
	shoot_sound.play()
	add_child(rocket)
	
	
func destroy():
	print("samoubivsya")


func take_damage():
	Globals.change_lives(-1)
	
