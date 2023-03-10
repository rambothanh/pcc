extends Control


const LOOKUPS_PATH := "res://lookups/"
const COLOR_MAP := {
	"SkinOption": "skin",
	"EyeOption": "eye",
	"HairOption": "hair",
	"CBOption": "clothes_base",
	"CAccOption": "clothes_acc",
	"CTrimOption": "clothes_trim",
}
const CUSTOM_MAP := {
	"SkinMarg": "skin",
	"EyeMarg": "eye",
	"HairMarg": "hair",
	"CBMarg": "clothes_base",
	"CAccMarg": "clothes_acc",
	"CTrimMarg": "clothes_trim",
}
const PALETTE_TO_CUSTOM := {
	"SkinOption": "SkinMarg",
	"EyeOption": "EyeMarg",
	"HairOption": "HairMarg",
	"CBOption": "CBMarg",
	"CAccOption": "CAccMarg",
	"CTrimOption": "CTrimMarg",
}
const PALETTE_WIDTH := 16
const SHADES := ["light", "med", "dark"]
const ANIMS := ["idle", "move"]
const DIRS := ["front", "left", "right", "back"]
const ORDER := {
	"front": [
		"HairBack",
		"Cape",
		"Body",
		"Head",
		"LegLeft",
		"LegRight",
		"Skirt",
		"ArmLeft",
		"ArmRight",
		"HairFront",
		"Face",
	],
	"left": [
		"ArmRight",
		"LegRight",
		"HairBack",
		"Cape",
		"Body",
		"Head",
		"LegLeft",
		"Skirt",
		"ArmLeft",
		"HairFront",
		"Face",
	],
	"right": [
		"ArmLeft",
		"LegLeft",
		"HairBack",
		"Cape",
		"Body",
		"Head",
		"LegRight",
		"Skirt",
		"ArmRight",
		"HairFront",
		"Face",
	],
	"back": [
		"Face",
		"HairFront",
		"ArmRight",
		"ArmLeft",
		"LegRight",
		"LegLeft",
		"Body",
		"Head",
		"Skirt",
		"Cape",
		"HairBack",
	],
}
const ANIM_FPS := {
	"idle": 4,
	"move": 4,
}
const ANIMS_PATH := "res://animations/"
const SPRITE_SIZE := Vector2i(32, 32)

@export var PartButton: PackedScene


func _ready() -> void:
	$CC.hide()
	
	for child in $Character.get_children():
		child.material = child.material.duplicate()
		
	for child in $HBox/Right/Scroll/VBox.get_children():
		if not child is OptionButton:
			continue
		child.item_selected.connect(on_color_selected.bind(child))
		on_color_selected(0, child)
		
	var dir := DirAccess.open(LOOKUPS_PATH)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	var lookups := []
	while file_name != "":
		if file_name.ends_with(".import"):
			lookups.append(file_name.replace(".import", ""))
		file_name = dir.get_next()
	dir.list_dir_end()
	for child in $HBox/Left/VBox/Scrolls.get_children():
		var bg := ButtonGroup.new()
		var none := PartButton.instantiate()
		none.set_lookup("", child.name)
		child.get_child(0).add_child(none)
		none.pressed.connect(on_none_pressed.bind(none))
		none.button_group = bg
		for lookup in lookups:
			var b := PartButton.instantiate()
			b.set_lookup(LOOKUPS_PATH + lookup, child.name)
			child.get_child(0).add_child(b)
			b.pressed.connect(on_part_pressed.bind(b))
			b.button_group = bg
		if lookups.size() == 0:
			continue
		child.get_child(0).get_child(1).button_pressed = true
	on_part_pressed($HBox/Left/VBox/Scrolls/All/VBox.get_child(1))

	for child in $CC/Scroll/VBox.get_children():
		if not child is MarginContainer:
			continue
		for hbox in child.get_child(0).get_children():
			hbox.get_child(1).color_changed.connect(on_custom_color_changed.bind(child.name, hbox.name))
	
	for sprite in $Character.get_children():
		var s := SpriteFrames.new()
		sprite.sprite_frames = s
		for d in DIRS:
			for anim in ANIMS:
				var a_name: String = d + "_" + anim
				if not FileAccess.file_exists(ANIMS_PATH + a_name + ".png.import"):
					continue
				s.add_animation(a_name)
				s.set_animation_speed(a_name, ANIM_FPS[anim])
				s.set_animation_loop(a_name, true)
				var image: Image = load(ANIMS_PATH + a_name + ".png").get_image()
				for x in range(0, image.get_width(), SPRITE_SIZE.x):
					s.add_frame(a_name, ImageTexture.create_from_image(image.get_region(Rect2i(
						Vector2i(x, SPRITE_SIZE.y * ORDER[d].find(sprite.name)), SPRITE_SIZE
					))))
	for d in DIRS:
		%AngleOption.add_item(d.capitalize())
	for anim in ANIMS:
		%AnimOption.add_item(anim.capitalize())
	_on_angle_option_item_selected(0)


