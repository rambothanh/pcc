shader_type canvas_item;

const float THRESHOLD = 0.1;
const bool SWAP = true;
const vec4 in_skin_light = vec4(0.99607843160629, 0.95294117927551, 0.75294119119644, 1.0);
const vec4 in_skin_med = vec4(0.95686274766922, 0.82352942228317, 0.61176472902298, 1.0);
const vec4 in_skin_dark = vec4(0.85882353782654, 0.64313727617264, 0.38823530077934, 1.0);
const vec4 in_eye_med = vec4(0.65098041296005, 0.98823529481888, 0.85882353782654, 1.0);
const vec4 in_eye_dark = vec4(0.13333334028721, 0.10980392247438, 0.10196078568697, 1.0);
const vec4 in_hair_light = vec4(1, 0.83529412746429, 0.2549019753933, 1.0);
const vec4 in_hair_med = vec4(0.97647058963776, 0.63921570777893, 0.10588235408068, 1.0);
const vec4 in_hair_dark = vec4(0.98039215803146, 0.41568627953529, 0.03921568766236, 1.0);
const vec4 in_clothes_base_light = vec4(0.72549021244049, 0.74901962280273, 0.98431372642517, 1.0);
const vec4 in_clothes_base_med = vec4(0.51764708757401, 0.60784316062927, 0.8941176533699, 1.0);
const vec4 in_clothes_base_dark = vec4(0.34509804844856, 0.55294120311737, 0.74509805440903, 1.0);
const vec4 in_clothes_acc_light = vec4(0.4745098054409, 0.40392157435417, 0.33333334326744, 1.0);
const vec4 in_clothes_acc_med = vec4(0.35294118523598, 0.30588236451149, 0.26666668057442, 1.0);
const vec4 in_clothes_acc_dark = vec4(0.258823543787, 0.22352941334248, 0.20392157137394, 1.0);
const vec4 in_clothes_trim_light = vec4(1.0, 1.0, 1.0, 1.0);
const vec4 in_clothes_trim_med = vec4(0.85490196943283, 0.87843137979507, 0.91764706373215, 1.0);
const vec4 in_clothes_trim_dark = vec4(0.70196080207825, 0.72549021244049, 0.81960785388947, 1.0);

uniform sampler2D lookup;
uniform vec4 out_skin_light: source_color;
uniform vec4 out_skin_med: source_color;
uniform vec4 out_skin_dark: source_color;
uniform vec4 out_eye_med: source_color;
uniform vec4 out_eye_dark: source_color;
uniform vec4 out_hair_light: source_color;
uniform vec4 out_hair_med: source_color;
uniform vec4 out_hair_dark: source_color;
uniform vec4 out_clothes_base_light: source_color;
uniform vec4 out_clothes_base_med: source_color;
uniform vec4 out_clothes_base_dark: source_color;
uniform vec4 out_clothes_acc_light: source_color;
uniform vec4 out_clothes_acc_med: source_color;
uniform vec4 out_clothes_acc_dark: source_color;
uniform vec4 out_clothes_trim_light: source_color;
uniform vec4 out_clothes_trim_med: source_color;
uniform vec4 out_clothes_trim_dark: source_color;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color.a < THRESHOLD) {
		COLOR = vec4(1.0, 1.0, 1.0, 0.0);
	} else {
		color = texture(lookup, vec2(color.r, color.g));
		if (!SWAP){
		} else if (length(color - in_skin_light) < THRESHOLD) {
			color = out_skin_light;
		} else if (length(color - in_skin_med) < THRESHOLD) {
			color = out_skin_med;
		} else if (length(color - in_skin_dark) < THRESHOLD) {
			color = out_skin_dark;
		} else if (length(color - in_eye_med) < THRESHOLD) {
			color = out_eye_med;
		} else if (length(color - in_eye_dark) < THRESHOLD) {
			color = out_eye_dark;
		} else if (length(color - in_hair_light) < THRESHOLD) {
			color = out_hair_light;
		} else if (length(color - in_hair_med) < THRESHOLD) {
			color = out_hair_med;
		} else if (length(color - in_hair_dark) < THRESHOLD) {
			color = out_hair_dark;
		} else if (length(color - in_clothes_base_light) < THRESHOLD) {
			color = out_clothes_base_light;
		} else if (length(color - in_clothes_base_med) < THRESHOLD) {
			color = out_clothes_base_med;
		} else if (length(color - in_clothes_base_dark) < THRESHOLD) {
			color = out_clothes_base_dark;
		} else if (length(color - in_clothes_acc_light) < THRESHOLD) {
			color = out_clothes_acc_light;
		} else if (length(color - in_clothes_acc_med) < THRESHOLD) {
			color = out_clothes_acc_med;
		} else if (length(color - in_clothes_acc_dark) < THRESHOLD) {
			color = out_clothes_acc_dark;
		} else if (length(color - in_clothes_trim_light) < THRESHOLD) {
			color = out_clothes_trim_light;
		} else if (length(color - in_clothes_trim_med) < THRESHOLD) {
			color = out_clothes_trim_med;
		} else if (length(color - in_clothes_trim_dark) < THRESHOLD) {
			color = out_clothes_trim_dark;
		} else {
			color = vec4(1.0, 1.0, 1.0, 0.0);
		}
		COLOR = color;
	}
}