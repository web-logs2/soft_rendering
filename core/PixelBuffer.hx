package core;

import hxmath.math.Vector4;
import haxe.ds.Vector;

class PixelBuffer {
	public final width:UInt;
	public final height:UInt;

	private var pixels:Vector<UInt>;

	public function new(width:UInt, height:UInt, ?pixels:Vector<UInt>) {
		this.width = width;
		this.height = height;
		this.pixels = pixels;
		if (pixels == null)
			this.pixels = new Vector(width * height * 4);
	}

	/**
	 * 提供给外部处理
	 * @return Vector<UInt>
	 */
	public function getPixels():Vector<UInt> {
		return pixels;
	}

	/**
	 * 设置像素颜色
	 * @param x 
	 * @param y 
	 * @param r 0~255
	 * @param g 0~255
	 * @param b 0~255
	 * @param a 0~255
	 */
	public function setColor(x:UInt, y:UInt, r:UInt, g:UInt, b:UInt, a:UInt) {
		var idx = (x + y * width) * 4;
		pixels[idx] = r;
		pixels[idx + 1] = g;
		pixels[idx + 2] = b;
		pixels[idx + 3] = a;
	}

	public function getColor(x:UInt, y:UInt) {
		var idx = (x + y * width) * 4;
		return [pixels[idx++], pixels[idx++], pixels[idx++], pixels[idx]];
	}

	public function setColorVec(x:UInt, y:UInt, vec:Vector4) {
		setColor(x, y, cast(vec.x * 255, UInt), cast(vec.y * 255, UInt), cast(vec.z * 255, UInt), cast(vec.w * 255, UInt));
	}

	public function getColorVec(x:UInt, y:UInt, ?vec:Vector4):Vector4 {
		var color = getColor(x, y);
		if (vec == null)
			vec = new Vector4(0, 0, 0, 0);
		vec.set(color[0] / 255.0, color[1] / 255.0, color[2] / 255.0, color[3] / 255.0);
		return vec;
	}
}
