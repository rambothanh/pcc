shader_type canvas_item;

const float THRESHOLD = 0.1;
const vec4 in_outline = vec4(0.13333334028721, 0.10980392247438, 0.10196078568697, 1.0);
const vec4 in_skin_0 = vec4(0.98039215803146, 0.839215695858, 0.72156864404678, 1.0);
const vec4 in_skin_1 = vec4(0.91372549533844, 0.70980393886566, 0.63921570777893, 1.0);
const vec4 in_skin_2 = vec4(0.7294117808342, 0.45882353186607, 0.41568627953529, 1.0);
const vec4 in_skin_3 = vec4(0.55686277151108, 0.32156863808632, 0.32156863808632, 1.0);
const vec4 in_skin_4 = vec4(0.35686275362968, 0.19215686619282, 0.21960784494877, 1.0);
const vec4 in_iris_0 = vec4(0.14117647707462, 0.6235294342041, 0.87058824300766, 1.0);
const vec4 in_iris_1 = vec4(0.15686275064945, 0.36078432202339, 0.76862746477127, 1.0);
const vec4 in_iris_2 = vec4(0.07058823853731, 0.12549020349979, 0.12549020349979, 1.0);
const vec4 in_sclera_0 = vec4(1, 1, 1, 1.0);
const vec4 in_sclera_1 = vec4(0.85490196943283, 0.87843137979507, 0.91764706373215, 1.0);
const vec4 in_hair_0 = vec4(0.61176472902298, 0.85882353782654, 0.26274511218071, 1.0);
const vec4 in_hair_1 = vec4(0.34901961684227, 0.75686275959015, 0.20784313976765, 1.0);
const vec4 in_hair_2 = vec4(0.07843137532473, 0.62745100259781, 0.1803921610117, 1.0);
const vec4 in_hair_3 = vec4(0.10196078568697, 0.47843137383461, 0.24313725531101, 1.0);
const vec4 in_pri_0 = vec4(0.62745100259781, 0.52549022436142, 0.38431373238564, 1.0);
const vec4 in_pri_1 = vec4(0.4745098054409, 0.40392157435417, 0.33333334326744, 1.0);
const vec4 in_pri_2 = vec4(0.35294118523598, 0.30588236451149, 0.26666668057442, 1.0);
const vec4 in_pri_3 = vec4(0.258823543787, 0.22352941334248, 0.20392157137394, 1.0);
const vec4 in_sec_0 = vec4(1, 0.98823529481888, 0.25098040699959, 1.0);
const vec4 in_sec_1 = vec4(1, 0.83529412746429, 0.2549019753933, 1.0);
const vec4 in_sec_2 = vec4(0.97647058963776, 0.63921570777893, 0.10588235408068, 1.0);
const vec4 in_sec_3 = vec4(0.98039215803146, 0.41568627953529, 0.03921568766236, 1.0);
const vec4 in_ter_0 = vec4(0.80392158031464, 0.96862745285034, 0.88627451658249, 1.0);
const vec4 in_ter_1 = vec4(0.57254904508591, 0.86274510622025, 0.7294117808342, 1.0);
const vec4 in_ter_2 = vec4(0.3647058904171, 0.68627452850342, 0.55294120311737, 1.0);
const vec4 in_ter_3 = vec4(0.19607843458652, 0.51764708757401, 0.39215686917305, 1.0);

