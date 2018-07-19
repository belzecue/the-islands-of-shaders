shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx;

uniform sampler2D tex_col : hint_black_albedo;
uniform sampler2D tex_ao : hint_black_albedo;
uniform sampler2D tex_disp;
uniform sampler2D tex_nrm : hint_normal;
uniform sampler2D tex_rgh;

uniform float uv_scale = 2.0;

void fragment () {
	vec2 uvs = UV*uv_scale;
	ALBEDO = texture(tex_col, uvs).rgb * 0.4;
	METALLIC = texture(tex_disp, uvs).r;
	SPECULAR = 1.0;
	ROUGHNESS = texture(tex_rgh, uvs).r;

	NORMALMAP = texture(tex_nrm, uvs).rgb;
	NORMALMAP_DEPTH = 4.0;
	AO = texture(tex_ao, UV.xy*uv_scale).r;
	AO_LIGHT_AFFECT = 1.0;
	SSS_STRENGTH = 0.0;
}