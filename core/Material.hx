package core;

import hxmath.math.Matrix4x4;
import hxmath.math.Vector2;
import hxmath.math.Vector4;

class Material {
	public var name:String;
	public final mesh:Mesh;
	public final shader:Shader;
	public final uniformData:UniformData;

	// 开启深度写入
	public var useDepthWrite:Bool = true;
	// 开启背面剔除
	public var useFaceCulling:Bool = false;
	// 开启模版写入
	public var useStencilWrite:Bool = false;

	public function new(name:String, mesh:Mesh, shader:Shader, ?texture:Texture) {
		this.name = name;
		this.mesh = mesh;
		this.shader = shader;
		this.uniformData = {
			mat4s: new Map(),
			textures: new Map(),
			vec4s: new Map(),
			doubles: new Map()
		};
		if (texture != null) {}
	}
}

typedef UniformData = {
	var mat4s:Map<String, Matrix4x4>;
	var textures:Map<String, Texture>;
	var vec4s:Map<String, Vector4>;
	var doubles:Map<String, Float>;
}

typedef VectorDict = {
	var vec4s:Map<String, Vector4>;
	var vec2s:Map<String, Vector2>;
}
