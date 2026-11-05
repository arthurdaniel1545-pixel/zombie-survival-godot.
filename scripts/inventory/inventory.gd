class_name Inventory
extends Node

signal changed
var capacity_weight: float = 30.0
var items: Array[Dictionary] = []  # {id, count}

func total_weight(item_db: Dictionary) -> float:
	var w: float = 0.0
	for e in items:
		var it: InventoryItem = item_db.get(e["id"])
		if it:
			w += it.weight * int(e["count"])
	return w

func add_item(id: String, count: int, item_db: Dictionary) -> int:
	var it: InventoryItem = item_db.get(id)
	if it == null:
		return count
	var remaining: int = count
	if it.stackable:
		for e in items:
			if e["id"] == id and int(e["count"]) < it.max_stack:
				var space: int = it.max_stack - int(e["count"])
				var amount_to_add: int = mini(space, remaining)
				e["count"] = int(e["count"]) + amount_to_add
				remaining -= amount_to_add
				if remaining <= 0:
					changed.emit()
					return 0
	# new stacks
	while remaining > 0:
		var amount_to_add: int = mini(it.max_stack, remaining)
		items.append({"id": id, "count": amount_to_add})
		remaining -= amount_to_add
	changed.emit()
	return 0

func remove_item(id: String, count: int) -> bool:
	var to_remove: int = count
	for i in range(items.size() - 1, -1, -1):
		if items[i]["id"] == id:
			var take: int = mini(int(items[i]["count"]), to_remove)
			items[i]["count"] = int(items[i]["count"]) - take
			to_remove -= take
			if int(items[i]["count"]) <= 0:
				items.remove_at(i)
			if to_remove <= 0:
				changed.emit()
				return true
	changed.emit()
	return to_remove <= 0

func has_item(id: String, count: int = 1) -> bool:
	var c: int = 0
	for e in items:
		if e["id"] == id:
			c += int(e["count"])
	return c >= count
