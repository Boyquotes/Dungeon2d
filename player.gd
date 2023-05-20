extends CharacterBody2D

@onready var sprite = $Sprite2D

@export var move_speed : float = 100
@export var health : float = 10

var knockback = Vector2.ZERO
var knockbackTween

var touching_enemy = false
var contact_time = 0
var enemy

func _physics_process(_delta):
	var input_direction = Vector2(
		Input.get_action_strength('right')-Input.get_action_strength('left'),
		Input.get_action_strength('down')-Input.get_action_strength('up')
	)
	
	input_direction = input_direction.normalized()
	var movement = input_direction * move_speed
	velocity = movement + knockback
	
	move_and_slide()
	
	if touching_enemy:
		contact_time += _delta
	if contact_time > 0.3:
		contact_time = 0
		
		var knockback_direction = (position - enemy.position)
		knockback_direction = knockback_direction.normalized()
		
		_hit(1, knockback_direction*100)
	




func _on_area_2d_body_entered(body):
	enemy = body
	
	touching_enemy = true
	contact_time = 0
	
	var knockback_direction = (position - enemy.position)
	knockback_direction = knockback_direction.normalized()
	
	_hit(1, knockback_direction*100)


func _on_area_2d_body_exited(body):
	touching_enemy = false
	


func _hit(damage : float, knockback_strength : Vector2 = Vector2.ZERO, stop_time : float = 0.25):
	var rng = RandomNumberGenerator.new()
	
	health -= damage
	
	#if health <= 0:
		#die
		#queue_free()
	#el
	if knockback_strength != Vector2.ZERO:
		knockback = knockback_strength.rotated(deg_to_rad(rng.randf_range(-20.0, 20.0)))
		
		if knockbackTween:
			knockbackTween.kill()
		
		knockbackTween = get_tree().create_tween()
		knockbackTween.parallel().tween_property(self, "knockback", Vector2.ZERO, stop_time)
		
		sprite.modulate = Color(1, 0, 0, 1)
		knockbackTween.parallel().tween_property(sprite, "modulate", Color(1, 1, 1, 1), stop_time)
