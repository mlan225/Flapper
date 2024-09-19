extends Node2D

@export var CurrentSpawnCount = 0
## when customer pool is active, it will spawn enemies
@export var PoolActive = false
@export var SpawnLimit = 0
@export var CanSpawn = true

var spawnNodes = []
var customers = []

func _ready() -> void:
	GetSpawnPoints()
	GetCustomers()
#	StartPool()

func _process(delta: float) -> void:
#	if the is off cooldown and can spawn customers
	if(PoolActive && CanSpawn && customers.size() > 0):
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
			
func GetCustomers() -> void:
		customers = get_tree().get_root().get_node("Level1").get_node("CustomerPool").get_children()

func GetRandomNumber(minRange: int, maxRange: int) -> int:
	var rngGenerator = RandomNumberGenerator.new()
	return rngGenerator.randi_range(minRange, maxRange)
		
## Send a randomly selected customer to a randomly selected spawn point
func SpawnCustomer() -> void:
	var spawnPosition
	# get the customer node name so we can use it target the actual node when changing the poisition
	var customerNodeName
	
	if(spawnNodes.size() > 0):
		spawnPosition = spawnNodes[GetRandomNumber(0, spawnNodes.size() - 1)]
		
	if(customers.size() > 0):
		var customerIndex = GetRandomNumber(0, customers.size() - 1)
		customerNodeName = customers[customerIndex].name
		customers.pop_at(customerIndex)
	
	# Target the customer node from the level 1 scene tree
	var customerNode = get_tree().get_root().get_node("Level1").get_node("CustomerPool").get_node(str(customerNodeName))
	
	customerNode.global_position = spawnPosition
	customerNode.StartMovement()
