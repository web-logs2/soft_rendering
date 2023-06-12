package core;

class Renderer {
	public final width:Int;
	public final height:Int;
	public final pipeline:RenderPipeline;

	public function new(width:Int, height:Int, ?pipeline:RenderPipeline) {
		this.width = width;
		this.height = height;
		this.pipeline = pipeline;
		if (pipeline == null)
			this.pipeline = new RenderPipeline(false, false, false);
	}

	public function render():Void {}
}
