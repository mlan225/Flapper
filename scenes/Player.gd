extends Node2D

## Spots that the player can move to in the scene
var playerTableNodes = []
## Current table of the player
var currentTableIndex
var currentTableEggSpawn

@export var Egg : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playerTableNodes = GetPlayerTableNodes()
	currentTableIndex = 0
	position = GetTableSpotPosition(0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GetInput()

## Search for table nodes in scene in order starting from 0 and return array of these nodes player positions
func GetPlayerTableNodes() -> Array:
	# Nodes will be obtained in order of the scene tree, for now I will assume the order in tree is the correct order
	return get_tree().get_root().get_node("Level1").get_node("Tables").get_children()


func GetInput():
#	movement inputs
	if Input.is_action_just_pressed("Up"):
		MoveToTable(-1)
	if Input.is_action_just_pressed("Down"):
		MoveToTable(1)
#	throw egg inputs. Will seperate all egg inputs for now, may consolidate this function later
	if Input.is_action_just_pressed("AEgg"):
		ThrowAEgg()

## Move player to another table. Loop to end of the array if you go outside of the bounds
func MoveToTable(direction: int):
	currentTableIndex += direction
	# may not be necessary to check for negative numbers if negative indexes are relative to the end of the array?
	if(currentTableIndex < 0):
		currentTableIndex = playerTableNodes.size() - 1
	if(currentTableIndex > playerTableNodes.size() - 1):
		currentTableIndex = 0
	
	position = GetTableSpotPosition(currentTableIndex)
	
## Get the global position of a table player spot from the playerTablesNodes array by the index
func GetTableSpotPosition(index: int):
	#set the egg position to use for throwEgg functions while setting table
	currentTableEggSpawn = playerTableNodes[currentTableIndex].get_node("EggSpawn").global_position
	
	return playerTableNodes[currentTableIndex].get_node("PlayerSpot").global_position
	
#Egg A	
func ThrowAEgg() -> void:
	var egg = Egg.instantiate()
	owner.add_child(egg)
	egg.position = currentTableEggSpawn
	egg.SetCollisionMask(2)
