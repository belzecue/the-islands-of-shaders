shader_type particles;

uniform float rows = 64;
uniform float spacing = 2.0;

uniform sampler2D height_map;
uniform float max_height = 45.0;
uniform float height_mask_min = 0.02;
uniform float height_mask_max = 0.20;
uniform vec2 heightmap_size = vec2(512.0, 512.0);

uniform sampler2D noisemap;

float get_height(vec2 pos) {
	pos -= 0.5 * heightmap_size;
	pos /= heightmap_size;
	return max_height * texture(height_map, pos).r - 0.6;
}

void vertex() {
	// obtain our position based on which particle we're rendering
	vec3 pos = vec3(0.0, 0.0, 0.0);
	pos.z = float(INDEX);
	pos.x = mod(pos.z, rows);
	pos.z = (pos.z - pos.x) / rows;
	
	// center this
	pos.x -= rows * 0.5;
	pos.z -= rows * 0.5;
	
	// and now apply our spacing
	pos *= spacing;
	
	// now center on our particle location but within our spacing
	pos.x += EMISSION_TRANSFORM[3][0] - mod(EMISSION_TRANSFORM[3][0], spacing);
	pos.z += EMISSION_TRANSFORM[3][2] - mod(EMISSION_TRANSFORM[3][2], spacing);
	
	// now add some noise based on our _world_ position
	vec3 noise = texture(noisemap, pos.xz * 0.02).rgb;
	pos.x += (noise.x * 4.0 ) * spacing;
	pos.z += (noise.y * 4.0 ) * spacing;
	
	// apply our height
	pos.y = get_height(pos.xz);

	vec2 feat_pos = pos.xz;
	feat_pos -= 0.5 * heightmap_size;
	feat_pos /= heightmap_size;
	float terrain_mask = texture(height_map, feat_pos).r;
	
	if (terrain_mask > height_mask_max || terrain_mask < height_mask_min) {
		pos.y = -10000.0;
	}
	noise = texture(noisemap, pos.xz * 0.01).rgb;
	float scale = noise.x * 1.5;
	TRANSFORM[2][0] = scale;
	TRANSFORM[2][1] = scale;

	TRANSFORM[3][0] = pos.x;
	TRANSFORM[3][1] = pos.y;
	TRANSFORM[3][2] = pos.z;
}