uniform vec4 out_outline: source_color = vec4(0.13333334028721, 0.10980392247438, 0.10196078568697, 1.0);
uniform vec4 out_skin_0: source_color = vec4(0.98039215803146, 0.839215695858, 0.72156864404678, 1.0);
uniform vec4 out_skin_1: source_color = vec4(0.91372549533844, 0.70980393886566, 0.63921570777893, 1.0);
uniform vec4 out_skin_2: source_color = vec4(0.7294117808342, 0.45882353186607, 0.41568627953529, 1.0);
uniform vec4 out_skin_3: source_color = vec4(0.55686277151108, 0.32156863808632, 0.32156863808632, 1.0);
uniform vec4 out_skin_4: source_color = vec4(0.35686275362968, 0.19215686619282, 0.21960784494877, 1.0);
uniform vec4 out_iris_0: source_color = vec4(0.14117647707462, 0.6235294342041, 0.87058824300766, 1.0);
uniform vec4 out_iris_1: source_color = vec4(0.15686275064945, 0.36078432202339, 0.76862746477127, 1.0);
uniform vec4 out_iris_2: source_color = vec4(0.07058823853731, 0.12549020349979, 0.12549020349979, 1.0);
uniform vec4 out_sclera_0: source_color = vec4(1, 1, 1, 1.0);
uniform vec4 out_sclera_1: source_color = vec4(0.85490196943283, 0.87843137979507, 0.91764706373215, 1.0);
uniform vec4 out_hair_0: source_color = vec4(0.61176472902298, 0.85882353782654, 0.26274511218071, 1.0);
uniform vec4 out_hair_1: source_color = vec4(0.34901961684227, 0.75686275959015, 0.20784313976765, 1.0);
uniform vec4 out_hair_2: source_color = vec4(0.07843137532473, 0.62745100259781, 0.1803921610117, 1.0);
uniform vec4 out_hair_3: source_color = vec4(0.10196078568697, 0.47843137383461, 0.24313725531101, 1.0);
uniform vec4 out_pri_0: source_color = vec4(0.62745100259781, 0.52549022436142, 0.38431373238564, 1.0);
uniform vec4 out_pri_1: source_color = vec4(0.4745098054409, 0.40392157435417, 0.33333334326744, 1.0);
uniform vec4 out_pri_2: source_color = vec4(0.35294118523598, 0.30588236451149, 0.26666668057442, 1.0);
uniform vec4 out_pri_3: source_color = vec4(0.258823543787, 0.22352941334248, 0.20392157137394, 1.0);
uniform vec4 out_sec_0: source_color = vec4(1, 0.98823529481888, 0.25098040699959, 1.0);
uniform vec4 out_sec_1: source_color = vec4(1, 0.83529412746429, 0.2549019753933, 1.0);
uniform vec4 out_sec_2: source_color = vec4(0.97647058963776, 0.63921570777893, 0.10588235408068, 1.0);
uniform vec4 out_sec_3: source_color = vec4(0.98039215803146, 0.41568627953529, 0.03921568766236, 1.0);
uniform vec4 out_ter_0: source_color = vec4(0.80392158031464, 0.96862745285034, 0.88627451658249, 1.0);
uniform vec4 out_ter_1: source_color = vec4(0.57254904508591, 0.86274510622025, 0.7294117808342, 1.0);
uniform vec4 out_ter_2: source_color = vec4(0.3647058904171, 0.68627452850342, 0.55294120311737, 1.0);
uniform vec4 out_ter_3: source_color = vec4(0.19607843458652, 0.51764708757401, 0.39215686917305, 1.0);

void fragment() {
	vec4 in_color = texture(TEXTURE, UV);
	vec4 out_color = in_color;
	if (distance(in_color, in_outline) < THRESHOLD) {
		out_color = out_outline;
	} else if (distance(in_color, in_skin_0) < THRESHOLD) {
		out_color = out_skin_0;
	} else if (distance(in_color, in_skin_1) < THRESHOLD) {
		out_color = out_skin_1;
	} else if (distance(in_color, in_skin_2) < THRESHOLD) {
		out_color = out_skin_2;
	} else if (distance(in_color, in_skin_3) < THRESHOLD) {
		out_color = out_skin_3;
	} else if (distance(in_color, in_skin_4) < THRESHOLD) {
		out_color = out_skin_4;
	} else if (distance(in_color, in_iris_0) < THRESHOLD) {
		out_color = out_iris_0;
	} else if (distance(in_color, in_iris_1) < THRESHOLD) {
		out_color = out_iris_1;
	} else if (distance(in_color, in_iris_2) < THRESHOLD) {
		out_color = out_iris_2;
	} else if (distance(in_color, in_sclera_0) < THRESHOLD) {
		out_color = out_sclera_0;
	} else if (distance(in_color, in_sclera_1) < THRESHOLD) {
		out_color = out_sclera_1;
	} else if (distance(in_color, in_hair_0) < THRESHOLD) {
		out_color = out_hair_0;
	} else if (distance(in_color, in_hair_1) < THRESHOLD) {
		out_color = out_hair_1;
	} else if (distance(in_color, in_hair_2) < THRESHOLD) {
		out_color = out_hair_2;
	} else if (distance(in_color, in_hair_3) < THRESHOLD) {
		out_color = out_hair_3;
	} else if (distance(in_color, in_pri_0) < THRESHOLD) {
		out_color = out_pri_0;
	} else if (distance(in_color, in_pri_1) < THRESHOLD) {
		out_color = out_pri_1;
	} else if (distance(in_color, in_pri_2) < THRESHOLD) {
		out_color = out_pri_2;
	} else if (distance(in_color, in_pri_3) < THRESHOLD) {
		out_color = out_pri_3;
	} else if (distance(in_color, in_sec_0) < THRESHOLD) {
		out_color = out_sec_0;
	} else if (distance(in_color, in_sec_1) < THRESHOLD) {
		out_color = out_sec_1;
	} else if (distance(in_color, in_sec_2) < THRESHOLD) {
		out_color = out_sec_2;
	} else if (distance(in_color, in_sec_3) < THRESHOLD) {
		out_color = out_sec_3;
	} else if (distance(in_color, in_ter_0) < THRESHOLD) {
		out_color = out_ter_0;
	} else if (distance(in_color, in_ter_1) < THRESHOLD) {
		out_color = out_ter_1;
	} else if (distance(in_color, in_ter_2) < THRESHOLD) {
		out_color = out_ter_2;
	} else if (distance(in_color, in_ter_3) < THRESHOLD) {
		out_color = out_ter_3;
	}
	COLOR = out_color;
}
