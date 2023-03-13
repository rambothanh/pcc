extends Node


const IMAGE_SIZE := Vector2i(64, 64)
const SPRITES_PATH := "res://sprites/"
const ANIMATIONS := [
	"idle",
	"walk",
	"run",
	"jump",
	"fall",
]
const ANIM_DATA := {
	"idle": {
		"keys": 4,
		"delay": 0.250,
	},
	"walk": {
		"keys": 4,
		"delay": 0.250,
	},
	"run": {
		"keys": 4,
		"delay": 0.250,
	},
	"jump": {
		"keys": 2,
		"delay": 0.250,
	},
	"fall": {
		"keys": 2,
		"delay": 0.250,
	},
}
const PARTS := [
	"hair_back",
	"arm_left",
	"leg_left",
	"torso",
	"head",
	"hair_base",
	"eye_left",
	"eye_right",
	"glasses",
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
	"glasses": "None",
	"ear": "human",
	"leg_right": "tights",
	"skirt": "None",
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
	$Export.hide()
	$FileDialog.hide()
	$FileDialog.current_dir = OS.get_system_dir(OS.SYSTEM_DIR_PICTURES)
	$Generating.hide()
	
	for anim in ANIMATIONS:
		%Animation.add_item(anim.capitalize())
		var c := CheckBox.new()
		c.text = anim.capitalize()
		c.set_meta("anim_name", anim)
		$Export/VBox.add_child(c)
		c.button_pressed = true
	$Export/VBox.move_child($Export/VBox/ExportFinal, -1)
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
		set_part_from_text(part, STARTING_ITEMS[part])
	for child in %Colors.get_children():
		if not child is HBoxContainer:
			break
		var b := child.get_child(1)
		b.color_changed.connect(on_color_changed.bind(b.name))
		on_color_changed(b.color, b.name)
	_on_part_item_selected(0)
	_on_animation_item_selected(0)
	
	await get_tree().process_frame
	var scale: Vector2 = %Spacer.size / %SVC.size
	var min_part: float = min(scale.x, scale.y)
	var final_scale := Vector2.ONE * min_part
	%SVC.scale = final_scale
	%SVC.position = %Spacer.position


func _on_part_item_selected(index: int) -> void:
	for items in %PartItems.get_children():
		items.visible = index == items.get_index()


func _on_animation_item_selected(index: int) -> void:
	if $AnimationPlayer.has_animation(%Animation.get_item_text(index).to_lower()):
		$AnimationPlayer.play(%Animation.get_item_text(index).to_lower())


func on_item_pressed(i: int, texture: Texture2D) -> void:
	%Sprites.get_child(i).texture = texture


func on_none_pressed(i: int) -> void:
	%Sprites.get_child(i).texture = null


func set_part_from_text(part: String, item: String) -> void:
	if item == "None":
		%PartItems.get_child(PARTS.find(part)).get_none().button_pressed = true
		on_none_pressed(PARTS.find(part))
	else:
		for child in %PartItems.get_child(PARTS.find(part)).get_items():
			if child.item_name == item:
				child.button_pressed = true
				on_item_pressed(PARTS.find(part), child.texture)
				return
		%PartItems.get_child(PARTS.find(part)).get_none().button_pressed = true


func on_color_changed(color: Color, param: String) -> void:
	for sprite in %Sprites.get_children():
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


func export_image_web(image: Image, file_name := "export.png") -> void:
	if not OS.has_feature("web"):
		return
	
	image.clear_mipmaps()
	var buffer := image.save_png_to_buffer()
	JavaScriptBridge.download_buffer(buffer, file_name)


func _on_export_pressed() -> void:
	$Export.popup_centered()


func _on_export_final_pressed() -> void:
	$Export.hide()
	if OS.has_feature("web"):
		export_spritesheet_web()
	else:
		$FileDialog.popup_centered()


func export_spritesheet_web() -> void:
	$Generating.popup_centered()
	var to_export := get_anims_to_export()
	if to_export.size() == 0:
		$Generating.hide()
		return
	var image := await get_spritesheet(to_export)
	export_image_web(image, "character_spritesheet.png")
	$Generating.hide()


func export_spritesheet_desktop(path: String) -> void:
	$Generating.popup_centered()
	var to_export := get_anims_to_export()
	if to_export.size() == 0:
		$Generating.hide()
		return
	var image := await get_spritesheet(to_export)
	if path.ends_with(".png"):
		image.save_png(path)
	elif path.ends_with(".jpg"):
		image.save_jpg(path)
	elif path.ends_with(".webp"):
		image.save_webp(path)
	elif path.ends_with(".exr"):
		image.save_exr(path)
	$Generating.hide()


func get_anims_to_export() -> Array:
	var to_export := []
	for button in $Export/VBox.get_children():
		if not button is CheckBox:
			break
		if button.button_pressed:
			to_export.append(button.get_meta("anim_name"))
	return to_export
	

func get_spritesheet(to_export: Array) -> Image:
	var max_x := 0
	for anim in to_export:
		if max_x < ANIM_DATA[anim].keys:
			max_x = ANIM_DATA[anim].keys
	var image := Image.create(IMAGE_SIZE.x * max_x, IMAGE_SIZE.y * to_export.size(), false, Image.FORMAT_RGBA8)
	for i in to_export.size():
		var anim: String = to_export[i]
		$AnimationPlayer.play(anim)
		for key in ANIM_DATA[anim].keys:
			$AnimationPlayer.seek(key * ANIM_DATA[anim].delay, true)
			await RenderingServer.frame_post_draw
			image.blit_rect($SVC/SV.get_texture().get_image(), Rect2i(Vector2i.ZERO, IMAGE_SIZE), Vector2i(IMAGE_SIZE.x * key, IMAGE_SIZE.y * i))
	_on_animation_item_selected(%Animation.selected)
	return image


func _on_file_dialog_file_selected(path: String) -> void:
	export_spritesheet_desktop(path)
