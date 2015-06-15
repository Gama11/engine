package flixel.input;

import flixel.input.keyboard.FlxKey;
import flixel.input.android.FlxAndroidKey;
import flixel.input.FlxInput;
import flixel.FlxG;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadInputID;

class FlxInputMapping implements IFlxInput
{
	public var justReleased(get, never):Bool;
	public var released(get, never):Bool;
	public var pressed(get, never):Bool;
	public var justPressed(get, never):Bool;
	
	public var keys:Array<FlxKey> = [];
	
	public var androidKeys:Array<FlxAndroidKey> = [];
	
	public var gamepadButtons:Array<FlxGamepadInputID> = [];
	public var gamepadIDs:Array<Int> = null;
	
	public var inputs:Array<IFlxInput> = [];
	
	public function new()
	{
		
	}
	
	private function checkInputs(state:FlxInputState):Bool
	{
		#if !FLX_NO_KEYBOARD
		if (keys != null)
		{
			for (key in keys)
			{
				if (FlxG.keys.checkStatus(key, state))
				{
					return true;
				}
			}
		}
		#end
		
		#if android
		if (androidKeys != null)
		{
			for (androidKey in androidKeys)
			{
				if (FlxG.android.checkStatus(key, state);)
				{
					return true;
				}
			}
		}
		#end
		
		#if !FLX_NO_GAMEAPD
		if (gamepadButtons != null)
		{
			var gamepadIDs = this.gamepadIDs;
			if (gamepadIDs == null)
			{
				gamepadIDs = FlxG.gamepads.getActiveGamepadIDs();
			}
			
			for (gamepadID in gamepadIDs)
			{
				var gamepad = FlxG.gamepads.getByID(gamepadID);
				
				if (gamepad != null && gamepadButtons != null)
				{
					for (gamepadButton in gamepadButtons)
					{
						if (gamepad.checkStatus(gamepadButton, state))
						{
							return true;
						}
					}
				}
			}
		}
		#end
		
		if (inputs != null)
		{
			for (input in inputs)
			{
				if (FlxInput.inputHasState(input, state))
				{
					return true;
				}
			}
		}
		
		return false;
	}
	
	private inline function get_justReleased():Bool
	{
		return checkInputs(FlxInputState.JUST_RELEASED);
	}
	
	private inline function get_released():Bool
	{
		return checkInputs(FlxInputState.RELEASED);
	}
	
	private inline function get_pressed():Bool
	{
		return checkInputs(FlxInputState.PRESSED);
	}
	
	private inline function get_justPressed():Bool
	{
		return checkInputs(FlxInputState.JUST_PRESSED);
	}
}