local underTale = false
local canAttack = true
local attack = 0
local winX = 0
local winY = 0

function underTalint() -- disabler
	underTale = false
	setTextFont('scoreTxt', 'vcr.ttf')
	setTextFont('judjTxt', 'vcr.ttf')
	setTextFont('timeTxt', 'vcr.ttf')
	setTextFont('botplayTxt', 'vcr.ttf')

	setHealthBarColors('D38900','5180EA')
	setProperty('healthBar.angle', 0)
	setProperty('healthBar.scale.x', 1)
	setProperty('healthBar.scale.y', 1)
	setProperty('HB.alpha', 1)
	setProperty('iconP1.visible', true)
	setProperty('iconP2.visible', true)
	setProperty('scoreTxt.y', getProperty('scoreTxt.y') + 70)

	if getPropertyFromClass('ClientPrefs','mechanicsOn') then
    removeLuaSprite('attackThing',false)
    removeLuaText("attackIndicator");
	end

	removeLuaText("ks");
	removeLuaText("hp");
	removeLuaText("hpTxt");
end

function underTaling() -- enabler
	underTale = true
	setTextFont('scoreTxt', 'Determination.ttf')
	setTextFont('judjTxt', 'Determination.ttf')
	setTextFont('timeTxt', 'Determination.ttf')
	setTextFont('botplayTxt', 'Determination.ttf')

	setHealthBarColors('FF0000','FFFF00')
	setProperty('healthBar.angle', 180)
	setProperty('healthBar.scale.x', 0.7)
	setProperty('healthBar.scale.y', 1.2)
	setProperty('HB.alpha', 0)
	setProperty('iconP1.visible', false)
	setProperty('iconP2.visible', false)
	setProperty('scoreTxt.y', getProperty('scoreTxt.y') - 70)

	if getPropertyFromClass('ClientPrefs','mechanicsOn') then
    makeAnimatedLuaSprite('attackThing','fight_button',0,(downscroll and 40 or 600))
    scaleObject('attackThing',0.6,0.6)
    addAnimationByPrefix('attackThing','normal','fight unable',0,true)
    addAnimationByPrefix('attackThing','attack','fight able',24,false)
    setObjectCamera('attackThing','hud')
    setProperty('attackThing.offset.x',0)
    setProperty('attackThing.offset.y',0)
    addLuaSprite('attackThing',false)

    makeLuaText('attackIndicator', 'kys', 100, 230, (downscroll and 60 or 620))
    setObjectCamera("attackIndicator", 'hud');
    setTextColor('attackIndicator', 'FFFFFF')
    setTextSize('attackIndicator', 55);
    addLuaText("attackIndicator");
    setTextFont('attackIndicator', "Determination.ttf")
    setTextAlignment('attackIndicator', 'left')
	end

	makeLuaText('hp', 'HP', 200, 380, getProperty('healthBar.y') - 10)
	setObjectCamera("hp", 'hud');
	setTextColor('hp', 'FFFFFF')
	setTextSize('hp', 30);
	addLuaText("hp");
	setTextFont('hp', "DRhud.ttf")
	setTextAlignment('hp', 'left')

	makeLuaText('ks', 'KS', 200, 720, getProperty('healthBar.y') - 10)
	setObjectCamera("ks", 'hud');
	setTextColor('ks', 'FFFFFF')
	setTextSize('ks', 30);
	addLuaText("ks");
	setTextFont('ks', "DRhud.ttf")
	setTextAlignment('ks', 'right')

	makeLuaText('hpTxt', 'hpTxt', 270, 930, getProperty('healthBar.y'))
	setObjectCamera("hpTxt", 'hud');
	setTextColor('hpTxt', 'FFFFFF')
	setTextSize('hpTxt', 60);
	addLuaText("hpTxt");
	setTextFont('hpTxt', "UThud.ttf")
	setTextAlignment('hpTxt', 'left')
end

function onCreatePost() 
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'Blue Bone Note' and not getPropertyFromClass('ClientPrefs','mechanicsOn') then
			removeFromGroup('unspawnNotes', i, true)
		end
	end
end

function onStepHit()
if underTale then
	if getProperty('dad.curCharacter') == 'MEME BOI-sans' and getPropertyFromClass('ClientPrefs','mechanicsOn') then
		setProperty('health', getProperty('health') - 0.03)
	end
end

    if curStep == 1232 then
    underTaling()
    end
    if curStep == 1360 then
    underTalint()
    end
end

function onUpdate()
if underTale then
    if getPropertyFromClass('ClientPrefs','mechanicsOn') then
	if keyJustPressed('space') and getProperty('dad.curCharacter') == 'MEME BOI-sans' and canAttack and attack == 0 and getProperty('cpuControlled') == false then
	setProperty('health', getProperty('health') + 0.5)
	doTweenX('boyAttack', 'dad', 670, 0.3, 'QuadIn')
	runTimer('boyBack', 0.5)
	canAttack = false
	objectPlayAnimation('attackThing', 'normal', false)
	attack = 5

	makeLuaSprite('misslol', 'IF/missThing', 1000, 0)
    addLuaSprite('misslol', true)
	scaleObject('misslol', 0.9, 0.9)
	setProperty('misslol.acceleration.y',550, 0.6)
	setProperty('misslol.velocity.y',-(getRandomInt(140, 175)))
	setProperty('misslol.velocity.x',-(getRandomInt(0, 10)))
	runTimer('killthemiss',0.4)
	end
	if getProperty('cpuControlled') == true and getProperty('dad.curCharacter') == 'MEME BOI-sans' and canAttack and attack == 0 then
		setProperty('health', getProperty('health') + 0.5)
		doTweenX('boyAttack', 'dad', 670, 0.3, 'QuadIn')
		runTimer('boyBack', 0.5)
		canAttack = false
		objectPlayAnimation('attackThing', 'normal', false)
		attack = 5

		makeLuaSprite('misslol', 'IF/missThing', 1000, 0)
		addLuaSprite('misslol', true)
		setProperty('misslol.acceleration.y',550, 0.6)
		setProperty('misslol.velocity.y',-(getRandomInt(140, 175)))
		setProperty('misslol.velocity.x',-(getRandomInt(0, 10)))
		playSound('attack');
		runTimer('killthemiss',0.4)
	end

	if getProperty('dad.curCharacter') == 'MEME BOI-sans' then
	setProperty('attackIndicator.alpha', 1)
	setProperty('attackThing.alpha', 1)
	else
	setProperty('attackIndicator.alpha', 0)
	setProperty('attackThing.alpha', 0)
	end

	setTextString('attackIndicator', (attack == 0 and '' or attack))
    end
    setTextString('hpTxt', math.floor(getProperty("health") * 45)..'/90')
end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'boyBack' and getProperty('dad.curCharacter') == 'MEME BOI-sans' then
	doTweenX('boyAttack', 'dad', 1000, 0.3, 'QuadOut')
	end
	if tag == 'killthemiss' then
		doTweenAlpha('AlphaTween1', 'misslol', 0, 0.25)
		runTimer('byebye', 0.3)
	end
	if tag == 'byebye' then
		removeLuaSprite('misslol', true)
	end
end

function onBeatHit()
if underTale then
    if getPropertyFromClass('ClientPrefs','mechanicsOn') then
	if attack ~= 0 then
	attack = attack - 1
	objectPlayAnimation('attackThing', 'normal', true)
	end
	if attack == 0 then
	objectPlayAnimation('attackThing', 'attack', true)
	canAttack = true
	end
    end
end
end