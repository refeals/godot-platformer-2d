extends KinematicBody2D

const TARGET_FPS = 60 

var direction = 0
var motion = Vector2(230, 0)

func _process(delta: float) -> void:
	motion.x += direction * delta * TARGET_FPS
	motion = move_and_slide(motion, Vector2.UP)
