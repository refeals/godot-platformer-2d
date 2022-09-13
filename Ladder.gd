extends Area2D
class_name Ladder

var player

onready var collisionShape = $StaticBody2D/CollisionShape2D

func _ready():
	player = get_node("/root/World/Player")

func _process(delta):
	pass
#	print(player.currentState == 2)
#	if player:
#		if player.position.y > position.y:
#			collisionShape.disabled = true
#			modulate.a = 0.5
#		else:
#			if player.currentState != 2:
#				collisionShape.disabled = false
#				modulate.a = 1
#			else:
#				collisionShape.disabled = true
#				modulate.a = 0.5
	
#func _input(e):
#	print(player.position.y)
#	print(position.y)
#	print(player.position.y - position.y)
#	print("=====================")
