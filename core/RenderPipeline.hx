package core;

import core.Material.VectorDict;
import hxmath.math.Vector4;
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
	// 渲染模式
	private var renderMode:RenderMode;

	private var frameBuffer:FrameBuffer;
	private var depthBuffer:DepthBuffer;
	private var stencilBuffer:StencilBuffer;

	// gl缓存数据
	private final glDatas:Array<GLData> = new Array();
	private final positions:Array<Vector4> = new Array();
	private final depths:Array<Float> = new Array();

	public function new(useMSAA:Bool, useZTest:Bool, useStencil:Bool) {
		this.useMSAA = useMSAA;

		frameBuffer = new FrameBuffer(width, height);
		depthBuffer = new DepthBuffer(width, height, useMSAA);
		stencilBuffer = new StencilBuffer(width, height);
	}

	public function initialize(renderer:Renderer) {
		width = renderer.width;
		height = renderer.height;
	}

	public function draw(material:Material) {
		var mesh = material.mesh;
		var shader = material.shader;
		var indices = mesh.ibo;

		glDatas.resize(0);
		depths.resize(0);
		positions.resize(0);

		var i = 0;
		while (i < mesh.vbo.length) {
			// var glData:GLData = ;

			// mesh.getVertexAttrbs(i, glData);

			i += mesh.stride;
		}
	}
}

enum RenderMode {
	Point;
	Line;
	Triangle;
}

typedef GLData = {
	attributes:VectorDict,
	varyingDict:VectorDict,
}
