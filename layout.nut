//Dal1980 v1.0 Hello-Nintendo
//July 2018 V1.0

class UserConfig {
  </ label="Toons", help="Choose between a variety of toons (or turn them off)" options="off,mario-group,donkey-kong" order=1 /> optToons="mario-group";
  </ label="BG Type", help="Choose the background image" options="original,extended,none" order=1 />bg2Type="original";
  </ label="Grid Columns", help="Set the total items showing across a row (default 4 column items)" order=2 /> totalXGrid="4";
  </ label="Grid Rows", help="Set the total items showing down a column (default 3 row count)" order=3 /> totalYGrid="3";
  </ label="Grid Padding x", help="Set the x padding between grid items (default 38)" order=4 /> xPadGrid="38";
  </ label="Grid Padding y", help="Set the y padding between grid items (default 21)" order=5 /> yPadGrid="21";
  </ label="Grid Item Widths", help="Set the width of the items in the grid (default 108)" order=6 /> wItemGrid="108";
  </ label="Grid Item Heights", help="Set the height of the items in the grid (default 147)" order=7 /> hItemGrid="147";
  </ label="Grid Starting X", help="Starting x position of the overall grid (default 513)" order=7 /> xsGrid="513";
  </ label="Grid Starting Y", help="Starting y postion of the overall grid (default 141)" order=7 /> ysGrid="141";
  </ label="Grid Item Art", help="Set the art to be used for the grid items (default box)" order=10 /> gridArt="box";
}

local myConfig = fe.get_config();
fe.layout.width = 1280;
fe.layout.height = 1024;

//grid options
local totalXGrid = myConfig["totalXGrid"].tointeger(); //the total items showing across a row (column items)
local totalYGrid = myConfig["totalYGrid"].tointeger();  //the total items showing down a column (row count)
local xPadGrid = myConfig["xPadGrid"].tointeger(); //x pos grid item padding (default 38)
local yPadGrid = myConfig["yPadGrid"].tointeger(); //y pos grid item padding (default 21)
local wItemGrid = myConfig["wItemGrid"].tointeger(); //the width of the items in the grid (default 108)
local hItemGrid = myConfig["hItemGrid"].tointeger(); //the height of the items in the grid (default 147)
local xsGrid = myConfig["xsGrid"].tointeger(); //starting x position of the overall grid (default 513)
local ysGrid = myConfig["ysGrid"].tointeger(); //starting y postion of the overall grid (default 141)
local gridArt = myConfig["gridArt"]; //the chosen artwork for displaying as the grid items.
//grid initalisation
local resetDrawGrid = false; //controls when we redraw the grid
local modxGrid = 0; //adds x position modification for drawing grid
local modyGrid = 0; //adds y position modification for drawing grid
local restrictXGrid = 0; //marker for restricting the x movement on grid
local pageTurnYGrid = 0; //pagination for previous/next rows of the grid
local selectorDrawn = false; //sets the trigger for drawing the selector (init)
local textZ = 3;

//backgrounds
local bg1 = fe.add_image("parts/bg-layer1.png", 0, 0, 1280, 1024 );
if(myConfig["bg2Type"] == "original") local bg2 = fe.add_image("parts/bg-layer2.png", 0, 0, 1280, 1024 );
else if(myConfig["bg2Type"] == "extended") local bg2 = fe.add_image("parts/bg-layer2-extended.png", 0, 0, 1280, 1024 );
local snapBox = fe.add_artwork("snap", 54, 302, 380, 284);
local logoBox = fe.add_artwork("wheel", 47, 122, 400, 155);
local cartBox = fe.add_artwork("cart", 283, 695, 233, 257);
local snapTitle = fe.add_artwork("snaptitle", 53, 695, 200, 147);
local backBox = fe.add_artwork("backbox", 547, 695, 222, 307);
local frontBox = fe.add_artwork("box", 805, 695, 222, 307);

local favHolder = fe.add_image("parts/favourite-off.png", 430, 28, 60, 56);

function getFavs(index_offset) {
    if(fe.game_info( Info.Favourite, 0 ) == "1") return "parts/favourite-on.png";
    else return  "parts/favourite-off.png";
}

fe.layout.font = "EuroTT";
local labelYear = fe.add_text("[Year]", 53, 860, 200, 40);
labelYear.align = Align.Centre;
labelYear.set_rgb(254, 0, 0);

local labelPlayers = fe.add_text( "[!simpleCat]", 53, 920, 200, 30);
labelPlayers.align = Align.Centre;
labelPlayers.set_rgb(254, 0, 0);

local labelManuf = fe.add_text( "[Manufacturer]", 492, 28, 600, 30);
labelManuf.align = Align.Left;
labelManuf.set_rgb(254, 0, 0);

local labelTitle = fe.add_text( "[Title]", 496, 60, 600, 25);
labelTitle.align = Align.Left;
labelTitle.set_rgb(254, 0, 0);

local labelPlayed = fe.add_text( "Total times played: [PlayedCount]", 40, 625, 385, 20);
labelPlayed.align = Align.Left;
labelPlayed.set_rgb(63, 63, 63);

