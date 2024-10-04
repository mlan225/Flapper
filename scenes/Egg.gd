extends CharacterBody2D

var speed = 300;

# Customer movement = move forward for a set time and then stop. Do this in repitition down the table line
func _process(delta: float) -> void:
	Movement()

func Movement() -> void:
	velocity = Vector2(-1,0) * speed
	move_and_slide()

#set the collision mask in the Area2D node
func SetCollisionMask(maskBit: int) -> void:
	$Area2D.set_collision_mask_value(maskBit, true)
