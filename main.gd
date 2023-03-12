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
const STARTING_ITEMS := {
	"hair_back": "long",
	"arm_left": "long",
	"leg_left": "tights",
	"torso": "tie",
	"head": "round",
	"hair_base": "full",
	"eye_left": "medium",
	"eye_right": "medium",
	"ear": "human",
	"leg_right": "tights",
	"skirt": "short",
	"arm_right": "long",
	"hair_front": "bangs",
}
const COLORS := {
	"highlight": Color.SIENNA,
	"shadow_0": Color.LIGHT_STEEL_BLUE,
	"shadow_1": Color.LIGHT_SLATE_GRAY,
	"shadow_2": Color.SLATE_GRAY,
	"shadow_3": Color.DARK_SLATE_BLUE,
}

@export var Items: PackedScene


func _ready() -> void:
	for anim in ANIMATIONS:
		%Animation.add_item(anim.capitalize())
	for p in PARTS.size():
		var part: String = PARTS[p]
		%Part.add_item(part.capitalize())
		var i := Items.instantiate()
		%PartItems.add_child(i)
		var items: Array = i.make_items(part, SPRITES_PATH)
		for item in items:
			if item.text == "None":
				item.pressed.connect(on_none_pressed.bind(p))
			else:
				item.pressed.connect(on_item_pressed.bind(p, item.texture))
	for child in %Colors.get_children():
		var b := child.get_child(1)
		b.color_changed.connect(on_color_changed.bind(b.name))
		on_color_changed(b.color, b.name)
	_on_part_item_selected(0)
	_on_animation_item_selected(0)


func _on_part_item_selected(index: int) -> void:
	for items in %PartItems.get_children():
		items.visible = index == items.get_index()


func _on_animation_item_selected(index: int) -> void:
	if $AnimationPlayer.has_animation(%Animation.get_item_text(index).to_lower()):
		$AnimationPlayer.play(%Animation.get_item_text(index).to_lower())


func on_item_pressed(i: int, texture: Texture2D) -> void:
	$Sprites.get_child(i).texture = texture


func on_none_pressed(i: int) -> void:
	$Sprites.get_child(i).texture = null


func set_part_from_text(part: String, item: String) -> void:
	for child in %PartItems.get_child(PARTS.find(part)).get_items():
		if child.item_name == item:
			on_item_pressed(PARTS.find(part), child.texture)


func on_color_changed(color: Color, param: String) -> void:
	for sprite in $Sprites.get_children():
		match param:
			"outline":
				sprite.material["shader_parameter/out_outline"] = color
			"skin":
				sprite.material["shader_parameter/out_skin_0"] = Color.WHITE - -color * -COLORS.highlight
				sprite.material["shader_parameter/out_skin_1"] = color
				sprite.material["shader_parameter/out_skin_2"] = color * COLORS.shadow_0
				sprite.material["shader_parameter/out_skin_3"] = color * COLORS.shadow_1
				sprite.material["shader_parameter/out_skin_4"] = color * COLORS.shadow_2
			"iris":
				sprite.material["shader_parameter/out_iris_0"] = color
				sprite.material["shader_parameter/out_iris_1"] = color * COLORS.shadow_0
				sprite.material["shader_parameter/out_iris_2"] = color * COLORS.shadow_3
			"sclera":
				sprite.material["shader_parameter/out_sclera_0"] = color
				sprite.material["shader_parameter/out_sclera_1"] = color * COLORS.shadow_0
			"hair", "pri", "sec", "ter":
				sprite.material["shader_parameter/out_%s_0" % param] = Color.WHITE - -color * -COLORS.highlight
				sprite.material["shader_parameter/out_%s_1" % param] = color
				sprite.material["shader_parameter/out_%s_2" % param] = color * COLORS.shadow_0
				sprite.material["shader_parameter/out_%s_3" % param] = color * COLORS.shadow_1
