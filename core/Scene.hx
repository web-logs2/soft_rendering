package core;

class Scene {
	public final materials:List<Material> = new List();

	private var passTime:Float = 0;

	public function new() {}

	public function update(dt:Float) {
		passTime += dt;
	}

	public function updateMaterialUniforms() {}
}
