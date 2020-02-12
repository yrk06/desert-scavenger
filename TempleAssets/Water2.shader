shader_type spatial;
render_mode specular_toon;

uniform sampler2D Noise;
uniform float scale = 1.0;
uniform float globalScale = 0.7;
uniform bool useTide = false;
uniform bool useTideColorChange = false;
uniform float TidePeriod = 0.4;
uniform float TideHeight = 2.5;
varying vec3 v_vertex;
uniform float proximity_fade_distance = 1.0;

float wave(float num)
{
	return sin(num);
	
}
float tide(float time)
{
	return (useTide) ? (TideHeight)*sin(time*2.0*3.14/TidePeriod) : 0.0;
		
	
}
float tideAlb(float time)
{
	return (useTideColorChange) ? 0.5 * sin(time*2.0*3.14/TidePeriod) + 0.51 : 0.5;
	
}
float height(vec2 Position, float time)
{
	float y = 0.1*wave(Position.x+time*0.69);
	y += 0.2*wave(Position.y+time*0.42);
	y += 0.3*wave(Position.x-time*2.9);
	y += 0.4*wave(Position.y-time*2.63);
	y += texture(Noise,(Position*scale)).r;
	return (y * globalScale)+tide(time);+texture(Noise,(Position*scale)).r;
	
}
void vertex()
{
	
	VERTEX.y += height(VERTEX.xz,TIME);
	NORMAL = vec3(VERTEX.y - height(VERTEX.xz + vec2(0.1,0.0),TIME),0.1,VERTEX.y - height(VERTEX.xz + vec2(0.0,0.1),TIME) );
	
	v_vertex = VERTEX;
	
}

void fragment()
{
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	ROUGHNESS = 0.01 * (1.0 - fresnel);
	METALLIC = 0.0;
	RIM = 0.2;
	NORMAL = normalize(cross(dFdx(VERTEX), dFdy(VERTEX)));
	ALBEDO = vec3(0.1,0.3,0.7)*tideAlb(TIME) + (0.1 * fresnel);
	/*if(v_vertex.y >= 0.3)
	{
		ALBEDO += vec3(1.0,1.0,1.0);
	}*/
	float depth_tex = textureLod(DEPTH_TEXTURE,SCREEN_UV,0.0).r;
	vec4 world_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV*2.0-1.0,depth_tex*2.0-1.0,1.0);
	world_pos.xyz/=world_pos.w;
	ALPHA*=clamp(1.0-smoothstep(world_pos.z+proximity_fade_distance,world_pos.z,VERTEX.z),0.0,1.0);
	
	
	
}