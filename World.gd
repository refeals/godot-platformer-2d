extends Node2D

onready var tilemap = $TileMap
onready var camera2d = $Player/Camera2D

func _ready() -> void:
	camera2d.limit_top = 0
	camera2d.limit_left = 0
	camera2d.limit_bottom = 0
	camera2d.limit_right = 0
	pass # Replace with function body.
	emit_signal()
