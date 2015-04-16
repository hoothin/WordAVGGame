package com.gamePlay;

import com.utility.GameFilterEnum;
import openfl.events.Event;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;

/**
 * @time 2014/7/20 15:44:31
 * @author Hoothin
 */
class BranchItem extends Sprite {

	var branchText:TextField;
	var branchBg:Shape;
	var callBackFun:Void->Void;
	public function new() {
		super();
		this.branchBg = new Shape();
		this.branchBg.graphics.beginFill(0xffffff);
		this.branchBg.graphics.drawRect(0, 0, 200, 20);
		this.branchBg.graphics.endFill();
		this.branchBg.alpha = .3;
		this.branchText = new TextField();
		this.branchText.selectable = this.branchText.mouseEnabled = false;
		this.branchText.autoSize = TextFieldAutoSize.LEFT;
		this.branchText.defaultTextFormat = new TextFormat(null, 15, 0xffffff);
		this.branchText.filters = [GameFilterEnum.wordGlowFilter];
		this.addChild(this.branchBg);
		this.addChild(this.branchText);
		this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
		this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		this.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		this.addEventListener(MouseEvent.CLICK, clickHandler);
		this.buttonMode = true;
	}
	
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	public function initBranch(text:String, callBackFun:Void->Void):Void {
		this.branchText.text = text;
		this.callBackFun = callBackFun;
	}
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function clickHandler(e:MouseEvent):Void {
		this.callBackFun();
	}
	
	private function mouseUpHandler(e:MouseEvent):Void {
		this.branchBg.alpha = .3;
	}
	
	private function mouseDownHandler(e:MouseEvent):Void {
		this.branchBg.alpha = .8;
	}
	
	private function rollOverHandler(e:MouseEvent):Void {
		this.branchBg.alpha = .5;
	}
	
	private function rollOutHandler(e:MouseEvent):Void {
		this.branchBg.alpha = .3;
	}
}