class_name LootSpawner
extends Node3D

@export var loot_table: Array[Dictionary] = []  # {item_id, weight, min, max}
@export var spawn_count: int = 5

func spawn(loot_root: Node, item_scenes: Dictionary) -> void:
	for i in range(spawn_count):
		if loot_table.is_empty():
			return
		var pick := _weighted_pick()
		if pick.is_empty():
			continue
		var count := randi_range(int(pick.get("min",1)), int(pick.get("max",1)))
		var scene: PackedScene = item_scenes.get(pick["item_id"])
		if scene == null:
			continue
		var inst := scene.instantiate()
		inst.position = global_position + Vector3(randf_range(-2,2), 0, randf_range(-2,2))
		loot_root.add_child(inst)

func _weighted_pick() -> Dictionary:
	var total := 0.0
	for e in loot_table:
		total += float(e.get("weight",1.0))
	var r := randf() * total
	var acc := 0.0
	for e in loot_table:
		acc += float(e.get("weight",1.0))
		if r <= acc:
			return e
	return {}
