extends RigidBody2D


var speed = 300.0
var direction = Vector2.ZERO

func _ready():
	direction.y = [-1, 1].pick_random()
	direction.x = [-1, 1].pick_random()
	linear_velocity = direction * speed
#func _physics_process(delta):
#	if direction:
#		linear_velocity = direction * speed
#	else:
#		linear_velocity = linear_velocity.move_toward(Vector2.ZERO, speed)
