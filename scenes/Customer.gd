extends CharacterBody2D

var speed = 200;
var canMove = false;
var isMoving = false;

@onready var movementTimer = $MovementTimer

# Customer movement = move forward for a set time and then stop. Do this in repitition down the table line
func _process(delta: float) -> void:
	if(canMove):
		Movement()
	
func StartMovement() -> void:
	movementTimer.start()
	canMove = true

func Movement() -> void:
	if(isMoving):
		# move forward for a set time and stop. Repeat
		velocity = Vector2(1,0) * speed
		move_and_slide()
	
func _on_movement_timer_timeout() -> void:
	isMoving = !isMoving
