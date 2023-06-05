extends RigidBody2D

class_name Pig

@export var health = 5
@export var point = 5

func _ready():
	await get_tree().create_timer(3).timeout
	contact_monitor = true

func _on_body_entered(body):
	if is_instance_valid(body) and body is RigidBody2D:
		
		if body is Bird:
			queue_free()
		else:
			body = body as RigidBody2D
			
			var damage = body.linear_velocity.length() * 0.01
			health -= damage
			
			if health <= 0:
				GameManager.add_score(point)
				queue_free()
