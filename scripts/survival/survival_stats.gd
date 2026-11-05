class_name SurvivalStats
extends Node

signal died
@export var max_health: float = 100.0
@export var max_hunger: float = 100.0
@export var max_thirst: float = 100.0
@export var max_stamina: float = 100.0

var health: float = 100.0
var hunger: float = 100.0
var thirst: float = 100.0
var stamina: float = 100.0
var wounded: bool = false

func _process(delta: float) -> void:
	hunger = max(0.0, hunger - 0.5 * delta)
	thirst = max(0.0, thirst - 0.8 * delta)
	if hunger <= 0 or thirst <= 0:
		health = max(0.0, health - 1.0 * delta)
	if health <= 0:
		died.emit()

func eat(amount: float) -> void:
	hunger = min(max_hunger, hunger + amount)

func drink(amount: float) -> void:
	thirst = min(max_thirst, thirst + amount)

func heal(amount: float) -> void:
	health = min(max_health, health + amount)

func take_damage(amount: float) -> void:
	health = max(0.0, health - amount)
	if health <= 0:
		died.emit()
