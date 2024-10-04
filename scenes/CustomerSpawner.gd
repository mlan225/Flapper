extends Node2D

var CustomerScene = preload("res://scenes/Customer.tscn")

@export var CurrentSpawnCount = 0
## when customer pool is active, it will spawn enemies
@export var PoolActive = false
@export var SpawnLimit = 0
@export var CanSpawn = true

var spawnNodes = []

func _ready() -> void:
	GetSpawnPoints()
	StartPool()

func _process(delta: float) -> void:
#	if the is off cooldown and can spawn customers
	if(PoolActive && CanSpawn):
		SpawnCustomer()
		PoolCooldown()

#Spawn pool cooldown to prevent it from firing every frame in process
func PoolCooldown() -> void:
	var cooldown = GetRandomNumber(1,3)
	CanSpawn = false
	await get_tree().create_timer(cooldown).timeout
	CanSpawn = true

func StartPool() -> void:
	PoolActive = true
	
func StopPool() -> void:
	PoolActive = false
	
func SetSpawnLimit(limit: int) -> void:
	SpawnLimit = limit
	
# Get table nodes to loop through and assign spawn positions
func GetSpawnPoints() -> void:
	var tableNodes = get_tree().get_root().get_node("Level1").get_node("Tables").get_children()
	
	if(tableNodes.size() > 0):
		for node in tableNodes:
			spawnNodes.append(node.get_node("TableSpawn").global_position)

func GetRandomNumber(minRange: int, maxRange: int) -> int:
	var rngGenerator = RandomNumberGenerator.new()
	return rngGenerator.randi_range(minRange, maxRange)
		
## Send a randomly selected customer to a randomly selected spawn point
func SpawnCustomer() -> void:	
	if(spawnNodes.size() > 0):
		var spawnPosition = spawnNodes[GetRandomNumber(0, spawnNodes.size() - 1)]
		
		CreateCustomerNode(spawnPosition)

#Create customer node, allow for creating different types of customers here (start with color and layer mask)
func CreateCustomerNode(spawnPosition: Vector2) -> void:
	var customerNode = CustomerScene.instantiate()
	customerNode.position = spawnPosition
	customerNode.get_node("CustomerSprite").texture = load("res://assets/kenney_puzzle-pack/png/element_green_polygon.png")
	customerNode.set_collision_layer_value(3, true)
	customerNode.set_collision_mask_value(1, true)
#	temporary add for now, i'd like to keep a child of the customerPool. But the positions won't
#	set correctly if not outside of customer spawner node
	owner.add_child(customerNode)
	customerNode.StartMovement()	
