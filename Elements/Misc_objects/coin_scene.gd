extends Area2D

const FALL_SPEED := 150.0

@onready var sprite := $AnimatedSprite2D
@onready var coin_sound := $CoinSound


func _ready():
	sprite.play("spin")
	blink()


func blink():
	for i in range(5):
		sprite.visible = false
		await get_tree().create_timer(0.08).timeout
		sprite.visible = true
		await get_tree().create_timer(0.08).timeout


func _process(delta):
	position.y += FALL_SPEED * delta


func _on_body_entered(body):
	if body.has_method("collect_coin"):
		body.collect_coin()
		var sound = $CoinSound.duplicate()
		get_tree().current_scene.add_child(sound)
		sound.play()
		sound.finished.connect(sound.queue_free)
		$CollisionShape2D.set_deferred("disabled", true)
		hide()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
