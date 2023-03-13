extends ScrollContainer


@export var ItemButton: PackedScene

var group := ButtonGroup.new()


func make_items(part_path: String, base_path: String) -> Array:
	%None.button_group = group
	var dir := DirAccess.open(base_path + part_path)
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".import"):
			var b := ItemButton.instantiate()
			b.set_data(file_name.replace(".import", ""), base_path + part_path + "/")
			b.button_group = group
			$VBox.add_child(b)
		file_name = dir.get_next()
	dir.list_dir_end()
	hide()
	return $VBox.get_children()


func get_items() -> Array:
	var arr := $VBox.get_children()
	arr.remove_at(0)
	return arr


func get_none() -> Button:
	return %None
