class_name CharacterData
extends Resource

@export var body_type: int = 0  # 0 male, 1 female
@export var face_index: int = 0
@export var skin_tone: Color = Color(0.85, 0.7, 0.55)
@export var eye_color: Color = Color(0.2, 0.4, 0.8)
@export var hair_style: int = 0
@export var hair_color: Color = Color(0.15, 0.1, 0.05)
@export var beard_style: int = 0
@export var initial_outfit: Array[String] = []

func to_dict() -> Dictionary:
	return {
		"body_type": body_type,
		"face_index": face_index,
		"skin_tone": skin_tone.to_html(),
		"eye_color": eye_color.to_html(),
		"hair_style": hair_style,
		"hair_color": hair_color.to_html(),
		"beard_style": beard_style,
		"initial_outfit": initial_outfit,
	}

func from_dict(d: Dictionary) -> void:
	body_type = int(d.get("body_type", 0))
	face_index = int(d.get("face_index", 0))
	skin_tone = Color.from_string(d.get("skin_tone", "#d9b38c"), Color(0.85, 0.7, 0.55))
	eye_color = Color.from_string(d.get("eye_color", "#3366cc"), Color(0.2, 0.4, 0.8))
	hair_style = int(d.get("hair_style", 0))
	hair_color = Color.from_string(d.get("hair_color", "#261a0d"), Color(0.15, 0.1, 0.05))
	beard_style = int(d.get("beard_style", 0))
	initial_outfit = d.get("initial_outfit", [])
