package ;

import com.gamePlay.MainGame;
import com.utility.TimeKeeper;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import openfl.Assets;
import openfl.errors.Error;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import xmlVO.GameXmlVO;

/**
 * ...
 * @author Hoothin
 */

class Main extends Sprite {
	var inited:Bool;
	var _configLoader:URLLoader;
	var xmlString:String;
	/* ENTRY POINT */
	
	function resize(e) {
		if (!inited) init();
		// else (resize or orientation change)
	}
	
	function init() {
		if (inited) return;
		inited = true;
		//this._configLoader = new URLLoader();
		//this._configLoader.addEventListener(Event.COMPLETE, configLoadComplete);
		//this._configLoader.load(new URLRequest("jhshe.xml"));
		this.xmlString = Assets.getText("assets/jhshe.xml");
		initGame();
	}
	
	private function configLoadComplete(e:Event):Void {
		this.xmlString = cast(this._configLoader.data, String);
		this.initGame();
	}
	
	private function initGame():Void {
		try {
			GameXmlVO.getInstance().analyzeXml(Xml.parse(xmlString).firstElement());
		}catch (e:Error) {
			trace(e);
		}
		TimeKeeper.openListener();
		var game:MainGame = new MainGame();
		game.startGame();
	}

	/* SETUP */

	public function new() {
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) {
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() {
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
