
addHaxeLibrary('FlxMath','flixel.math');

var startY = 300;

var shader;
var bg1;
var fg;
var rock;

var ourEmitter:FlxEmitter;
var initialTime = 0;

var snapLock = false;

var swayTime = 0;
var prevMustHit = true;

var invDanceTmr;

//might create logic for mutliple rocks

function onLoad() {
    bg1 = new FlxSprite().loadGraphic(Paths.image('BRR_Background'));
    add(bg1);
    bg1.scrollFactor.set(0.7,1.0);

    fg = new FlxSprite().loadGraphic(Paths.image('BRR_Foreground'));
    foreground.add(fg);
    fg.scrollFactor.set(1.3,1.0);

    rock = new FlxSprite().loadFrames('rock');
    rock.animation.addByPrefix('throw','throw',16,false);
    rock.animation.addByPrefix('hit','hit',16,false);
    foreground.add(rock);
    rock.visible = false;
    rock.animation.finishCallback = (s)->{
        if (s == 'throw') {
            rock.animation.play('hit');
            snapToChar(dad);
            rock.setPosition(dad.x,dad.y);
            boyfriend.animTimer = 0;
        }
        if (s == 'hit') {
            rock.visible = false;
            snapLock = false;
            dad.animTimer = 0;
        }
    }
    rock.animation.callback = (n,num,idx)->{
        if (n == 'hit' && num == 2) {
            game.dad.playAnim('ow',true);
            dad.animTimer = 100;
            dad.voicelining = true;
            FlxG.sound.play(Paths.sound('rockSmack'));
            new FlxTimer().start(0.7,Void->{
                dad.voicelining = false;
                if (mustHitSection)
                    snapToChar(boyfriend);
            });
        }
    }


}


function onCreatePost() {

    game.isCameraOnForcedPos = true;


    for (i in [game.healthBar,game.healthBarBG,game.iconP1,game.iconP2,game.timeBar,game.timeBarBG,game.timeTxt]) {
        i.visible = false;
    }

    modManager.setValue('alpha',1,1);

    shader = newShader('color');
    shader.data.saturation.value = [0,0];
    shader.data.excludedColor.value = [169/255,96/255,73/255]; //our slugs tongue
    boyfriend.shader = shader;
    fg.shader = shader;
    bg1.shader = shader;



    boyfriend.animation.callback = (n,num,idx) ->{
        if (n == 'throw' && num == 1) {rock.animation.play('throw'); rock.visible=true;}
    }

    dad.visible = false;
    dad.animation.callback = (n,num,idx) ->{
        if (n == 'run' && num == 1) {dad.visible=true;}
    }

    dad.animation.finishCallback = (s)->{
        if (s == 'run') {
            dad.stunned = false;
            dad.animTimer = 0;
            dad.dance();
        }
        if (s == 'ow') {
            // dad.voicelining = false;
        }
    }

    snapToChar(boyfriend);
    // game.camFollowPos.y -= startY;
    // game.camFollow.y -= startY;
    // FlxG.camera._fxFadeAlpha = 1;
    // FlxG.camera._fxFadeColor = FlxColor.BLACK;

    createSnow();
}


function onEvent(name,v1,v2) 
{
    switch(name) {
        case 'Alt Idle Animation':
            if (v2 == '-alt') {
                boyfriend.dance();
            }
        case '':
            if (v1 == 'burp') {
                dad.playAnim('burp', true);
                dad.specialAnim = true;
                dad.heyTimer = 4;
                FlxG.camera.shake(0.001,0.7);
            }

            if (v1 == 'forcedChange') {
                if (v2 == '0') snapToChar(boyfriend);
                else snapToChar(dad);
            }
            if (v1 == 'weeAnim') {
                dad.stunned = true;
                dad.playAnim('weewoo',true);
                // doWeewoo();
            }
            if (v1 == 'run'){
                dad.playAnim('run',true);
                dad.stunned = true;
                dad.animTimer =1000;
            }

    }

}

