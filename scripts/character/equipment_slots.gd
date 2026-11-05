class_name EquipmentSlots
extends Resource

const SLOT_NAMES := ["head","chest","legs","feet","hands","back","weapon_primary","weapon_secondary","hat","mask"]
var slots: Dictionary = {}

func _init() -> void:
	for s in SLOT_NAMES:
		slots[s] = ""

func equip(slot: String, item_id: String) -> bool:
	if not slots.has(slot):
		return false
	slots[slot] = item_id
	return true

func unequip(slot: String) -> String:
	if not slots.has(slot):
		return ""
	var v := slots[slot]
	slots[slot] = ""
	return v

func get_equipped(slot: String) -> String:
	return slots.get(slot, "")
