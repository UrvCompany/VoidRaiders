extends Area2D

const FALL_SPEED :=150.0

@onready var sprite := $AnimatedSprite2D

func _ready():
	sprite.play("spin")
	blink()
	
func blink():
	for i in range(3):
		sprite.visible = false
		await get_tree().create_timer(0.08).timeout
		sprite.visible = true
		await get_tree().create_timer(0.08).timeout
		
func _process(delta):
	position.y += FALL_SPEED * delta
	
	
func _on_body_entered(body):
	print(body.get_script())
	if body.has_method("collect_coin"):
		body.collect_coin()
		$CoinSound.play()
		hide()
		$CollisionShape2D.disabled = true
		await $CoinSound.finished
		queue_free()
		


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
