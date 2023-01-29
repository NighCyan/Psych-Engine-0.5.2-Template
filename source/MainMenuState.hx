package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import haxe.Json;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import ClientPrefs;

using StringTools;
typedef LogoData =
{
	
	logox:Float,
	logoy:Float,
	scaleX:Float,
	scaleY:Float,
	storyX:Float,
	storyY:Float,
	FreeX:Float,
	FreeY:Float,
	CreditsX:Float,
	CreditsY:Float,
	optionX:Float,
	optionY:Float
}
class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = 'cnm'; 
	public static var curSelected:Int = 0;


	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	public static var firstStart:Bool = true;
	public static var finishedFunnyMove:Bool = false;

	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'credits',
		'options'
	];


	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var bg:FlxBackdrop;
var logoJSON:LogoData = Json.parse(Paths.getTextFromFile('images/mainEditor.json'));
		var logo:FlxSprite = new FlxSprite(logoJSON.logox, logoJSON.logoy);
		logo.frames = Paths.getSparrowAtlas('logoBumpin-GOP');
	var vignette:FlxSprite;
	var glowyThing:FlxSprite;

	override function create()
	{
		super.create();

		

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}
		

		FlxG.mouse.visible = #if mobile false #else true #end;



	
		

		

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();
			// brian was here

			// hi
			var choicesJSON:LogoData = Json.parse(Paths.getTextFromFile('images/mainEditor.json'));
			switch (i)
			{
				case 0:
					menuItem.setPosition(choicesJSON.storyX, choicesJSON.storyY);
				case 1:
					te.setPosition(choicesJSON.FreeX, choicesJSON.FreeY);
				case 2:
					menuItem.setPosition(choicesJSON.CreditsX, choicesJSON.CreditsY);
				case 3:
					menuItem.setPosition(choicesJSON.optionX, choicesJSON.optionY);
	//6
			}
		add(menuItem);
		}

		add(menuItems);
        
		logo.animation.addByPrefix('bump', 'logo bumpin', 24, false);
		//logo.screenCenter();
		logo.updateHitbox();
		logo.antialiasing = !ClientPrefs.lowQuality;
		logo.scale.set(logoJSON.scaleX, logoJSON.scaleY);
		add(logo);

	

		FlxG.camera.follow(camFollowPos, null, 1);

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "GOP VS Impostor V1" ,12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		/*#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (!Achievements.achievementsUnlocked[achievementID][1] && leDate.getDay() == 5 && leDate.getHours() >= 18)
		{ // It's a friday night. WEEEEEEEEEEEEEEEEEE
			Achievements.achievementsUnlocked[achievementID][1] = true;
			giveAchievement();
			ClientPrefs.saveSettings();
		}
		#end*/
	}

/*	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	var achievementID:Int = 0;

	function giveAchievement()
	{
		add(new AchievementObject(achievementID, camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement ' + achievementID);
	}
	#end*/

	var selectedSomethin:Bool = false;

	var canClick:Bool = true;
	var usingMouse:Bool = false;

	var timerThing:Float = 0;

	override function update(elapsed:Float)
	{
	if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		timerThing += elapsed;
		glowyThing.alpha = Math.sin(timerThing) + 0.4;

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (usingMouse)
			{
				if (!FlxG.mouse.overlaps(spr))//我猜测overlaps应该是鼠标停留在某个元件上。!表明否定
					spr.animation.play('idle');
			}

			if (FlxG.mouse.overlaps(spr))
			{
				if (canClick)
				{
					//do nothing
				}
			}
	/*#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}*/
	for (touch in FlxG.touches.list)
	{
	if (touch.justPressed && canClick)
				{
					switch (optionShit[curSelected])
					{
						default:
							selectSomething();
					}
				}
}
			spr.updateHitbox();
		});

		if (!selectedSomethin)
		{
			if (FlxG.android.justReleased.BACK)
			{
				FlxG.switchState(new TitleState());
			}
		}

		super.update(elapsed);
	}

	function selectSomething()
	{
	
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));

		canClick = false;

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected != spr.ID)
			{
			
				FlxTween.tween(logo, {y: logo.y + 800}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.24});
				FlxTween.tween(spr, {alpha: 0}, 1.3, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});
			}
			else
			{
				FlxTween.tween(logo, {y: logo.y + 800}, 0.7, {ease: FlxEase.quadInOut, startDelay: 0.24});
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					goToState();
				});
			}
		});
	}

	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'Story Mode':
				MusicBeatState.switchState(new StoryMenuState());
			case 'Freeplay':
				MusicBeatState.switchState(new FreeplayState());
			case 'Options':
				LoadingState.loadAndSwitchState(new options.OptionsState());
			case 'Credits':
				MusicBeatState.switchState(new CreditsState());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('white');
			}

			spr.updateHitbox();
		});
	}
}