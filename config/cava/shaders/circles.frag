#version 330

in vec2 fragCoord;
out vec4 fragColor;

// bar values. defaults to left channels first (low to high), then right (high to low).
uniform float bars[512];

uniform int bars_count;    // number of bars (left + right) (configurable)

uniform vec3 u_resolution; // window resolution, not used here

//colors, configurable in cava config file
uniform vec3 bg_color; // background color(r,g,b) (0.0 - 1.0), not used here
uniform vec3 fg_color; // foreground color, not used here

float circle(in vec2 st, in float radius)
{
	vec2 dist = st - vec2(0.5);
	return 1.0 - smoothstep(radius - (radius * 0.01),
			radius + (radius * 0.01),
			dot(dist, dist) * 4.0);
}

void main()
{
	// find which bar to use based on where we are on the x axis
	int bar = int(bars_count * fragCoord.x);

	vec2 aspect = u_resolution.xy / min(u_resolution.x, u_resolution.y);

	vec3 c1 = vec3(circle((fragCoord.xy)*aspect, bars[bar]));
	vec3 c2 = vec3(circle((fragCoord.xy)*aspect + vec2(1) - aspect, bars[bar]));


	float mixAmt = distance(fragCoord.xy, vec2(0.5, 0.5));
	fragColor = vec4(clamp(mix(vec3(1.0,0.0,0.0), vec3(0.0,0.0,1.0), mixAmt)*(c1+c2), 0.0, 1.0), 1.0);
}
