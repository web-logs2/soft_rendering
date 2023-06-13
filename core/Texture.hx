package core;

import haxe.ds.Vector;
import hxmath.math.Vector4;
import hxmath.math.MathUtil;

class Texture {
	public final width:UInt;
	public final height:UInt;

	// 一维的数组存储像素数据
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
	 * [设置像素颜色]
	 * @param idx 索引头
	 * @param r 0~255
	 * @param g 0~255
	 * @param b 0~255
	 * @param a 0~255
	 */
	public function setColor(idx:UInt, r:UInt, g:UInt, b:UInt, a:UInt) {
		pixels[idx] = r;
		pixels[++idx] = g;
		pixels[++idx] = b;
		pixels[++idx] = a;
	}

	public function getColor(idx:UInt) {
		return [pixels[idx], pixels[++idx], pixels[++idx], pixels[++idx]];
	}

	public function getIndex(x:UInt, y:UInt, wrapMode:WrapMode):UInt {
		switch (wrapMode) {
			case WrapMode.Clamp:
				x = Math.floor(MathUtil.clamp(x, 0, width - 1));
				y = Math.floor(MathUtil.clamp(y, 0, height - 1));
			case WrapMode.Repeat:
				x = x % width;
				y = y % height;
		}
		return (x + y * width) * 4;
	}

	public function setColorVec(idx:UInt, vec:Vector4) {
		setColor(idx, cast(vec.x * 255, UInt), cast(vec.y * 255, UInt), cast(vec.z * 255, UInt), cast(vec.w * 255, UInt));
	}

	public function getColorVec(idx:UInt, ?vec:Vector4):Vector4 {
		var color = getColor(idx);
		if (vec == null)
			vec = new Vector4(0, 0, 0, 0);
		vec.set(color[0] / 255.0, color[1] / 255.0, color[2] / 255.0, color[3] / 255.0);
		return vec;
	}

	/**
	 * [采样]
	 * @param filterMode 
	 * @param u 
	 * @param v 
	 * @param wrapMode 
	 * @return Vector4
	 */
	public function sample(filterMode:FilterMode, u:Float, v:Float, wrapMode:WrapMode):Vector4 {
		var x = u * (width - 1) + 0.5;
		var y = height - (v * (height - 1) + 0.5);

		switch (filterMode) {
			case FilterMode.Nearest:
				return nearest(x, y, wrapMode);
			case FilterMode.Linear:
				return bilinear(x, y, wrapMode);
		}
		return new Vector4(0, 0, 0, 0);
	}

	public function nearest(x:Float, y:Float, wrapMode:WrapMode):Vector4 {
		return getColorVec(getIndex(Math.floor(x), Math.floor(y), wrapMode));
	}

	public function bilinear(x:Float, y:Float, wrapMode:WrapMode):Vector4 {
		var cx1 = Math.floor(x);
		var cy1 = Math.floor(y);
		var cx2 = Math.round(x);
		var cy2 = Math.round(y);

		if (cx1 == cx2)
			cx2 = cx2 >= 1 ? cx2 - 1 : cx2;
		if (cy1 == cy2)
			cy2 = cy2 >= 1 ? cy2 - 1 : cy2;

		var c1 = getIndex(cx1, cy1, wrapMode);
		var c2 = getIndex(cx2, cy1, wrapMode);
		var c3 = getIndex(cx1, cy2, wrapMode);
		var c4 = getIndex(cx2, cy2, wrapMode);

		var dx = Math.abs(x - (cx1 + 0.5));
		var dy = Math.abs(y - (cy1 + 0.5));

		var w1 = (1 - dx) * (1 - dy);
		var w2 = dx * (1 - dy);
		var w3 = dy * (1 - dx);
		var w4 = dx * dy;

		var r = Math.round(pixels[c1] * w1 + pixels[c2] * w2 + pixels[c3] * w3 + pixels[c4] * w4);
		var g = Math.round(pixels[c1 + 1] * w1 + pixels[c2 + 1] * w2 + pixels[c3 + 1] * w3 + pixels[c4 + 1] * w4);
		var b = Math.round(pixels[c1 + 2] * w1 + pixels[c2 + 2] * w2 + pixels[c3 + 2] * w3 + pixels[c4 + 2] * w4);
		var a = Math.round(pixels[c1 + 3] * w1 + pixels[c2 + 3] * w2 + pixels[c3 + 3] * w3 + pixels[c4 + 3] * w4);

		return new Vector4(r / 255, g / 255, b / 255, a / 255);
	}
}

enum WrapMode {
	Repeat;
	Clamp;
}

enum FilterMode {
	Nearest;
	Linear;
}
