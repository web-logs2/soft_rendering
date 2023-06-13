package core;

import hxmath.math.Vector2;
import hxmath.math.Vector4;
import core.Material.VectorDict;

class Mesh {
	// 顶点描述
	public var attribInfo:Array<VertexFormat>;
	// 顶点大小
	public var stride:Int;
	// 顶点buffer
	public var vbo:Array<Float>;
	// 顶点索引buffer
	public var ibo:Array<Int>;

	public function new(attribInfo:Array<VertexFormat>) {
		this.attribInfo = attribInfo;
		for (v in attribInfo)
			stride += v.num;
	}

	public function getAttribNames():Array<String> {
		return [for (i in 0...attribInfo.length) attribInfo[i].name];
	}

	public function getVertexAttrbs(v:Int, vectorDict:VectorDict) {
		var vec4Dict = vectorDict.vec4s;
		var vec2Dict = vectorDict.vec2s;
		var offset = 0;
		for (attrib in attribInfo) {
			switch (attrib.num) {
				case 4:
					var vec4 = vec4Dict.exists(attrib.name) ? vec4Dict.get(attrib.name) : new Vector4(0, 0, 0, 0);
					for (i in 0...4)
						vec4[i] = vbo[v + offset + i];
					vec4Dict.set(attrib.name, vec4);
					break;
				case 2:
					var vec2 = vec2Dict.exists(attrib.name) ? vec2Dict.get(attrib.name) : new Vector2(0, 0);
					for (i in 0...2)
						vec2[i] = vbo[v + offset + i];
					vec2Dict.set(attrib.name, vec2);
					break;
				default:
					break;
			}
			offset += attrib.num;
		}
	}
}

typedef VertexFormat = {
	var name:String;
	var num:Int;
}
