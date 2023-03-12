extends Button


const IMAGE_SIZE := Vector2i(64, 64)
var texture: Texture2D


func set_data(item: String, path: String) -> void:
	texture = load(path + item)
	var image := texture.get_image()
	var first_frame := image.get_region(Rect2i(Vector2i.ZERO, IMAGE_SIZE))
	icon = ImageTexture.create_from_image(first_frame.get_region(first_frame.get_used_rect()))
	text = item.replace(".png", "").capitalize()