local labelListSize = fe.add_text( "[ListEntry] of [ListSize]", 54, 625, 385, 20);
labelListSize.align = Align.Right;
labelListSize.set_rgb(63, 63, 63);


//Custom game selector
local gameSelector1 = fe.add_image("parts/selector1.png", xsGrid - 6, ysGrid - 6, wItemGrid + 12, hItemGrid + 12); //thegrid selector image (appears behind box z-order)
gameSelector1.zorder = 2; //must be 2 or greater (less than 2 hides this)
local gameSelector2 = fe.add_image("parts/selector2.png", xsGrid, ysGrid + 20, wItemGrid, hItemGrid); //the grid selector image (appears infront box z-order)
gameSelector2.zorder = 100;

if(myConfig["optToons"] == "mario-group") local toons = fe.add_image("parts/mario-group.png", 1103, 616, 165, 404 );
else if(myConfig["optToons"] == "donkey-kong") local toons = fe.add_image("parts/donkey-kong.png", 994, 668, 277, 334 );

function simpleCat( ioffset ) {
  local m = fe.game_info(Info.Category, ioffset);
  local temp = split( m, " / " );
  if(temp.len() > 0) return temp[0];
  else return "";
}

function drawGrid(x, y, currentID){
    //we now need to use fe.get_art to find the full path to our art label    
    local artPath = fe.get_art( gridArt, currentID );
    local tempDraw = fe.add_image(artPath, x, y, wItemGrid, hItemGrid);
    tempDraw.zorder = textZ;
    textZ++;
    //You can manipulate the objects further here
    //eg tempDraw.rotation = -30;
}

fe.add_transition_callback( "update_my_list" );
function update_my_list( ttype, var, ttime ) {
    favHolder.file_name = getFavs(0);
    if(ttype == Transition.StartLayout){
        drawNextPage(var);
        favHolder.file_name = getFavs(0);
    }
    else if(ttype == Transition.ToNewSelection){
        favHolder.file_name = getFavs(0);
    }
    else if(ttype == Transition.EndNavigation){
        if(resetDrawGrid) drawNextPage(0);
        favHolder.file_name = getFavs(0);
    } 
    return false;
}

//This function loops through and draws our grid
function drawNextPage(currentIndex){
    if(resetDrawGrid){
        currentIndex = modyGrid + modxGrid;
        resetDrawGrid = false;
    }
    local cia = 0; //this simply adds the incremental index 0,1,2,3...10,11.
    for(local y = 0; y < totalYGrid; y++){        
        for(local x = 0; x < totalXGrid; x++){
            drawGrid( xsGrid + (x * (wItemGrid + xPadGrid)), ysGrid + (y * (hItemGrid + yPadGrid)), currentIndex + cia );
            cia++;
        }        
    }
}

fe.add_signal_handler( this, "on_signal" );
function on_signal( sig ) {
    if(sig == "up"){
        if(pageTurnYGrid <= 0){
            resetDrawGrid = true;
            pageTurnYGrid = 1;
            gameSelector1.y += (hItemGrid + yPadGrid);
            gameSelector2.y += (hItemGrid + yPadGrid);
            modyGrid = 0;
        }
        pageTurnYGrid--;
        fe.list.index = fe.list.index - totalXGrid;
        gameSelector1.y -= (hItemGrid + yPadGrid);
        gameSelector2.y -= (hItemGrid + yPadGrid);
        return true;
    }
    else if(sig == "down"){
        if(pageTurnYGrid >= (totalYGrid - 1)){
            resetDrawGrid = true;
            pageTurnYGrid = (totalYGrid - 2);
            gameSelector1.y -= (hItemGrid + yPadGrid);
            gameSelector2.y -= (hItemGrid + yPadGrid);
            modyGrid = -(totalXGrid*(totalYGrid - 1));
        }
        pageTurnYGrid++;
        fe.list.index = fe.list.index + totalXGrid;
        gameSelector1.y += (hItemGrid + yPadGrid);
        gameSelector2.y += (hItemGrid + yPadGrid);
        return true;
    }      
    else if(sig == "left"){
            if(restrictXGrid > 0){
                fe.list.index --;
                gameSelector1.x -= (wItemGrid + xPadGrid);
                gameSelector2.x -= (wItemGrid + xPadGrid);
                restrictXGrid--;
                modxGrid++;
            }
            return true;
    }
    else if(sig == "right"){
        if(restrictXGrid < (totalXGrid-1)){
            fe.list.index ++;
            gameSelector1.x += (wItemGrid + xPadGrid);
            gameSelector2.x += (wItemGrid + xPadGrid);
            restrictXGrid++;
            modxGrid--;
        }
        return true;
    }
    else if(sig == "next_letter" || sig == "prev_letter" || 
            sig == "prev_favourite" || sig == "next_favourite" || 
            sig == "prev_page" || sig == "next_page"){
        gameSelector1.x = xsGrid - 6;
        gameSelector1.y = ysGrid - 6;
        gameSelector2.x = xsGrid;        
        gameSelector2.y = ysGrid + 20;
        resetDrawGrid = true;
        restrictXGrid = 0;
        pageTurnYGrid = 0;
        modxGrid = 0;
        modyGrid = 0;
    }
    else return false;
}