func on_none_pressed(b: Button) -> void:
	if b.part == "All":
		for other_scroll in $HBox/Left/VBox/Scrolls.get_children():
			if other_scroll.name == "All":
				continue
			other_scroll.get_child(0).get_child(0).button_pressed = true
			on_none_pressed(other_scroll.get_child(0).get_child(0))
	else:
		$Character.get_node(b.part).hide()


func on_part_pressed(b: Button) -> void:
	if b.part == "All":
		for other_scroll in $HBox/Left/VBox/Scrolls.get_children():
			if other_scroll.name == "All":
				continue
			var found_button := false
			for button in other_scroll.get_child(0).get_children():
				if button.texture == b.texture:
					button.button_pressed = true
					found_button = true
					on_part_pressed(button)
					break
			if not found_button:
				other_scroll.get_child(0).get_child(0).button_pressed = true
				on_none_pressed(other_scroll.get_child(0).get_child(0))
	else:
		$Character.get_node(b.part).show()
		$Character.get_node(b.part).material["shader_parameter/lookup"] = b.texture


func _on_part_option_item_selected(index: int) -> void:
	for child in $HBox/Left/VBox/Scrolls.get_children():
		child.hide()
	$HBox/Left/VBox/Scrolls.get_child(index).show()


func on_color_selected(index: int, o: OptionButton) -> void:
	var image := o.get_item_icon(index).get_image()
	var colors := [
		image.get_pixelv(Vector2i(0, 0)),
		image.get_pixelv(Vector2i(1 * PALETTE_WIDTH, 0)),
		image.get_pixelv(Vector2i(2 * PALETTE_WIDTH, 0)),
	]
	for i in SHADES.size():
		for sprite in $Character.get_children():
			sprite.material["shader_parameter/out_%s_%s" % [COLOR_MAP[o.name], SHADES[i]]] = colors[i]
		if o.name == "EyeOption" and i == 0:
			continue
		$CC/Scroll/VBox.get_node(PALETTE_TO_CUSTOM[o.name]).get_child(0).get_node(SHADES[i].capitalize()).get_child(1).color = colors[i]


func _on_custom_pressed() -> void:
	$CC.popup_centered()


func on_custom_color_changed(c: Color, part: String, shade: String) -> void:
	for sprite in $Character.get_children():
		sprite.material["shader_parameter/out_%s_%s" % [CUSTOM_MAP[part], shade.to_lower()]] = c


func _on_anim_option_item_selected(index: int) -> void:
	for sprite in $Character.get_children():
		if sprite.sprite_frames.has_animation(DIRS[%AngleOption.selected] + "_" + ANIMS[index]):
			sprite.play(DIRS[%AngleOption.selected] + "_" + ANIMS[index])
			rearrange_sprites()


func _on_angle_option_item_selected(index: int) -> void:
	for sprite in $Character.get_children():
		if sprite.sprite_frames.has_animation(DIRS[index] + "_" + ANIMS[%AnimOption.selected]):
			sprite.play(DIRS[index] + "_" + ANIMS[%AnimOption.selected])
			rearrange_sprites()


func rearrange_sprites() -> void:
	for sprite in $Character.get_children():
		$Character.move_child(sprite, ORDER[DIRS[%AngleOption.selected]].find(sprite.name))
