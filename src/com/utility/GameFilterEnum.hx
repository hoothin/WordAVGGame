package com.utility;
import openfl.filters.BlurFilter;
import openfl.filters.ColorMatrixFilter;
import openfl.filters.GlowFilter;
import openfl.text.TextFormat;

/**
 * @time 2013/10/30 14:13:22
 * @author Hoothin
 */
class GameFilterEnum
{
	public static var wordGlowFilter:GlowFilter = new GlowFilter(0x000000, 1, 2, 2, 6, 1);
	public static var dialogGlowFilter:GlowFilter = new GlowFilter(0xffffff, 1, 2, 2, 6, 1);
	public static var selectGlowFilter:GlowFilter = new GlowFilter(0xffde00, 1, 2, 2, 4, 1);
	public static var yellowGlowFilter:GlowFilter = new GlowFilter(0xFFFF8A, 1, 2, 2);
	public static var EscortGlowFilter:GlowFilter = new GlowFilter(0xffea00, 1, 3, 2);
	public static var blueGlowFilter:GlowFilter = new GlowFilter(0x7DFCFF, 1, 4, 4);
	public static var blurAnimationFilter:BlurFilter = new BlurFilter(6, 6, 1);
	public static var grayColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0]);
	public static var duskColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([0.7, 0, 0, 0, 19.05, 0, 0.7, 0, 0, 19.05, 0, 0, 0.7, 0, 19.05, 0, 0, 0, 1, 0]);
	
	public static var redColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,137,0,1,0,0,-125,0,0,1,0,-255,0,0,0,1,0]);
	public static var greenColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,-60,0,1,0,0,90,0,0,1,0,-20,0,0,0,1,0]);
	public static var blueColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,-59,0,1,0,0,42,0,0,1,0,188,0,0,0,1,0]);
	public static var yellowColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1,0,0,0,255,0,1,0,0,11,0,0,1,0,-147,0,0,0,1,0]);
	public static var purpleColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 54, 0, 1, 0, 0, -13025, 0, 0, 1, 0, 255, 0, 0, 0, 1, 0]);
	
	public static var redBuffColorFilter:ColorMatrixFilter = new ColorMatrixFilter([0.66,0,0,0,87,0,0.66,0,0,0,0,0,0.66,0,0,0,0,0,1,0]);
	public static var yellowBuffColorFilter:ColorMatrixFilter = new ColorMatrixFilter([0.66,0,0,0,87,0,0.66,0,0,69,0,0,0.66,0,0,0,0,0,1,0]);
	public static var greenBuffColorFilter:ColorMatrixFilter = new ColorMatrixFilter([0.66,0,0,0,35,0,0.66,0,0,87,0,0,0.66,0,0,0,0,0,1,0]);
	public static var purpleBuffColorFilter:ColorMatrixFilter = new ColorMatrixFilter([0.66,0,0,0,35,0,0.66,0,0,17,0,0,0.66,0,52,0,0,0,1,0]);
}