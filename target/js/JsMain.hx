package target.js;

import js.Browser;
import core.FrameBuffer;

class JsMain {
	static function main() {
		var button = Browser.document.createButtonElement();
		button.textContent = "Click me!";
		button.onclick = (event) -> Browser.alert("Haxe is great");
		Browser.document.body.appendChild(button);

		new FrameBuffer(100, 100);
	}
}
