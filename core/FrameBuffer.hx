package core;

import hxmath.math.Vector4;

class FrameBuffer {
	public final width:Int;
	public final height:Int;

	// 像素buffer  r_g_b_a格式
	public final pixelBuffer:Array<Int>;

	public function new(width:Int, height:Int) {
		this.width = width;
		this.height = height;

		pixelBuffer = [for (i in 0...width * height) 0];
	}

	public function setColor(x:Int, y:Int, color:Vector4):Void {
		if (x < 0 || x >= this.width)
			return;
		if (y < 0 || y >= this.height)
			return;
		// 透明的, 不处理
		if (color.w <= 0)
			return;
		// 半透明
		if (color.w < 1) {
			var oldColor = getColor(x, y);
			color = oldColor.multiplyWith(1 - color.w).addWith(color.multiplyWith(color.w));
		}

		var idx = (x + y * this.width) * 4;
		pixelBuffer[idx] = cast(color.x * 255, Int);
		pixelBuffer[idx + 1] = cast(color.y * 255, Int);
		pixelBuffer[idx + 2] = cast(color.z * 255, Int);
		pixelBuffer[idx + 3] = cast(color.w * 255, Int);
	}

	public function getColor(x:Int, y:Int):Vector4 {
		var idx = (x + y * this.width) * 4;
		var r = pixelBuffer[idx] / 255.0;
		var g = pixelBuffer[idx + 1] / 255.0;
		var b = pixelBuffer[idx + 2] / 255.0;
		var a = pixelBuffer[idx + 3] / 255.0;
		return new Vector4(r, g, b, a);
	}

	public function clear() {
		for (i in 0...pixelBuffer.length) {
			pixelBuffer[i] = 0;
		}
	}

	public function doMSAA(coverages:Array<Int>) {
		for (y in 0...height) {
			for (x in 0...width) {
				var idx = (x + y * width) * 4;
				var count = cast(Math.min(1, coverages[x + y * width] / 4.0), Int);

				pixelBuffer[idx] = Math.floor(pixelBuffer[idx] * count);
				pixelBuffer[idx + 1] = Math.floor(pixelBuffer[idx + 1] * count);
				pixelBuffer[idx + 2] = Math.floor(pixelBuffer[idx + 2] * count);
				pixelBuffer[idx + 3] = Math.floor(pixelBuffer[idx + 3] * count);
			}
		}
	}
}
