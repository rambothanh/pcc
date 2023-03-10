shader_type canvas_item;


const float THRESHOLD = 0.01;
uniform vec4 in_skin_color: source_color;
uniform vec4 out_skin_color: source_color;

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	if (length(col - in_skin_color) < THRESHOLD){
		col = out_skin_color;
	}
	COLOR = col;
}
