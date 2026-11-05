extends Node

const REGIONS := [
	"urban_center","residential","industrial",
	"forest_green","forest_dead","forest_dark",
	"farm","rural_village","camp",
	"military_base","checkpoint","training",
	"bunker","lab","metro",
	"hospital","clinic","medical_post",
	"supermarket","mall","gas_station"
]

func region_scene_path(region_id: String) -> String:
	return "res://scenes/regions/%s.tscn" % region_id

func load_region(region_id: String, parent: Node) -> Node:
	if not REGIONS.has(region_id):
		return null
	var path := region_scene_path(region_id)
	if not ResourceLoader.exists(path):
		return null
	var packed := load(path) as PackedScene
	if packed == null:
		return null
	var inst: Node = packed.instantiate()
	parent.add_child(inst)
	return inst
