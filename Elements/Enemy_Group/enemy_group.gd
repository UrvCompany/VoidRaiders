extends Node2D

@onready var block_timer := $block_timer
@onready var shoot_timer := $shoot_timer

const ROW_STEP = 20.0
const SPEED_BOOST = 10

var direction :=  Vector2.RIGHT
var speed := 80.0

func _process(delta: float):
	global_position += direction * speed * delta
	
func change_direction():
	if block_timer.time_left > 0:
		return
	direction = Vector2.LEFT if direction == Vector2.RIGHT else Vector2.RIGHT
	global_position.y += ROW_STEP
	speed += SPEED_BOOST
	block_timer.start()


func _on_shoot_timer_timeout() -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.size() > 0 :
		enemies.pick_random().shot()
	
