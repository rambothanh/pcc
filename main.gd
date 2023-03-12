extends Node


const SPRITES_PATH := "res://sprites/"
const ANIMATIONS := [
	"idle",
	"walk",
	"run",
	"jump",
	"fall",
]
const PARTS := [
	"hair_back",
	"arm_left",
	"leg_left",
	"torso",
	"head",
	"hair_base",
	"eye_left",
	"eye_right",
	"ear",
	"leg_right",
	"skirt",
	"arm_right",
	"hair_front",
]

@export var Items: PackedScene


func _ready() -> void:
	for anim in ANIMATIONS:
		%Animation.add_item(anim.capitalize())
	for part in PARTS:
		%Part.add_item(part.capitalize())
		var i := Items.instantiate()
		%PartItems.add_child(i)
		i.make_items(part, SPRITES_PATH)
	_on_part_item_selected(0)


func _on_part_item_selected(index: int) -> void:
	for items in %PartItems.get_children():
		items.visible = index == items.get_index()
