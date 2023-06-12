package core;

import hxmath.math.Matrix4x4;

class RenderPipeline {
	private var width:Int;
	private var height:Int;
	private var viewportMat:Matrix4x4;
	// 抗锯齿
	private var useMSAA:Bool;
	// 深度测试
	private var useZTest:Bool;
	// 模版测试
	private var useStencil:Bool;
	// 模版写入
	private var writeStencil:Bool;
	private var renderMode:RenderMode;

	private var frameBuffer:FrameBuffer;
	private var depthBuffer:DepthBuffer;

	public function new(useMSAA:Bool, useZTest:Bool, useStencil:Bool) {
		this.useMSAA = useMSAA;
	}

	public function initialize(renderer:Renderer) {
		width = renderer.width;
		height = renderer.height;
	}

	public function draw() {}
}

enum RenderMode {
	Point;
	Line;
	Triangle;
}
