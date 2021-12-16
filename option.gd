extends VBoxContainer


signal item_selected(item_path)
signal color_changed(option, color, num)

const _PATH := "res://character/"

var option: String


func set_option(o: String) -> void:
	option = o
	var dir := Directory.new()
	dir.open(_PATH + o)
	dir.list_dir_begin(true, true)
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".import"):
			var b := Button.new()
			b.text = file_name.replace(".png.import", "").capitalize()
			$Scroll/Items.add_child(b)
			b.connect("pressed", self, "_on_item_pressed", [file_name.replace(".import", "")])
		file_name = dir.get_next()
	dir.list_dir_end()


func set_default_colors(colors: Array) -> void:
	for i in colors.size():
		$Colors.get_child(i).get_node("ColorPickerButton").color = colors[i]

	
func _on_item_pressed(item: String) -> void:
	emit_signal("item_selected", _PATH + option + "/" + item)


func _on_color_changed(color: Color, num: int) -> void:
	emit_signal("color_changed", option, color, num)
