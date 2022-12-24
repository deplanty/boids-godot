extends KinematicBody2D

# Boid parameters
var id : String = ""
# Actual speed of the boid with direction
export (Vector2) var speed := Vector2(100, 0)  # pixel/???
# The target speed
export (int) var speed_target := 5000  # pixel/???
# The acceleration rate to the target speed
export (float, 0.01, 1) var speed_target_rate := 0.7  # %
# The radius where the boid can detect other boids
export (int) var detection_radius := 80  # pixel
# The percent of the detection radius used as the protective radius
# The boid tries to get away from those in this range
export (float, 0.01, 1) var protection_radius := 0.3  # %
# Rate at which the boid get away from the others
export (float, 0.01, 1) var separation := 0.5  # %
# Rate at which the boid align with the others
export (float, 0.01, 1) var aligment := 0.5  # %
# Rate at which the boid stay close to the others
export (float, 0.01, 1) var cohesion := 0.5  # %
# Scenes and objects
onready var detection_area = $Area2D

# Magics

func _ready() -> void:
	randomize()
	$Area2D/CollisionShape2D.shape.radius = detection_radius


func _process(delta) -> void:
	
	# Detect boids in protection radius and go far from them
	var closed_delta = Vector2(0, 0)
	for boid in get_boids_in_protection():
		closed_delta.x += position.x - boid.position.x
		closed_delta.y += position.y - boid.position.y
	speed += closed_delta * separation
	
	# Adapt speed to match the target speed
	var speed_magnitude = speed.length()
	speed *= 1 + ((speed_target - speed_magnitude) / speed_magnitude) * speed_target_rate * delta
	
	# Move the boids according to the calculated speed
	move_and_slide(speed * delta)
	look_at(position + speed)
	
	# Make the world as a donut for the boids
	world_is_a_donut()

# Methods

func set_random_position(width:int, height:int) -> void:
	var pad = 5
	position.x = rand_range(pad, width - pad)
	position.y = rand_range(pad, height - pad)
	rotation = deg2rad(rand_range(0, 360))
	speed.rotated(rotation)


func world_is_a_donut():
	if position.x > Screen.width:
		position.x = 0
	elif position.x < 0:
		position.x = Screen.width
	
	if position.y > Screen.height:
		position.y = 0
	elif position.y < 0:
		position.y = Screen.height


func get_boids_in_protection() -> Array:
	var radius = detection_radius * protection_radius
	$Area2D/CollisionShape2D.shape.radius = radius
	var bodies = detection_area.get_overlapping_bodies()
	bodies.erase(self)
	$Area2D/CollisionShape2D.shape.radius = detection_radius
	return bodies
