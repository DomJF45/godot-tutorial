extends Node2D

@export var player_controler : PlayerController
@export var animation_player : AnimationPlayer
@export var sprite : Sprite2D

const LEFT = -1
const RIGHT = 1
enum MOVEMENT {LEFT, RIGHT}

func _process(delta):
	if player_controler.direction == RIGHT:
		sprite.flip_h = false
	elif player_controler.direction == LEFT:
		sprite.flip_h = true
	
	if abs(player_controler.velocity.x) > 0.0:
		animation_player.play("move")
	else:
		animation_player.play("idle")

	if player_controler.velocity.y < 0.0:
		animation_player.play("jump")
	elif player_controler.velocity.y > 0.0:
		animation_player.play("fall")
