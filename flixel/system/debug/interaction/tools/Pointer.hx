package flixel.system.debug.interaction.tools;

import flash.display.BitmapData;
import flash.ui.Keyboard;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.system.debug.interaction.Interaction;

@:bitmap("assets/images/debugger/cursorCross.png") 
class GraphicCursorCross extends BitmapData {}

/**
 * A tool to use the mouse cursor to select game elements.
 * 
 * @author Fernando Bevilacqua (dovyski@gmail.com)
 */
class Pointer extends Tool
{		
	override public function init(Brain:Interaction):Tool 
	{
		super.init(Brain);
		
		setName("Pointer");
		setButton(GraphicCursorCross);
		setCursor(new GraphicCursorCross(0, 0));
		
		return this;
	}
	
	override public function update():Void 
	{
		var item :FlxBasic;
		var brain :Interaction = getBrain();
		
		super.update();
		
		// If the tool is active, update the custom cursor cursor
		if (!isActive())
		{
			return;
		}
		
		// Check clicks on the screen
		if (brain.pointerJustPressed || brain.pointerJustReleased)
		{
			item = pinpointItemInGroup(FlxG.state.members, brain.flixelPointer);
			
			if (item != null)
			{
				handleItemClick(item);
			}
			else if (brain.pointerJustPressed)
			{
				// User clicked an empty space, so it's time to unselect everything.
				brain.clearSelection();
			}
		}
	}
	
	private function handleItemClick(Item:FlxBasic):Void
	{			
		var brain:Interaction = getBrain();
		var selectedItems:FlxGroup = brain.getSelectedItems();
		
		// Is it the first thing selected or are we adding things using Ctrl?
		if (selectedItems.length == 0 || brain.keyPressed(Keyboard.CONTROL))
		{
			// Yeah, that's the case. Just add the new thing to the selection.
			selectedItems.add(Item);
		}
		else
		{
			// There is something already selected
			if (selectedItems.members.indexOf(Item) == -1)
			{
				brain.clearSelection();
			}
			selectedItems.add(Item);
		}
	}
	
	private function pinpointItemInGroup(Members:Array<FlxBasic>, Cursor:FlxPoint):FlxBasic
	{
		var i:Int = 0;
		var l:Int = Members.length;
		var b:FlxBasic;
		var target:FlxBasic = null;
		
		while (i < l)
		{
			b = Members[i++];

			if (b != null)
			{
				// Ignore invisible or non-existent entities
				if (!b.visible || !b.exists)
				{
					continue;
				}
				
				if (Std.is(b, FlxGroup))
				{
					target = pinpointItemInGroup((cast b).members, Cursor);
				}
				else if (Std.is(b, FlxSprite) && (cast(b, FlxSprite).overlapsPoint(Cursor, true)))
				{
					target = b;
				}
				if (target != null)
				{
					break;
				}
			}
		}
		
		return target;
	}
}
