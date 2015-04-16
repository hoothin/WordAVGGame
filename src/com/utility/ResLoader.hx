package com.utility;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.URLRequest;

/**
 * @time 2014/7/23 9:47:40
 * @author Hoothin
 */
class ResLoader {

	static var _resLoader:ResLoader;
	var bmdList:Map<String, BitmapData>;
	var bmdLoadList:Array<Array<Dynamic>>;
	var curBmdLoad:Array<Dynamic>;
	var bmdLoader:Loader;
	var isLoading:Bool;
	public function new() {
		this.isLoading = false;
		this.bmdLoadList = [];
		this.bmdList = new Map();
		this.bmdLoader = new Loader();
		this.bmdLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bmdLoadComplete);
		this.bmdLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);  
	}
	
	/*-----------------------------------------------------------------------------------------
	Public methods
	-------------------------------------------------------------------------------------------*/
	static public function getInstance():ResLoader {
		if (_resLoader == null) {
			_resLoader = new ResLoader();
		}
		return _resLoader;
	}
	
	public function getBitmapData(resId:String, callBackHandler:BitmapData->Void):Void {
		var result:BitmapData = this.bmdList.get(resId);
		if (result != null) {
			callBackHandler(result);
			return;
		}
		this.bmdList.set(resId, null);
		this.bmdLoadList.push([resId, callBackHandler]);
		this.beginLoad();
	}
	
	/*-----------------------------------------------------------------------------------------
	Private methods
	-------------------------------------------------------------------------------------------*/
	private function beginLoad():Void {
		if (isLoading) {
			return;
		}
		this.isLoading = true;
		if (bmdLoadList.length > 0) {
			this.curBmdLoad = bmdLoadList.shift();
		}else {
			this.isLoading = false;
			this.curBmdLoad = [];
			return;
		}
		var urlRequest:URLRequest = new URLRequest(curBmdLoad[0]);
		this.bmdLoader.load(urlRequest);
		
	}
	/*-----------------------------------------------------------------------------------------
	Event Handlers
	-------------------------------------------------------------------------------------------*/
	private function ioErrorHandler(e:IOErrorEvent):Void {
		this.curBmdLoad[1](null);
		this.isLoading = false;
		this.beginLoad();
	}
	
	private function bmdLoadComplete(e:Event):Void {
		var bmd:BitmapData = cast(this.bmdLoader.content, Bitmap).bitmapData;
		this.bmdList.set(curBmdLoad[0], bmd);
		this.curBmdLoad[1](bmd);
		this.isLoading = false;
		this.beginLoad();
	}
}