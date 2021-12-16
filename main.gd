extends Control


const _OPTIONS := ["head", "hair_front", "ears", "eyebrows", "eyes", "tops", "bottoms", "shoes", "hair_back"]
const _IMG_SIZE := Rect2(Vector2(0, 0), Vector2(64, 64))

const _OptionClass := preload("res://option.tscn")


func _ready() -> void:
	if OS.get_name() == "HTML5" and OS.has_feature('JavaScript'):
		_define_js()
	for i in 5:
		$HBox/Base.material.set_shader_param(
			"replace_0_%d" % i,
			$HBox/Base.material.get_shader_param("original_0_%d" % i).darkened(i * 0.2)
		)
	for i in _OPTIONS.size():
		var o = _OptionClass.instance()
		o.name = _OPTIONS[i].capitalize()
		$HBox/Right/Tab.add_child(o)
		o.set_option(_OPTIONS[i])
		var mat: ShaderMaterial = $HBox/Base.get_node(_OPTIONS[i]).material
		for j in 3:
			for k in 5:
				mat.set_shader_param(
					"replace_%d_%d" % [j, k],
					mat.get_shader_param("original_%d_0" % [j]).darkened(k * 0.2)
				)
		o.set_default_colors([
			mat.get_shader_param("original_0_0"),
			mat.get_shader_param("original_1_0"),
			mat.get_shader_param("original_2_0"),
		])
		o.connect("item_selected", self, "_on_item_selected")
		o.connect("color_changed", self, "_on_color_changed")

func _define_js()->void:
	#Define JS script
	JavaScript.eval("""
	function download(fileName, byte) {
		var buffer = Uint8Array.from(byte);
		var blob = new Blob([buffer], { type: 'image/png'});
		var link = document.createElement('a');
		link.href = window.URL.createObjectURL(blob);
		link.download = fileName;
		link.click();
	};
	""", true)
	
	
func _on_item_selected(item_path: String) -> void:
	$HBox/Base.get_node(item_path.split("/", false)[2]).texture = load(item_path)
	

func _on_color_changed(option: String, color: Color, num: int) -> void:
	var option_node = $HBox/Base.get_node(option)
	for i in 5:
		option_node.material.set_shader_param("replace_%d_%d" % [num, i], color.darkened(i * 0.2))


func _on_skin_color_changed(color: Color) -> void:
	for i in 5:
		$HBox/Base.material.set_shader_param("replace_0_%d" % [i], color.darkened(i * 0.2))


func _on_clear_current_pressed() -> void:
	$HBox/Base.get_node($HBox/Right/Tab.get_current_tab_control().name.to_lower().replace(" ", "_")).texture = null


func _on_clear_all_pressed() -> void:
	for child in $HBox/Base.get_children():
		child.texture = null


func _on_download_pressed() -> void:
	var result: Image
	if $HBox/Base/hair_back.texture != null:
		result = _palette_swap($HBox/Base/hair_back)
		result.blend_rect(_palette_swap($HBox/Base), _IMG_SIZE, Vector2.ZERO)
	else:
		result = _palette_swap($HBox/Base)
	for child in $HBox/Base.get_children():
		if not child.name == "hair_back":
			result.blend_rect(_palette_swap(child), _IMG_SIZE, Vector2.ZERO)
	save_image(result, "character_%d" % hash(result))


func _palette_swap(texture_rect: TextureRect) -> Image:
	var result := texture_rect.texture.get_data()
	result.lock()
	for x in result.get_width():
		for y in result.get_height():
			var pixel := result.get_pixel(x, y)
			for i in 3:
				for j in 5:
					var original = texture_rect.material.get_shader_param("original_%d_%d" % [i, j])
					if original != null and pixel.is_equal_approx(original):
						result.set_pixel(x, y, texture_rect.material.get_shader_param("replace_%d_%d" % [i, j]))
	result.unlock()
	return result


func save_image(image:Image, fileName:String = "export")->void:
	if OS.get_name() != "HTML5" or !OS.has_feature('JavaScript'):
		return
		
	image.clear_mipmaps()
	if image.save_png("user://export_temp.png"):
		#label.text = "Error saving temp file"
		return
	var file:File = File.new()
	if file.open("user://export_temp.png", File.READ):
		#label.text = "Error opening file"
		return
	var pngData = Array(file.get_buffer(file.get_len()))	#read data as PoolByteArray and convert it to Array for JS
	file.close()
	var dir = Directory.new()
	dir.remove("user://export_temp.png")
	JavaScript.eval("download('%s', %s);" % [fileName, str(pngData)], true)
	#label.text = "Saving DONE"
	

func _on_meta_clicked(meta) -> void:
	OS.shell_open(meta)


func _on_credits_pressed() -> void:
	$CreditsPop.popup_centered()
