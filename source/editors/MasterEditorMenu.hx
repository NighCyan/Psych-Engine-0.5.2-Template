package editors;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.system.FlxSound;

using StringTools;

class MasterEditorMenu extends MusicBeatState
{
	var options:Array<String> = [
		'看什么呢宝，我移除了呢',
		'What are you looking at, dear? I Removed them.'
	];
	private var grpTexts:FlxTypedGroup<Alphabet>;
	private var directories:Array<String> = [null];

	private var curSelected = 0;
	private var curDirectory = 0;
	private var directoryTxt:FlxText;

	override function create()
	{
		FlxG.camera.bgColor = FlxColor.BLACK;
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.set();
		bg.color = 0xFF353535;
		add(bg);


		for (i in 0...options.length)
		{
			var leText:FlxText = new FlxText(0, (70 * i) + 30, options[i], true, false);
			leText.isMenuItem = true;
			leText.targetY = i;
			leText.setFormat(Paths.font("中文.ttf"), 32);
			add(leText);
		}
		

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 42).makeGraphic(FlxG.width, 42, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);
		
		FlxG.mouse.visible = false;

                #if android
                addVirtualPad(FULL, B);
                #end

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			MusicBeatState.switchState(new MainMenuState());
		
			FlxG.sound.music.volume = 0;
			#if PRELOAD_ALL
			FreeplayState.destroyFreeplayVocals();
			#end
			var bullShit:Int = 0;
		super.update(elapsed);
		}
		
		
	}
	}