function onSongStart() {

    // FlxTween.tween(FlxG.camera, {_fxFadeAlpha: 0},2, {startDelay:1,ease: FlxEase.quadInOut});
    // FlxTween.tween(game.camFollowPos, {y: game.camFollowPos.y + startY},2, {startDelay:1,ease: FlxEase.quadInOut});
    // FlxTween.tween(game.camFollow, {y: game.camFollow.y + startY},2, {startDelay: 1,ease: FlxEase.quadInOut});
}
function onBeatHit() {


}

function onSectionHit() 
{
    if (FlxG.random.bool(10) && mustHitSection && curSection > 12) {
        doWeewoo(); //move to section
        return;
    }

   // trace('curHIT' + mustHitSection + ' preVHIT ' + prevMustHit);
    if (!snapLock && (prevMustHit != mustHitSection)) {
        snapToChar(mustHitSection ? boyfriend : dad);
    }

    prevMustHit = mustHitSection;

}


function onUpdatePost(elapsed) {

    var currentTime = Conductor.songPosition - Conductor.offset;
    if (currentTime > 0 && initialTime != -1) {
        var mappedColor = FlxMath.remapToRange(currentTime,initialTime,FlxG.sound.music.length,0,-1);
        shader.data.saturation.value = [mappedColor,mappedColor];

        var mappedFrq = FlxMath.remapToRange(currentTime,initialTime,FlxG.sound.music.length,0.1,0.005);
        ourEmitter.frequency = mappedFrq;
    } 


    if (FlxG.keys.justPressed.Q && !snapLock && curSection > 12) {
        doHit();
    }

    swayTime += elapsed;
    game.camFollowPos.x += Math.cos(swayTime * 2) * 0.1;
    game.camFollowPos.y += Math.sin(swayTime * 2) * 0.1;

}

function doWeewoo() {
    dad.stunned = true;
    dad.playAnim('weewoo',true);
    snapToChar(dad);

    if (invDanceTmr != null) invDanceTmr.cancel();
    invDanceTmr = new FlxTimer().start(0.5,Void->{
        if (mustHitSection) {
            snapToChar(boyfriend);
        }
        else {
            prevMustHit = mustHitSection; //amke this happen on a uneven section
        }

        dad.stunned=false;
    });
}

function snapCam(x,y) {
    game.camFollow.x = x;
    game.camFollow.y = y;
    game.camFollowPos.setPosition(x,y);
}


function snapToChar(char) {
    var pos = getPos(char);
    snapCam(pos.x,pos.y);
}

function doHit() {
    rock.setPosition(boyfriend.x,boyfriend.y);

    if (!mustHitSection)
        snapToChar(boyfriend);

    boyfriend.playAnim('throw',true);
    boyfriend.animTimer = 100;
    snapLock = true;
    
}

function createSnow() {

    ourEmitter = new FlxEmitter();
    ourEmitter.width = bg1.width;
    ourEmitter.y = -100;
    add(ourEmitter);
    ourEmitter.emitting = true;
    ourEmitter.launchMode = FlxEmitterMode.SQUARE;
    ourEmitter.makeParticles(4, 8, FlxColor.WHITE, 200);
    ourEmitter.velocity.set(0, 0,500,900,0,800);
    ourEmitter.lifespan.set(3,8);
    ourEmitter.start(false, 0, 0);
    ourEmitter.frequency = 10000;
    
}

function getPos(char) {
    if (char == null) return bg.getMidpoint();

    var desiredPos = char.getMidpoint();
    if (char.isPlayer) {
		desiredPos.x -= 100 + (boyfriend.cameraPosition[0] - game.boyfriendCameraOffset[0]);
		desiredPos.y += -100 + boyfriend.cameraPosition[1] + game.boyfriendCameraOffset[1];
    }
    else {
        desiredPos.x += 150 + dad.cameraPosition[0] + game.opponentCameraOffset[0];
        desiredPos.y += -100 + dad.cameraPosition[1] + game.opponentCameraOffset[1];
    }

    return desiredPos;
}