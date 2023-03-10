extends Button


const PART_POS := {
	"HairBack": Rect2i(Vector2i(0, 28) * 2, Vector2i(8, 29) * 2),
	"Cape": Rect2i(Vector2i(16, 18) * 2, Vector2i(6, 20) * 2),
	"Body": Rect2i(Vector2i(0, 8) * 2, Vector2i(6, 10) * 2),
	"Head": Rect2i(Vector2i(0, 0) * 2, Vector2i(8, 8) * 2),
	"LegRight": Rect2i(Vector2i(0, 18) * 2, Vector2i(2, 10) * 2),
	"LegLeft": Rect2i(Vector2i(8, 18) * 2, Vector2i(2, 10) * 2),
	"ArmRight": Rect2i(Vector2i(16, 8) * 2, Vector2i(2, 10) * 2),
	"ArmLeft": Rect2i(Vector2i(24, 8) * 2, Vector2i(2, 10) * 2),
	"Skirt": Rect2i(Vector2i(16, 38) * 2, Vector2i(6, 14) * 2),
	"HairFront": Rect2i(Vector2i(32, 2) * 2, Vector2i(8, 29) * 2),
	"Face": Rect2i(Vector2i(48, 0) * 2, Vector2i(8, 8) * 2),
}
var texture: Texture2D
var part: String


func set_lookup(path := "", p := "") -> void:
	part = p
	if path == "":
		text = "None"
		return
	texture = load(path)
	if p in PART_POS:
		var rect := texture.get_image().get_region(PART_POS[p])
		if rect.get_used_rect().size == Vector2i.ZERO:
			queue_free()
			return
		icon = ImageTexture.create_from_image(rect)
	else:
		icon = texture
	text = path.get_file().replace(".png", "").capitalize()
