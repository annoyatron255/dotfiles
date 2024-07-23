#version 330

#define ROW_ASPECT 1.2

in vec2 fragCoord;
out vec4 fragColor;

uniform float bars[512];

uniform int bars_count;

uniform vec3 u_resolution;

uniform vec3 bg_color;
uniform vec3 fg_color;

float circle(in vec2 st, in vec2 point, in float radius)
{
	vec2 aspect = u_resolution.xy / min(u_resolution.x, u_resolution.y);

	vec2 dist = (st - point)*aspect;
	return 1.0 - smoothstep(radius - (radius * 0.5),
			radius + (radius * 0.5),
			dot(dist, dist) * 4.0);
}

void main()
{
	// find which bar to use based on where we are on the x axis
	int bar = int(bars_count * fragCoord.x);

	// Calculate number of rows to use
	int rows = int(float(bars_count) * u_resolution.y / u_resolution.x * ROW_ASPECT);

	// Calculate current vertical row position
	int v_index = int(rows * fragCoord.y);

	// Circle
	float brightness = circle(fragCoord.xy,
			vec2(bar/float(bars_count)+1/(2*float(bars_count)),
			float(v_index)/rows+1.0/(2.0*rows)),
			2.0 / min(u_resolution.x, u_resolution.y) / min(rows, bars_count));
	// Fade last dot
	brightness *= clamp(rows*bars[bar] - (rows - v_index), 0.0, 1.0);

	// Gradient color points
	vec3 c1 = vec3(0.157,0.075,0.2);
	vec3 c2 = vec3(0.678,0.094,0.741);
	vec3 c3 = vec3(0.035,0.102,0.824);
	vec3 c4 = vec3(0.047,0.784,0.973);
	vec3 c5 = vec3(0.208,0.812,0.953);
	vec3 c6 = vec3(0.518,0.925,0.961);
	vec3 c7 = vec3(0.58,0.922,0.933);
	vec3 c8 = vec3(0.992,0.992,1.);
	vec3 c9 = vec3(1.0,1.0,1.0);

	// Make gradient
	vec3 c = vec3(0.0, 0.0039, 0.0);
	float mixAmt = (1.0-fragCoord.y)/2.0;
	if (brightness != 0.0) {
		float step = 1.0/9.0;
		c = mix(c1, c2, smoothstep(0.0, step, mixAmt));
		c = mix(c, c3, smoothstep(step, 2*step, mixAmt));
		c = mix(c, c4, smoothstep(2*step, 3*step, mixAmt));
		c = mix(c, c5, smoothstep(4*step, 5*step, mixAmt));
		c = mix(c, c6, smoothstep(6*step, 7*step, mixAmt));
		c = mix(c, c7, smoothstep(8*step, 9*step, mixAmt));
		//c = mix(c, c8, smoothstep(0.0, 0.99, mixAmt));
		//c = mix(c, c9, smoothstep(0.0, 1.0, mixAmt));

		fragColor = vec4(mix(c, vec3(1.0), smoothstep(1.0, 0.0, brightness)), 1.0);
	} else {
		fragColor = vec4(1.0, 1.0, 1.0, 1.0);
	}

}
