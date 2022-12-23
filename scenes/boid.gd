extends KinematicBody2D

# Boid parameters
var id : String = ""
export (float) var speed :int = 5000  # pixel/???
export (int) var detection_radius :int = 80
# Scenes and objects
onready var detection_area = $Area2D

# Magics

func _ready() -> void:
	randomize()
	$Area2D/CollisionShape2D.shape.radius = detection_radius


func _process(delta) -> void:
	var velocity = Vector2(1, 0).rotated(rotation) * speed * delta
	move_and_slide(velocity)
	
	# Make the world as a donut
	if position.x > Screen.width:
		position.x = 0
	elif position.x < 0:
		position.x = Screen.width
	
	if position.y > Screen.height:
		position.y = 0
	elif position.y < 0:
		position.y = Screen.height
	
	var a = 1

# Methods

func set_random_position(width:int, height:int) -> void:
	var pad = 5
	position.x = rand_range(pad, width - pad)
	position.y = rand_range(pad, height - pad)
	rotation = deg2rad(rand_range(0, 360))
