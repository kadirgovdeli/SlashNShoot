shader_type canvas_item;

uniform sampler2D screen_texture:hint_screen_texture, filter_linear_mipmap;
uniform float blur = 0.0;
uniform float brightness = 1.0;
void fragment() {
	COLOR = textureLod(screen_texture, SCREEN_UV, blur);
	COLOR *= brightness; 
}
