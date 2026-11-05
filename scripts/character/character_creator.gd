class_name CharacterCreator
extends Control

signal creation_finished(data: CharacterData)

var data: CharacterData = CharacterData.new()
@onready var preview: Node3D = $PreviewViewport/PreviewRoot

func _ready() -> void:
	_refresh_preview()

func set_body_type(v: int) -> void:
	data.body_type = v
	_refresh_preview()

func set_skin_tone(c: Color) -> void:
	data.skin_tone = c
	_refresh_preview()

func _refresh_preview() -> void:
	# Hook: update materials/meshes on preview node
	pass

func finish() -> void:
	creation_finished.emit(data)
