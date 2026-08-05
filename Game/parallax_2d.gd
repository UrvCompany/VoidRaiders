extends Parallax2D

@export var speed := 100.0


func _process(delta):
	scroll_offset.y += speed * delta
	
