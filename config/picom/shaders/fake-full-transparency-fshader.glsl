#version 330

in vec2 texcoord;
uniform bool invert_color;

uniform sampler2D tex;

vec4 default_post_processing(vec4 c);

vec4 window_shader() {
	vec4 c = texelFetch(tex, ivec2(texcoord), 0);

	// Change the vec4 to your desired key color
	vec4 vdiff = abs(vec4(1.0, 1.0, 1.0, 1.0) - c);
	float diff = max(max(max(vdiff.r, vdiff.g), vdiff.b), vdiff.a);
	// Change the vec4 to your desired output color
	if (diff < 0.5)
		c *= 2*diff;

	return default_post_processing(c);
}
