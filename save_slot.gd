extends MenuButton


signal overwrite(i: int)
signal load_requested(i: int)
signal delete(i: int)

var save_name: String

func _ready() -> void:
	get_popup().index_pressed.connect(on_item_pressed)


func init(date: Dictionary, n := "") -> void:
	if n != "":
		save_name = n
	text = "%s - %04d/%02d/%02d %02d:%02d:%02d" % [save_name, date.year, date.month, date.day, date.hour, date.minute, date.second]


func on_item_pressed(index: int) -> void:
	match index:
		0:
			overwrite.emit(get_index())
		1:
			load_requested.emit(get_index())
		2:
			delete.emit(get_index())


func toggle_overwrite(enable: bool) -> void:
	get_popup().set_item_disabled(0, not enable)
