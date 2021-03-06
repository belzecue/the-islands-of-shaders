shader_type spatial;
render_mode cull_disabled;
render_mode vertex_lighting;
render_mode depth_draw_alpha_prepass;

uniform sampler2D tex : hint_albedo;
uniform sampler2D spec: hint_black;

uniform float amplitude = 0.1;
uniform vec2 speed = vec2(2.0, 1.5);
uniform vec2 scale = vec2(0.1, 0.2);

void vertex() {
	if (VERTEX.y > 0.0) {
		vec3 worldpos = (WORLD_MATRIX * vec4(VERTEX, 1.0)).xyz;
		VERTEX.x += amplitude * sin(worldpos.x * scale.x * 0.75 + TIME * speed.x) * cos(worldpos.z * scale.x + TIME * speed.x * 0.25);
		VERTEX.z += amplitude * sin(worldpos.x * scale.y + TIME * speed.y * 0.35) * cos(worldpos.z * scale.y * 0.80 + TIME * speed.y);
	}
}

void fragment() {
	vec4 color = texture(tex, UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
	ALPHA_SCISSOR = 0.45;
	
	METALLIC = 0.7;
	SPECULAR = 0.0;//texture(spec, UV).r;
	ROUGHNESS = 1.0;//clamp(1.0-SPECULAR, 0.6, 1.0);
}