extends RigidBody2D

@export var health = 5
@export var point = 1

func _ready():
	await get_tree().create_timer(3).timeout
	contact_monitor = true

func _on_body_entered(body):
	if is_instance_valid(body) and body is RigidBody2D:
		body = body as RigidBody2D
		
		var damage_m = 0.01
		if body is Bird:
			damage_m = 0.1
		
		var damage = body.linear_velocity.length() * damage_m
		health -= damage
		
		if health <= 0:
			GameManager.add_score(point)
			queue_free()
