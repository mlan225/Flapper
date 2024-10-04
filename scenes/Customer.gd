extends CharacterBody2D

var speed = 300;
var canMove = false;
var isMoving = false;
var isPushedBack = false;
var canCatch = false;

@onready var movementTimer = $MovementTimer

# Customer movement = move forward for a set time and then stop. Do this in repitition down the table line
func _process(delta: float) -> void:
	if(canMove):
		Movement()
	
	if(isPushedBack):
		StopMovement()
		PushCustomerBack(500)
	
func StartMovement() -> void:
	movementTimer.start()
	canMove = true
	canCatch = true

func StopMovement() -> void:
	movementTimer.stop()
	canMove = false
	isMoving = false

func Movement() -> void:
	if(isMoving):
		# move forward for a set time and stop. Repeat
		velocity = Vector2(1,0) * speed
		move_and_slide()

func SetLayerMask(layerBit: int) -> void:
	$EggGrabArea.set_collision_layer_value(layerBit, true)
	
#Push back customer when an egg reaches them. I will push them back at a speed for a time limit
#instead of a specific distance

#DEV NOTE: I need to take another look at timer logic to understand how long to the catch and wait is
#I may be able to remove movementTimer node and use process function instead
func PushCustomerBack(pushBackSpeed: int):
	canCatch = false
	velocity = Vector2(-1,0) * pushBackSpeed
	move_and_slide()
	await get_tree().create_timer(1.0).timeout
	isPushedBack = false
	await get_tree().create_timer(0.5).timeout
	StartMovement()
	
func _on_movement_timer_timeout() -> void:
	isMoving = !isMoving

func _on_egg_grab_area_area_entered(area: Area2D) -> void:
	if(canCatch):
		area.get_parent().queue_free()
		isPushedBack = true
