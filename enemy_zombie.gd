extends CharacterBody2D

@export var max_speed : float = 40
@export var acceleration : float = 2
@export var hit_radius : float = 8

var vel = Vector2.ZERO
var distance = Vector2.ZERO
var direction = Vector2.ZERO
var status = "wander"
var player = null

@onready var sprite = $Sprite2D

func _physics_process(delta):
	if status == "chase":
		distance = Vector2(player.position.x - position.x, player.position.y - position.y)
		direction = distance.normalized()
		
		if(distance.length() > hit_radius):
			if(velocity.length() < max_speed):
				velocity = velocity + direction * acceleration
			else:
				velocity = direction.normalized() * max_speed
		else:
			velocity = velocity * 0.75
	else:
		velocity *= 0.9
		
	if direction.x > 0:
		sprite.flip_h = true
	if direction.x < 0:
		sprite.flip_h = false
		
	
	move_and_slide()

func _on_detection_area_body_entered(body):
	status = "chase"
	player = body


func _on_detection_area_body_exited(body):
	status = "wander"
	player = null
