var mainVid:FunkinVideoSprite;
var missVid:FunkinVideoSprite;

function onLoad() 
{
    missVid = new FunkinVideoSprite();
    missVid.addCallback('onFormat',()->{
        missVid.setGraphicSize(0,FlxG.height);
        missVid.updateHitbox();
        missVid.screenCenter();
        missVid.cameras = [game.camHUD];
    });
    missVid.load('CarVideoMissing.mp4',[FunkinVideoSprite.muted]);
    add(missVid);

    mainVid = new FunkinVideoSprite();
    mainVid.addCallback('onFormat',()->{
        mainVid.setGraphicSize(0,FlxG.height);
        mainVid.updateHitbox();
        mainVid.screenCenter();
        mainVid.cameras = [game.camHUD];
    });
    mainVid.load('CarVideo.mp4',[FunkinVideoSprite.muted]);
    add(mainVid);
}

function onCreatePost() {
    game.dad.visible = game.boyfriend.visible = game.gf.visible = false;
    
    modManager.setValue('alpha',1,1);
    modManager.setValue('opponentSwap',0.5);
    game.healthBar.alpha = 0;
    game.iconP1.alpha = 0; game.iconP2.alpha = 0;

    for (i in [game.dad,game.boyfriend]) i.alpha = 0;

    game.canReset = false;

}

function onSongStart() {
    mainVid.play();
    missVid.play();
}

var missTime:Float = 0;
var tmr:Float = 0;

function missed() {
    mainVid.alpha =0;
    tmr = 0;
}
function noteMiss(d) {
    missed();
}

function noteMissPress(d) {
    missed();
}

function goodNoteHit() 
{
    mainVid.alpha = 1;
    tmr = 0;
}

function update(elapsed) 
{
    game.health = 2;
    if (mainVid.alpha == 0){
        tmr+=elapsed;
        if (tmr >= 1) {
            mainVid.alpha = 1;
        }
    }
}
