package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;

class CustomFadeTransition extends MusicBeatSubstate
{
	public static var finishCallback:Void->Void;

	private var leTween:FlxTween = null;

	public static var nextCamera:FlxCamera;

	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;

	var transitionSprite:FlxSprite;

	public function new(duration:Float, isTransIn:Bool)
	{
		super();

		this.isTransIn = isTransIn;

		var width:Int = Std.int(FlxG.width);
		var height:Int = Std.int(FlxG.height);

		transitionSprite = new FlxSprite(width + -1280, height + -1010);
		transitionSprite.frames = Paths.getSparrowAtlas('kevin_normal', 'preload');
		transitionSprite.animation.addByPrefix('transition', 'kevin_normal', 34, false);
		transitionSprite.scale.set(2, 2);
		transitionSprite.scrollFactor.set(0, 0);
		add(transitionSprite);

		if (isTransIn)
		{
			transitionSprite.animation.play('transition', true, true, 28);
			transitionSprite.animation.callback = function(anim, framenumber, frameindex)
			{
				if (framenumber == 0)
					close();
			}
		}
		else
		{
			transitionSprite.animation.play('transition', true);
			transitionSprite.animation.callback = function(anim, framenumber, frameindex)
			{
				if (finishCallback != null && framenumber == 28)
				{
					finishCallback();
				}
			}
		}

		if (nextCamera != null)
		{
			transitionSprite.cameras = [nextCamera];
		}
		nextCamera = null;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function destroy()
	{
		if (leTween != null)
		{
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}
