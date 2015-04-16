package com.gamePlay ;

import com.utility.GameFilterEnum;
import com.utility.ResLoader;
import com.utility.TimeKeeper;
import openfl.display.BitmapData;
import motion.Actuate;
import motion.easing.Linear;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.MouseEvent;
import openfl.events.ProgressEvent;
import openfl.Lib;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundLoaderContext;
import openfl.net.URLRequest;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import unifill.Unifill;
import xmlVO.GameBlock;
import xmlVO.GameXmlVO;

/**
 * @time 2014/7/19 19:29:25
 * @author Hoothin
 */
class MainGame extends Sprite {

	var wordsCon:Sprite;
	var wordsBg:Shape;
	var words:TextField;
	var curWords:String;
	var peopleName:TextField;
	var rightHead:Bitmap;
	var leftHead:Bitmap;
	var curNode:Int;
	var blockMap:Map<String, GameBlock>;
	var curBlock:GameBlock;
	var asideCon:Sprite;
	var asideText:TextField;
	var asideBg:Shape;
	var curAside:String;
	var nodeValue:Xml;
	var showComplete:Bool;
	var variableMap:Map<String, Int>;
	var branchBox:Sprite;
	var scene:Bitmap;
	var backMusic:Sound;
	var backSoundChannel:SoundChannel;
	var soundEffect:Sound;
	var effectSoundChannel:SoundChannel;
	public function new() {
		super();
		this.backMusic = new Sound();
		this.soundEffect = new Sound();
		this.scene = new Bitmap();
		this.addChild(scene);
		this.variableMap = new Map();
		this.showComplete = false;
		this.wordsBg = new Shape();
		this.wordsBg.alpha = .3;
		this.wordsBg.graphics.beginFill(0xffffff);
		this.wordsBg.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, 100);
		this.wordsBg.graphics.endFill();
		this.words = new TextField();
		this.words.selectable = this.words.mouseEnabled = false;
		this.words.wordWrap = true;
		this.words.width = Lib.current.stage.stageWidth - 20;
		this.words.defaultTextFormat = new TextFormat(null, 16, 0xffffff);
		this.words.filters = [GameFilterEnum.wordGlowFilter];
		this.words.x = 10;
		this.words.y = 30;
		this.peopleName = new TextField();
		this.peopleName.selectable = this.peopleName.mouseEnabled = false;
		this.peopleName.autoSize = TextFieldAutoSize.LEFT;
		this.peopleName.defaultTextFormat = new TextFormat(null, 17, 0xffffff);
		this.peopleName.filters = [GameFilterEnum.wordGlowFilter];
		this.peopleName.x = 10;
		this.peopleName.y = 5;
		this.leftHead = new Bitmap();
		this.rightHead = new Bitmap();
		this.rightHead.filters = [GameFilterEnum.grayColorMatrixFilter];
		this.wordsCon = new Sprite();
		this.wordsCon.addChild(this.wordsBg);
		this.wordsCon.addChild(this.peopleName);
		this.wordsCon.addChild(this.words);
		this.wordsCon.addChild(this.leftHead);
		this.wordsCon.addChild(this.rightHead);
		this.addChild(wordsCon);
		this.asideBg = new Shape();
		this.asideBg.alpha = .3;
		this.asideBg.graphics.beginFill(0xffffff);
		this.asideBg.graphics.drawRect(0, 0, Lib.current.stage.stageWidth, Lib.current.stage.stageHeight);
		this.asideBg.graphics.endFill();
		this.asideText = new TextField();
		this.asideText.x = 10;
		this.asideText.selectable = this.asideText.mouseEnabled = false;
		this.asideText.autoSize = TextFieldAutoSize.LEFT;
		this.asideText.defaultTextFormat = new TextFormat(null, 16, 0xffffff);
		this.asideText.filters = [GameFilterEnum.wordGlowFilter];
		this.asideCon = new Sprite();
		this.asideCon.addChild(asideBg);
		this.asideCon.addChild(asideText);
		this.addChild(asideCon);
		this.branchBox = new Sprite();
		this.branchBox.mouseEnabled = false;
		this.branchBox.visible = false;
		this.addChild(branchBox);
		this.blockMap = GameXmlVO.getInstance().blockMap;
		this.resize();
		Lib.current.stage.addEventListener(Event.RESIZE, resize);
		this.addEventListener(MouseEvent.CLICK, clickHandler);
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public function startGame():Void {
		Lib.current.stage.addChild(this);
		this.initBlock(blockMap.get("first"));
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function initBlock(block:GameBlock):Void {
		if (block == null) return;
		ResLoader.getInstance().getBitmapData("assets/img/" + block.bg + ".jpg", function(e:BitmapData) {
			scene.bitmapData = e;
			scene.width = Lib.current.stage.stageWidth;
			scene.height = Lib.current.stage.stageHeight;
		});
		
		this.curNode = 0;
		this.curBlock = block;
		this.analyze();
	}
	
	private function nextNode():Void {
		curNode++;
		analyze();
	}
	
	private function analyze():Void {
		this.nodeValue = this.curBlock.nodeMap.get(curNode);
		if (nodeValue == null) {
			if (curBlock.jump != null && curBlock.jump != "") {
				this.initBlock(blockMap.get(curBlock.jump));
			}
			return;
		}
		switch(nodeValue.nodeName) {
			case "aside":
				this.showAside(this.curBlock.nodeMap.get(curNode));
			case "words":
				this.showWords(this.curBlock.nodeMap.get(curNode));
			case "branchs":
				this.showBranchs(this.curBlock.nodeMap.get(curNode));
			case "switch":
				this.switchBg(this.curBlock.nodeMap.get(curNode));
			case "judge":
				this.judge(this.curBlock.nodeMap.get(curNode));
			case "music":
				this.playMusic(this.curBlock.nodeMap.get(curNode));
			case "sound":
				this.playSound(this.curBlock.nodeMap.get(curNode));
		}
	}
	
	private function playSound(xmlData:Xml):Void {
		var soundName:String = xmlData.get("name");
		this.soundEffect.close();
		if (effectSoundChannel != null) {
			effectSoundChannel.stop();
		}
		if (soundName == "" || soundName == null) {
			
		}else {
			this.soundEffect.load(new URLRequest("assets/sound/" + soundName));
			this.effectSoundChannel = this.soundEffect.play(0);
		}
		nextNode();
	}
	
	private function playMusic(xmlData:Xml):Void {
		var musicName:String = xmlData.get("name");
		this.backMusic.close();
		if (backSoundChannel != null) {
			backSoundChannel.stop();
		}
		if (musicName == "" || musicName == null) {
			
		}else {
			this.backMusic.load(new URLRequest("assets/sound/" + musicName));
			this.backSoundChannel = this.backMusic.play(0, 99999);
		}
		nextNode();
	}
	
	private function switchBg(xmlData:Xml):Void {
		var rate:Int = Std.parseInt(xmlData.get("rate"));
		ResLoader.getInstance().getBitmapData("assets/img/" + xmlData.get("bg") + ".jpg", function(e:BitmapData) {
			Actuate.tween(scene, rate, { alpha:.01 } ).ease(Linear.easeNone).onComplete(hideComplete, [rate, e]);
			nextNode();
		});
	}
	
	private function hideComplete(rate:Int, bgSource:BitmapData):Void {
		this.scene.bitmapData = bgSource;
		this.scene.width = Lib.current.stage.stageWidth;
		this.scene.height = Lib.current.stage.stageHeight;
		Actuate.tween(this.scene, rate, { alpha:1 } ).ease(Linear.easeNone);
	}
	
	private function judge(xmlData:Xml):Void {
		var value:Int = this.variableMap.get(xmlData.get("key"));
		var goalStr:String = xmlData.get("goal");
		var goalValue:Int = Std.parseInt(goalStr.substr(1));
		var targetStr:String = xmlData.get("target");
		if (targetStr == null || targetStr == "") {
			return;
		}
		switch(goalStr.charAt(0)) {
			case ">":
				if (value > goalValue) {
					this.initBlock(blockMap.get(targetStr));
				}
			case "<":
				if (value < goalValue) {
					this.initBlock(blockMap.get(targetStr));
				}
			case "=":
				if (value == goalValue) {
					this.initBlock(blockMap.get(targetStr));
				}
		}
	}
	
	private function showBranchs(xmlData:Xml):Void {
		while (this.branchBox.numChildren > 0) {
			this.branchBox.removeChildAt(0);
		}
		this.branchBox.visible = true;
		for (branch in xmlData.elements()) {
			var branchItem:BranchItem = new BranchItem();
			branchItem.initBranch(branch.get("text"), function() {
				this.branchBox.visible = false;
				var changeStr:String = branch.get("change");
				if (changeStr != null) {
					var changeKey:String = changeStr.split(",")[0];
					var changeValue:Int = Std.parseInt(changeStr.split(",")[1]);
					var nowValue:Int = this.variableMap.get(changeKey);
					this.variableMap.set(changeKey, changeValue + nowValue);
				}
				var targetStr:String = branch.get("target");
				if (targetStr != null && targetStr != "") {
					this.initBlock(blockMap.get(targetStr));
				}
			});
			branchItem.y = this.branchBox.numChildren * 25;
			this.branchBox.addChild(branchItem);
		}
		this.branchBox.x = (Lib.current.stage.stageWidth - this.branchBox.width) / 2;
		this.branchBox.y = (Lib.current.stage.stageHeight - this.branchBox.height) / 2;
	}
	
	private function showWords(xmlData:Xml):Void {
		this.peopleName.text = xmlData.get("name");
		if (xmlData.get("clearOtherHead") == "false") {
			this.rightHead.bitmapData = this.leftHead.bitmapData;
			this.leftHead.bitmapData = null;
		}else {
			this.leftHead.bitmapData = null;
			this.rightHead.bitmapData = null;
		}
		if (xmlData.get("head") == "" || xmlData.get("head") == null) {
			leftHead.bitmapData = null;
		}else {
			ResLoader.getInstance().getBitmapData("assets/img/" + xmlData.get("head") + ".png", function(e:BitmapData) {
				leftHead.bitmapData = e;
				leftHead.y = -leftHead.height;
			});
			
		}
		
		this.rightHead.x = Lib.current.stage.stageWidth - this.rightHead.width;
		this.rightHead.y = -this.rightHead.height;
		this.curWords = xmlData.get("text");
		this.words.text = "";
		TimeKeeper.addTimerEventListener(refreshWords, 50);
		this.showComplete = false;
		refreshWords(0);
	}
	
	private function showAside(xmlData:Xml):Void {
		this.asideCon.visible = true;
		this.wordsCon.visible = false;
		this.curAside = xmlData.get("text");
		if (xmlData.get("clearBefore") == "true") {
			this.asideText.text = "";
		}
		this.asideText.appendText("\n" + curAside);
		TimeKeeper.addTimerEventListener(refreshAside, 2000);
		//refreshAside(0);
	}
	
	private function refreshWords(value:Float):Void {
		var wordsLength = Unifill.uLength(this.words.text);
		if (wordsLength >= Unifill.uLength(curWords)) {
			TimeKeeper.removeTimerEventListener(refreshWords);
			this.showComplete = true;
			return;
		}
		wordsLength++;
		this.words.text = Unifill.uSubstr(curWords, 0, wordsLength);
	}
	
	private function refreshAside(value:Float):Void {
		//if (curAside.length <= 0) {
			//TimeKeeper.removeTimerEventListener(refreshAside);
			//this.showComplete = true;
			//if (nodeValue.get("auto") == "true") {
				//this.asideCon.visible = false;
				//this.wordsCon.visible = true;
				//this.nextNode();
			//}
			//return;
		//}
		//this.asideText.text += curAside.charAt(0);
		//curAside = curAside.substr(1);
		if (nodeValue == null) return;
		if (nodeValue.get("auto") == "true") {
			this.asideCon.visible = false;
			this.wordsCon.visible = true;
			this.nextNode();
		}
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function resize(e:Event = null) {
		this.wordsCon.y = Lib.current.stage.stageHeight - this.wordsBg.height;
		this.wordsBg.width = Lib.current.stage.stageWidth;
		this.words.width = Lib.current.stage.stageWidth - 20;
		this.branchBox.x = (Lib.current.stage.stageWidth - this.branchBox.width) / 2;
		this.branchBox.y = (Lib.current.stage.stageHeight - this.branchBox.height) / 2;
		this.asideBg.width = Lib.current.stage.stageWidth;
		this.asideBg.height = Lib.current.stage.stageHeight;
		this.scene.width = Lib.current.stage.stageWidth;
		this.scene.height = Lib.current.stage.stageHeight;
		this.leftHead.y = -this.leftHead.height;
		this.rightHead.x = Lib.current.stage.stageWidth - this.rightHead.width;
		this.rightHead.y = -this.rightHead.height;
	}
	
	private function clickHandler(e:MouseEvent):Void {
		if (nodeValue == null) return;
		switch (nodeValue.nodeName) {
			case "aside":
				if (nodeValue.get("auto") != "true") {
					//if (showComplete) {
						TimeKeeper.removeTimerEventListener(refreshWords);
						this.asideCon.visible = false;
						this.wordsCon.visible = true;
						nextNode();
					//}else {
						//this.asideText.text += curAside;
						//this.curAside = "";
						//this.refreshAside(0);
					//}
				}
			case "words":
				if (showComplete) {
					nextNode();
				}else {
					this.words.text = curWords;
					this.refreshWords(0);
				}
		}
	}
}