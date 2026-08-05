extends CharacterBody2D

const ROCKET_SCENE = preload("res://Elements/Misc_objects/Fireball.tscn")
@onready var shoot_sound = $AudioStreamPlayer2D
@onready var sprite = $Sprite2D

const SPEED = 300.0
const MAX_TILT = 10.0
const TILT_SPEED = 4.0

var can_take_damage := true

func _physics_process(delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		shot()
	var direction_x := Input.get_axis("ui_left", "ui_right")
	var direction_y := Input.get_axis("ui_up", "ui_down")
	
	velocity.x = direction_x * SPEED
	velocity.y = direction_y * SPEED
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.is_in_group("enemy"):
			take_damage()
	
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
	if not can_take_damage:
		return
	
	can_take_damage = false
	Globals.change_lives(-1)
	
	var blink_time := 0.25
	var damage_timer := 0.0
	
	while damage_timer < 1.5:
		sprite.visible = !sprite.visible
		await get_tree().create_timer(blink_time).timeout
		damage_timer += blink_time
	
	sprite.visible = true
	can_take_damage = true
	
	
func collect_coin():
	Globals.change_points(5)
	
	
