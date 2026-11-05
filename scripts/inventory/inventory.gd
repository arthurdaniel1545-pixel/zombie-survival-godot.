class_name Inventory
extends Node

signal changed
var capacity_weight: float = 30.0
var items: Array[Dictionary] = []  # {id, count}

func total_weight(item_db: Dictionary) -> float:
	var w := 0.0
	for e in items:
		var it: InventoryItem = item_db.get(e["id"])
		if it:
			w += it.weight * e["count"]
	return w

func add_item(id: String, count: int, item_db: Dictionary) -> int:
	var it: InventoryItem = item_db.get(id)
	if it == null:
		return count
	var remaining := count
	if it.stackable:
		for e in items:
			if e["id"] == id and e["count"] < it.max_stack:
				var space := it.max_stack - e["count"]
				var add := min(space, remaining)
				e["count"] += add
				remaining -= add
				if remaining <= 0:
					changed.emit()
					return 0
	# new stacks
	while remaining > 0:
		var add := min(it.max_stack, remaining)
		items.append({"id": id, "count": add})
		remaining -= add
	changed.emit()
	return 0

func remove_item(id: String, count: int) -> bool:
	var to_remove := count
	for i in range(items.size() - 1, -1, -1):
		if items[i]["id"] == id:
			var take := min(items[i]["count"], to_remove)
			items[i]["count"] -= take
			to_remove -= take
			if items[i]["count"] <= 0:
				items.remove_at(i)
			if to_remove <= 0:
				changed.emit()
				return true
	changed.emit()
	return to_remove <= 0

func has_item(id: String, count: int = 1) -> bool:
	var c := 0
	for e in items:
		if e["id"] == id:
			c += e["count"]
	return c >= count
