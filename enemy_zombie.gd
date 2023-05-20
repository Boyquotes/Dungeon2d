extends CharacterBody2D

var max_speed = 40
var vel = Vector2.ZERO
var direction = Vector2.ZERO
var acceleration = 1
var status = "wander"
var player = null


func _physics_process(delta):
	if status == "chase":
		
		direction = Vector2(player.position.x - position.x, player.position.y - position.y).normalized()
		
		if(velocity.length() < max_speed):
			velocity = velocity + direction * acceleration
		else:
			velocity = direction.normalized() * max_speed
	
	
	else:
		velocity *= 0.95
		
	
	move_and_slide()

func _on_detection_area_body_entered(body):
	status = "chase"
	player = body


func _on_detection_area_body_exited(body):
	status = "wander"
	player = null
