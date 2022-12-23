extends KinematicBody2D

# Boid parameters
var id : String = ""
export (Vector2) var speed := Vector2(5000, 0)  # pixel/???
export (int) var detection_radius := 80  # pixel
export (float, 0.01, 0.99) var protection_radius := 0.3  # %
export (float, 0.01, 0.99) var separation := 0.5  # %
export (float, 0.01, 0.99) var aligment := 0.5  # %
export (float, 0.01, 0.99) var cohesion := 0.5  # %
# Scenes and objects
onready var detection_area = $Area2D

# Magics

func _ready() -> void:
	randomize()
	$Area2D/CollisionShape2D.shape.radius = detection_radius


func _process(delta) -> void:
	
	var boids = detection_area.get_overlapping_bodies()
	var closed_delta = Vector2(0, 0)
	for boid in get_boids_in_protection():
		closed_delta.x += position.x - boid.position.x
		closed_delta.y += position.y - boid.position.y
	
	speed += closed_delta * separation
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
