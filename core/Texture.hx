package core;

import hxmath.math.Vector4;
import hxmath.math.MathUtil;

class Texture {
	public var filterMode:FilterMode;
	public var wrapMode:WrapMode;

	private var width:UInt;
	private var height:UInt;
	private var buffer:PixelBuffer;

	public function new(width:UInt, height:UInt) {
		this.width = width;
		this.height = height;
	}

	public function getIndex(x:Int, y:Int):Int {
		switch (wrapMode) {
			case WrapMode.Clamp:
				x = Math.floor(MathUtil.clamp(x, 0, width - 1));
				y = Math.floor(MathUtil.clamp(y, 0, height - 1));
			case WrapMode.Repeat:
				x = x % width;
				y = y % height;
		}
		return (y * width + x) * 4;
	}

	// public function sample(u:Float, v:Float):Vector4 {}
}

enum FilterMode {
	Nearest;
	Linear;
}

enum WrapMode {
	Repeat;
	Clamp;
}
