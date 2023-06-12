package core;

class DepthBuffer {
	public final width:Int;
	public final height:Int;

	// 0 ~ 1, 距离摄像机越远, 越接近1
	private final buffer:Array<Float>;

	public final useMSAA:Bool;

	private final bufferMSAA:Array<Array<Float>>;

	// 计算msaa覆盖率
	public final pixelsMsaaCoverage:Array<Int>;

	public function new(width:Int, height:Int, msaa:Bool) {
		this.width = width;
		this.height = height;

		this.buffer = [for (i in 0...width * height) 1];

		this.useMSAA = msaa;
		if (!msaa)
			return;

		for (i in 0...4) {
			bufferMSAA = new Array();
			for (j in 0...width * height)
				bufferMSAA[i][j] = 1;
		}

		pixelsMsaaCoverage = [for (i in 0...width * height) 0];
	}

	public function getZ(x:Int, y:Int, ?level:Int):Float {
		var idx = x + y * width;
		if (level != null)
			return bufferMSAA[level][idx];
		return buffer[idx];
	}

	public function setZ(x:Int, y:Int, z:Float, ?level:Int):Void {
		var idx = x + y * width;
		if (level != null)
			bufferMSAA[level][idx] = z;
		buffer[idx] = z;
	}

	public function clear():Void {
		for (i in 0...buffer.length)
			buffer[i] = 1;
		if (!useMSAA)
			return;

		for (i in 0...bufferMSAA.length) {
			for (j in 0...bufferMSAA[i].length) {
				bufferMSAA[i][j] = 1;
			}
		}
		for (i in 0...pixelsMsaaCoverage.length)
			pixelsMsaaCoverage[i] = 0;
	}

	public function addMsaaCount(x:Int, y:Int):Void {
		var idx = x + y * width;
		pixelsMsaaCoverage[idx]++;
	}

	public function getMsaaCount(x:Int, y:Int):Int {
		var idx = x + y * width;
		return pixelsMsaaCoverage[idx];
	}

	public function checkZ(x:Int, y:Int, z:Float, ?level:Int):Bool {
		var ZTest = () -> z < getZ(x, y, level);
		if (!ZTest())
			return false;
		setZ(x, y, z);
		return true;
	}
}
