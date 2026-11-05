class_name CharacterCreator
extends Control

signal creation_finished(data: CharacterData)

var data: CharacterData = CharacterData.new()
@onready var preview: Node3D = $PreviewViewport/PreviewRoot

const MALE_PATH := "res://assets/characters/male.glb"
const FEMALE_PATH := "res://assets/characters/female.glb"

func _ready() -> void:
	_refresh_preview()

func set_body_type(v: int) -> void:
	data.body_type = v
	_refresh_preview()

func set_skin_tone(c: Color) -> void:
	data.skin_tone = c
	_refresh_preview()

func _refresh_preview() -> void:
	for c in preview.get_children():
		c.queue_free()
	var path := MALE_PATH if data.body_type == 0 else FEMALE_PATH
	if not ResourceLoader.exists(path):
		return
	var packed := load(path)
	if packed is PackedScene:
		var inst: Node = packed.instantiate()
		preview.add_child(inst)
		_apply_skin_tone(inst, data.skin_tone)

func _apply_skin_tone(node: Node, color: Color) -> void:
	if node is MeshInstance3D:
		var mi := node as MeshInstance3D
		if mi.material_override is StandardMaterial3D:
			(mi.material_override as StandardMaterial3D).albedo_color = color
	for child in node.get_children():
		_apply_skin_tone(child, color)

func finish() -> void:
	creation_finished.emit(data)
