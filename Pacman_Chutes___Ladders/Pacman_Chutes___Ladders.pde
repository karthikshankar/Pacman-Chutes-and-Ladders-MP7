/**
  * PacmanChutesAndLadders
  * @author Karthik Shankar, Kavi Ravuri
  * @version December 11, 2017
*/

int w = 32;          //This is the width variable that holds the overall width of the game board
int h = 23;          //This is the height variable that holds the overall height of the game board
int wext = 5;         //Width extension of the side bars on each size
int size = 30;        //Holds the size of each box in the game board
int pyoff = 15;                      //This was used to offset pacman's x position from the board
int mxoff = (wext*size);             //Offset's pacman's website
int pxoff = (wext*size)+14;            //offset x position for pacman so make sure he starts after the left sidebox
int pacmanxpos = 0;                //Starting x position for pacman
int pacmanypos = h-1;              //Starting y position for pacman
int px1, px2, py1, py2;            // temporary pacman positions to hold his position when he's climbing
int pacmandirection = 0;             //Variable that holds the direction of pacman to make sure that he wraps around the board
boolean monsterwon = false;       //Variable to see if the monster has won the game
boolean pacmanwon = false;           //Variable to see if pacman has won the game
int start=0;                    //Holds starting value for timer
int timer=0;                    //Timer variable to display users' time
int mil = 0;                      //Milliseconds for time value
int seconds = 0;                  //Seconds for time value
int minutes = 0;                    //Minutes for time display
int stime=0;                          // starting time for timer
int etime=0;                          // ending time for timer
int difftimer = 3000;                  // timeout time for pacman climbing and sliding
int gameendtimer = 6000;              // timer at end of game
boolean buttontimeout=false;        // timeout to stop player from playing the game once he has finished, so that he waits for the exit or restart prompts to be displayed
boolean pacmanclimbing=false;        // variable to see when pacman is climbing up a ladder
boolean pacmansliding=false;         // variable to see when pacman is sliding down a chute
int [][]  ladarr = new int[10][9];        //Array of ladders to store all ladder positions
int [][]  chutearr = new int[10][9];     //Array of chutes to store all chute positions
PImage blinky;        //Image for blinky monster
PImage clyde;            //Image for clyde monster
PImage dinky;           //Image for dinky monster
int [][] monsterpos = new int[3][4];      //Monster array for all monster positionss
int previousoldmonpos = 0;      //Variable to used make sure that the monsters don't start in the same position every time
int monstermovcount = 0;     //Keeps track of the row number and which way the monsters move on the gameboard
int xb, yb, wb, hb;           //Positions of the "play" button displayed
PFont playFont;           //Font used throughout gameplay
int decideMenu = 0;        //Variable help user navigate through start and intstruction panels
int rollcount = 0;         //roll count for each of pacman's rolls
int monrollcount = 0;         //roll count for each of the monster's roll counts

/**
  * Method where I reset all variables to the same as they were at the beginning of the game.
 */
void resetboard()
{
   pacmanxpos =  0;                            //Starting x position for pacman
   pacmanypos = h-1;                           //Starting y positionforpacman
   pacmandirection = 0;
   monsterwon = false;
   pacmanwon = false;                     //Reset all variables to false or to 0
   buttontimeout = false;
   previousoldmonpos = 0;
   monrollcount = 0;
   rollcount = 0;

  for(int i = 0; i < monsterpos.length; i++)
  {
    int randommonstervar = (int)(random(2,(w-7)));            //Generate a random starting position for the monster
    if(previousoldmonpos != randommonstervar)     //Check to make sure previous position doesn't equal the last one
    {
       monsterpos[i][0] = randommonstervar;
    }
    else
    {
      randommonstervar = (int)(random(2,(w-7)));
      monsterpos[i][0] = randommonstervar;
    }
    monsterpos[i][1] = h-1;          //Make sure that each monster starts out on the bottom of the board
    monsterpos[i][2] = 0;  // toggle to indicate direction of monster movement
    monsterpos[i][3] = 0;  // toggle to indicate whether monster is alive
    previousoldmonpos = randommonstervar;                 //set the old previous position to the next one to check the next time
  }

}

/**
 * Method where I set up the x and y positions for all ladders. I am randomly generating
 * this position each time and its time.
 */
void setupLadders()
{
  int x = 2;             //Variable used to change x position of ladders and chutes
  int y = 2;             //Variable used to change y position of ladders and chutes
  int xdiff = 3;         //Variable to make sure that all x positions of chutes and ladders will be spaced out around grid
  int ydiff = 1;         //Variable to make sure that all y positions of chutes and ladders are spaced around the height of grid
  int r, s, r1;

  for (int i = 0; i < ladarr.length; i++)        //for loop used to generate random ladder array positions
  {
    //Random positions throughout the board for the ladders
    r = (int)(random(1, 10));
    s = (int)(random(1, 10));
    int moveLadPos = (int)(random(1,6));      //Make sure that each ladder has a different size and orientation

    if ((i%2) > 0)
      r1 = -r;
    else
      r1 = r;

    ladarr[i][0] = x;
    ladarr[i][1] = y;                           //Set the all ladder positions and add random variables to make sure
    ladarr[i][2] = ladarr[i][0] + r1;             //ladders are different in size and orientation
    ladarr[i][3] = ladarr[i][1] + r + s;
    ladarr[i][4] = ladarr[i][0] + 1;
    ladarr[i][5] = ladarr[i][1];
    ladarr[i][6] = ladarr[i][2] + 1;
    ladarr[i][7] = ladarr[i][3];
    ladarr[i][8] = 0;

    //check to make sure that the positions go above or below the limits
    if(ladarr[i][0] > w-1)
      ladarr[i][0] = w-1;
    if(ladarr[i][0] < 0)
      ladarr[i][0] = 1;
    if(ladarr[i][1] > h-1)            //Check each and every ladder position to make sure it doesn't go off the board
      ladarr[i][1] = h-1;
    if(ladarr[i][2] > w-1)
      ladarr[i][2] = w-1;
    if(ladarr[i][2] < 0)
    {
      ladarr[i][2] = 1;
      ladarr[i][6] = 2;
    }
    if(ladarr[i][3] > h-1)         //Check positions against the height
      ladarr[i][3] = h-1;
    if(ladarr[i][4] > w)
    {
      ladarr[i][0] = w-moveLadPos;               //Reset the position back to the right positions of the board
      ladarr[i][4] = w-(moveLadPos-1);
    }
    if(ladarr[i][4] < 0)            //Check to see if ladder positions go below 0
      ladarr[i][4] = 1;
    if(ladarr[i][5] > h-1)
      ladarr[i][5] = h-1;
    if(ladarr[i][6] > w)
    {
      ladarr[i][2] = w-moveLadPos;
      ladarr[i][6] = w-(moveLadPos-1);
    }
    if(ladarr[i][6] < 0)
    {
      ladarr[i][2] = 1;
      ladarr[i][6] = 2;
    }
    if(ladarr[i][7] > h-1)
      ladarr[i][7] = h-1;

    x += xdiff;          //Increment x so that the ladder positions move across the grids
    y += ydiff;
  }
}

/**
  * This is the method where I randomly set up the starting x and y positions for all the chutes.
  */
void setupChutes()
{
  int x, y;
  int xdiff=3;
  int r, s, change;

  x = 4;
  for (int i = 0; i < chutearr.length; i++)
  {
    r = (int)(random(1, 7));
    s = (int)(random(1, 3));
    y = (int)(random(2, 20));
    change = (int)(random(2, 5));

    //generate random positions
    chutearr[i][0] = x;
    chutearr[i][1] = y;
    for(int j = 0; j < ladarr.length; j++)
    {
       while(chutearr[i][0] == ladarr[j][2] && chutearr[i][1] == ladarr[j][3])
       {
         y = (int)(random(2, 20));
         chutearr[i][1] = y;
       }
    }
    chutearr[i][6] = chutearr[i][0] - r;            //Generate all random chute positions with different size and orientation
    chutearr[i][7] = chutearr[i][1] + r + s;
    if (chutearr[i][6] < 0)
      chutearr[i][6] = 0;
    if (chutearr[i][7] > h-1)
      chutearr[i][7] = h-1;
    chutearr[i][2] = chutearr[i][0] - change;
    chutearr[i][3] = chutearr[i][1];
    chutearr[i][4] = chutearr[i][6] + change;
    chutearr[i][5] = chutearr[i][7];
    chutearr[i][8] = 0;

    if(chutearr[i][0] > w)
      chutearr[i][0] = w-2;
    if(chutearr[i][0] < 0)
      chutearr[i][0] = 1;
    if(chutearr[i][1] > h)                //Check ladders against the height and width for each dimension of the ladder
      chutearr[i][1] = h-2;
    if(chutearr[i][6] > w)
      chutearr[i][6] = w-2;
    if(chutearr[i][6] < 0)
      chutearr[i][6] = 1;
    if(chutearr[i][7] > h)
      chutearr[i][7] = h-2;
     if(chutearr[i][2] > w)
      chutearr[i][2] = w-2;
    if(chutearr[i][2] < 0)
      chutearr[i][2] = 1;
    if(chutearr[i][3] > h)
      chutearr[i][3] = h-2;
    if(chutearr[i][4] > w)
      chutearr[i][4] = w-2;
    if(chutearr[i][4] < 0)
      chutearr[i][4] = 1;
    if(chutearr[i][5] > h)
      chutearr[i][5] = h-2;

    x += xdiff;
  }
}

/**
  * This method is used at the start of my game. This is the method where I set up the
  * images for my monsters and screenshots in the instructions panel.
  */
void setup()
{
  size(1260, 707);    //Create board
  start = millis();
  blinky = loadImage("blinky.png");         //Load all monster images
  clyde = loadImage("clyde.png");
  dinky = loadImage("dinky.png");

  playFont = createFont("ACaslonPro-Bold", 34);

  setupLadders();
  setupChutes();

  for(int i = 0; i < monsterpos.length; i++)
  {
    int randommonstervar = (int)(random(2,(w-7)));
    if(previousoldmonpos != randommonstervar)     //Check to make sure previous position doesn't equal the last one
       monsterpos[i][0] = randommonstervar;          //Get random position for monsters
    else
    {
      randommonstervar = (int)(random(2,(w-7)));
      monsterpos[i][0] = randommonstervar;
    }
    monsterpos[i][1] = h-1;
    monsterpos[i][2] = 0;  // toggle to indicate direction of monster movement
    monsterpos[i][3] = 0;  // toggle to indicate whether monster is alive
    previousoldmonpos = randommonstervar;
  }
}

/**
  * This is the method where I draw the instructions on my instruction panel
  */
void drawPanelSide()
{
  fill(240, 130, 30);
  textFont(playFont);
  textSize(14);
  text("Welcome to Pacman", 7, 50);
  text("Chutes & Ladders", 14, 66);            //Print out all welcome message on panel
  text("Welcome to Pacman", 7, 645);
  text("Chutes & Ladders", 14, 661);

  fill(255);
  text("Karthik Shankar &", 16, 300);
  text("Kavi Ravuri", 38, 316);
  text("CS 125: MP7", 38, 350);
}

/**
 * Draw time method to display users' time taken to complete game
*/
void drawTime()
{
  textSize(16);
  fill(0, 255, 0, 200);

  if(!pacmanwon && !monsterwon)      //Check to see if game has ended
  {
    timer = millis() - start;      //Get seconds, time and minutes to display
    mil = (timer%100);
    seconds = (timer/1000);
    minutes = seconds/60;
    text("Time: " + minutes%60 + ":" + seconds%60 + ":" + mil%60, 1127, 507); //Display time with strings in between
  }
}

/**
  * This is the method where I draw my buttons/panels on the right and left side
  * of the game and I also draw the play button, where the play is displayed and where
  * climbing and sliding notifications are shown.
  */
void drawPanels()             //Draw rectangle on the side of the screen
{
  int sec = millis()/450;
  fill(0, 0, 102);
  strokeWeight(5);
  stroke(240, 130, 30);
  rect(0, 0, (wext*size), (h*size));
  rect((wext+w)*size, 0, (wext*size), (h*size));

  // draw play button
  xb =  (wext+w)*size + 20;
  yb = 10*size;
  wb = 3*size;
  hb = size;
  color c = color(102, 255, 255);
  fill(c);
  noStroke();
  rect (xb, yb, wb, hb, 8);

  if (pacmanwon || monsterwon)  //Check to see if timer is over if the game is won by either the pacman or the monsters
  {
    checkTimer();
    drawTime();
  }
  color ct = color(153, 0, 153);
  fill(ct);
  textFont(playFont);
  textSize(16);

  if (pacmanclimbing)
    text("Climbing", xb+11, yb+23);
  else if (pacmansliding)
    text("Sliding", xb+15, yb+22);
  else if ((monsterwon || pacmanwon) && buttontimeout == true)            //Check to see if they won: Either of them
    text("", xb+20, yb+23);
  else if((monsterwon || pacmanwon))
    text("Restart", xb+20, yb+23);
  else
    text ("Play", xb+26, yb+22);
  fill(240, 130, 30);
  textSize(14);
  //Draw more notes on right panel
  text("Welcome to Pacman", 1118, 50);            //Printout the welcome messages on the board
  text("Chutes & Ladders", 1125, 66);
  text("Welcome to Pacman", 1118, 645);
  text("Chutes & Ladders", 1125, 661);

  fill(255);
  text("Controls", 1130, 120);
  textSize(11);
  text("Click 'Play': To move", 1118, 146);
  text("Press 'm' :  Back to menu", 1118, 162);       //Print out controls to user during game play

  textSize(14);
  ct = color(255, 10, 10);
  fill(ct);
  if (pacmanwon)                 //check winner of game and print if correct
  {
    if (sec%2 == 0)
      fill(51, 255, 204, 220);
    else
      fill(51, 255, 51, 220);
      textSize(44);
      String s = "" + minutes%60;
      String s3 = "" + seconds%60;
      String s4 = "" + mil%60;
      text("You won! Time: " + s + ":" + s3 + ":" + s4, (w/2)*size-37, (h/2)*size - 40);
      text("PACMAN WINS!", (w/2)*size-13, (h/2)*size+20);
      text("Check the leaderboard at:", (w/2)*size-25, (h/2)*size+80);
      text("leaderboard123.github.io", (w/2)*size-22, (h/2)*size+140);
  }
  else if (monsterwon)
  {
    if(sec%2==0)
      fill(51, 255, 204, 220);
    else
      fill(51, 255, 51, 220);
      textSize(44);
      text("You Lost, Your time doesn't count", (w/2)*size-107, (h/2)*size - 40);
      text("MONSTERS WIN!",(w/2)*size-10, (h/2)*size+10);
  }
}

/**
  * This is the method where I display the title menu.
  */
void displayMenu()
{
  int osx = (wext*size);
  int osy = size/2;
  int sec = millis()/450;

  if(keyCode == ENTER || keyCode == RETURN)             //print the enter and return options to the start panel
  {
    decideMenu = 2;  // move to play panel
  }

  if(decideMenu == 0)              //Print this out, when enter is not pressed
  {
    fill(51, 0, 102);
    stroke(240, 130, 30);
    strokeWeight(4);
    rect(0, 0, w*size+osx+147, h*size+osy);                    //Print out menu to cover entire screen to be able to draw menu and animations
    textSize(48);
    if (sec%3 == 0)
      fill(255, 10, 255, 200);
    else if(sec%2 == 0)
      fill(51, 255, 51, 200);
    else
      fill(255, 255, 0, 200);
    text("THE PACMAN CHUTES AND LADDERS",170, 100);
    drawTitleAnimation();
    if(sec%2 == 0)
      fill(255, 165, 0, 200);
    else
      fill(51, 0, 102, 200);
      textSize(36);
    text("Press Enter to Play The Game", 420, 640);
    textSize(25);
    fill(255, 0, 0, 200);
  }
  else
  {
    fill(0, 0, 0, 0);
    rect(0, 0, 0, 0);         //Otherwise do not draw anything
  }
}

/**
  * This is the method where I draw the title animation which is basically where
  * I display the flashing colors and draw the chute and ladder and pacman.
  * I also display the blinking, press enter sign in this method.
  */
void drawTitleAnimation()
{
  int sec = millis()/100;             //Draw title photos and on the title screen including a chute and a ladder and pacman moving his mouth
  color c1 = color(255, 0, 51);
  color c2 = color(102, 102, 0);

  fill(0);

  stroke(10, 255, 10, 230);
  rect(100, 120, 975, 480);
  stroke(0, 51, 102);
  fill(255, 255, 0);
  strokeWeight(4);                //Add title animations of pacman moving and of chute and a ladder
  if (sec%2 == 1)
  {
     arc(270, 400, 200, 200, 0.7,  PI+QUARTER_PI+QUARTER_PI+QUARTER_PI, PIE);
  }
  else
  {
    fill(255, 255, 0, 240);
    ellipse(270, 400, 200, 200);
  }

  stroke(c1);
  strokeWeight(23);
  noFill();
  bezier(900, 150, 300, 150, 1400, 300, 750, 480);
  stroke(c2);
  strokeWeight(9);
  line(500, 170, 590, 550);
  line(600, 170, 690, 550);
  for(int y = 190; y < 550; y+=30)               //Print out the lines
  {
    int x = ((y-170)*(90))/(380) +500;
    int xp = ((y-170) * (90))/(380) + 600;

    line(x,y,xp,y);
  }
}

/**
  * This is the method where I draw the pacman chutes and ladders
  * grid, which includes the basic white lines and black background.
  */
void drawGrid()
{
  int sw = wext*size;

 background(0);

  strokeWeight(1);
  for (int i = 0; i < w; i++)
  {
      stroke(255);
      line(sw+i*size, 0, sw+i*size, h*size);
  }
  for (int i = 0; i < h; i++)
  {
      line(sw, i*size, sw+w*size, i*size);
  }
}

/**
  * This is the method where I set up pacman's moving mouth and also where
  * I draw pacman based on his x and y positions changed in other methods
  * such as the move pacman method.
*/
void drawPacman()
{
  int sec = millis()/100;
  if (buttontimeout)
    checkTimer();
    drawTime();

  stroke(0, 51, 102);

  fill(255, 255, 0);
  strokeWeight(2);
  if (sec%2 == 1)
  {
     arc(((pacmanxpos*size)+pxoff)+4, (pacmanypos*size)+pyoff, 26, 26, 0.7,  PI+QUARTER_PI+QUARTER_PI+QUARTER_PI, PIE);     //Draw pacman here
  }
  else
  {
    fill(255, 255, 0, 240);
    ellipse(((pacmanxpos*size)+pxoff)+4, (pacmanypos*size)+pyoff, 26, 26);
  }
}

/**
  * This is the method that I use to draw the monsters, after checking to make sure that they
  * are alive. I also tint their images, to make sure they show up well on the screen.
 */
void drawMonsters()
{
  stroke(0);
  tint(255);
  if (monsterpos[0][3] == 0)              //Only draw the monsters if they are alive and that number is held in the 4th position of the monster array
    image(blinky, (monsterpos[0][0]*size)+mxoff, monsterpos[0][1]*size-2, 33, 33);

  tint(100, 255, 255);
  if (monsterpos[1][3] == 0)
    image(clyde, (monsterpos[1][0]*size)+mxoff, monsterpos[1][1]*size, 30, 30);

   tint(250, 200, 200);
  if (monsterpos[2][3] == 0)
    image(dinky, (monsterpos[2][0]*size)+mxoff, monsterpos[2][1]*size+1, 29, 29);
}

/**
  * This is the method where I draw the chutes, based on the positions that
  * I had in the array.
  */
void drawChutes()
{
  int osx = (wext*size);
  int osy = size/2;
  color c1 = color(255, 0, 51);
  color c2 = color(102, 255, 102, 200);             //Get each of the colors to print out the colors of the ladder and flashing colors
  color c3 = color(204,0, 204, 200);
  int sec = millis()/500;

  strokeWeight(12);
  noFill();

  for (int i = 0;i < chutearr.length;i++)
  {
    if (chutearr[i][8] == 0)
    {
      stroke(c1);
    }
    else
    {
     if (sec%2 == 0)              //Make sure to have flashing chutes when the pacman enters
        stroke(c2);
      else
        stroke(c3);
    }
    bezier(chutearr[i][0]*size+osx+size/2, chutearr[i][1]*size+osy, chutearr[i][2]*size+osx+size/2, chutearr[i][3]*size+osy, //Bezier curve method
    chutearr[i][4]*size+osx+size/2, chutearr[i][5]*size+osy, chutearr[i][6]*size+osx+size/2, chutearr[i][7]*size+osy);
  }
}

/**
  * This is the method where I draw the ladders based on the positions in the ladder array.
  */
void drawLadders()
{
  int osx = (wext*size);
  int osy = size/2;
  color c1 = color(150, 150, 30);
  color c2 = color(102, 255, 102, 200);
  color c3 = color(204,0, 204, 200);
  int sec = millis()/500;

  noFill();
  stroke(c1);
  strokeWeight(5);

   //Draw all ladders in this for loop
  for (int i = 0; i < ladarr.length; i++)
  {
    if (ladarr[i][8] == 0)
      stroke(c1);
    else
    {
      if (sec%2 == 0)
        stroke(c2);
      else
        stroke(c3);
    }
    line(ladarr[i][0]*size+osx, ladarr[i][1]*size+osy, ladarr[i][2]*size+osx, ladarr[i][3]*size+osy);
    line(ladarr[i][4]*size+osx, ladarr[i][5]*size+osy, ladarr[i][6]*size+osx, ladarr[i][7]*size+osy);
  }

  //Draw the ladder connecting segments here
  for (int i = 0; i < ladarr.length; i++)
  {
    for (int y = ladarr[i][1]+1; y < ladarr[i][3]; y++)
    {
      int x = (((y-ladarr[i][1])*size*(ladarr[i][2] - ladarr[i][0]))/(ladarr[i][3] - ladarr[i][1])) + ladarr[i][0]*size;
      int xp = (((y-ladarr[i][5])*size*(ladarr[i][6] - ladarr[i][4]))/(ladarr[i][7] - ladarr[i][5])) + ladarr[i][4]*size;

      if (ladarr[i][8] == 0)
        stroke(c1);                    //Make sure to have flashing ladders when pacman enters
      else
        stroke(c2);
      line(x+osx, y*size+osy, xp+osx, y*size+osy);
    }
  }
}

/**
  *This is the method where I draw the colored boxes underneath the ladders, so that
  * the user knows where he can hit the ladder to go up the ladder.
  */
void drawLadderBoxes()
{
  int osx = (wext*size);
  int osy = size/2;

  for(int i = 0; i < ladarr.length; i++)
  {
    fill(255, 255, 0, 140);
    strokeWeight(1);
    stroke(255);
    rect(ladarr[i][2]*size+osx, (ladarr[i][3]*size+osy)-15, 30, 30);
  }
}

/**
  * This is the method where I draw the chute boxes above the chutes
  * so that the user knows where he will hit a chute.
  */
void drawChuteBoxes()
{
  int osx = (wext*size);
  int osy = size/2;

  for(int i = 0; i < chutearr.length; i++)
  {
    fill(255, 0, 0, 190);
    strokeWeight(1);
    stroke(255);
    rect(chutearr[i][0]*size+osx, (chutearr[i][1]*size+osy)-15,30, 30);
  }
}

/**
  * This is the standard draw method which draws all parts of the panels.
 */
void draw()
{
  if(key == 'm')
  {
    decideMenu = 0;
  }

  //Draw checkerboard for the game
  drawGrid();

  drawChutes();           //Draw grid, chutes, ladder and each of the boxes

  drawLadders();                  //Call all methods to display the game

  highlightPositions();

  drawLadderBoxes();

  drawChuteBoxes();

  // Draw buttons
  drawPanels();
  drawPanelSide();

  checkPacmanLadderChute();        //Draw obstacle and check if Pacman is hitting them

  drawPacman();

  drawMonsters();

  displayMenu();                      //Call last so that we can display the menu panel last

  if(pacmanwon || monsterwon)
      allowExit();      //Check if user wants to exit or not
}

/**
  * This is the method where I allow the user to exit at the end of the
  * game if the user hits 'e'. It also pushes pacman back to the start of the board
  * when the game is over.
  */
void allowExit()
{
  if(buttontimeout == false)
  {
    pacmanxpos = 0;
    pacmanypos = h-1;
    textSize(16);
    fill(0, 255, 0, 200);
    text("Press 'e' to Exit", 1118, 259);
    textSize(12);
    fill(255, 255, 0);
    text("or restart button below", 1119, 275);

    if(key == 'e')
      exit();
  }
}

/**
  * This method makes sure to highlight the start and end positions
  * on the game board to help the user.
  */
void highlightPositions()
{
  stroke(0, 255, 0, 200);
  strokeWeight(2);
  fill(255, 255, 255, 200);
  rect(152, 660, 30, 30);
  rect(1079, 0, 30, 30);
}

/**
  * This method starts the timer and checks to make sure that it is not starting the timer
  * when the program has ended. Other wise, it starts the timer and creates a start and end
  * time that the timer goes on for.
  */
void startTimer()
{
  if (buttontimeout)
    return;
  stime = millis();
  etime = stime;
  buttontimeout = true;
}

/**
  * This method is to faciliate the Pacman animation over the ladders and chutes.
  */
void checkTimer()
{
  if (!buttontimeout)
    return;
  etime = millis();
  int diff = abs(etime - stime);
  if (pacmanclimbing || pacmansliding)
  {
    if (diff < difftimer)
    {
      pacmanxpos = ((px2-px1)*diff)/difftimer + px1;
      pacmanypos = ((py2-py1)*diff)/difftimer + py1;
    }
    else
    {
      pacmanxpos = px2;
      pacmanypos = py2;
      pacmanclimbing = false;
      pacmansliding = false;
      buttontimeout = false;

      for (int i=0;i < ladarr.length;i++)
        ladarr[i][8] = 0;
      for (int i=0;i < chutearr.length;i++)
        chutearr[i][8] = 0;
    }
 }
 else
 {
   if (diff >= gameendtimer)
     buttontimeout = false;
 }
}

/**
  * This is where I check to see if Pacman lands on a chute or ladder so he can go up or down accordingly.
*/
void checkPacmanLadderChute()
{
  if (pacmanclimbing || pacmansliding)
    return;
  for(int i = 0 ; i < ladarr.length; i++)
  {
    if((pacmanxpos == ladarr[i][2]) && (pacmanypos == ladarr[i][3]))
    {
      px1 = pacmanxpos;
      py1 = pacmanypos;
      px2 = ladarr[i][0];                                //Make sure pacman slowly moves up the ladder once the timer starts
      py2 = ladarr[i][1];
      pacmanclimbing = true;
      ladarr[i][8] = 1;
      startTimer();
    }
  }

  for(int i = 0; i < chutearr.length; i++)
  {
    if((pacmanxpos == chutearr[i][0]) && (pacmanypos == chutearr[i][1]))
    {
      px1 = pacmanxpos;
      py1 = pacmanypos;
      px2 = chutearr[i][6];
      py2 = chutearr[i][7];                //Make sure pacman slowly moves up chute once timer starts and animation goes on
      pacmansliding = true;
      chutearr[i][8] = 1;
      startTimer();
    }
  }
  int d = (pacmanypos - (h-1))%2;
  if (d == 0)
    pacmandirection = 0;
  else
    pacmandirection = 1;

}

/**
 * This method moves the monster positions from 1-10 steps ahead of all the monsters. It moves
 * the monsters the same way as it moves pacman, which allows the monsters to be wrapped around the gameboard.
 */
void moveMonsters()
{

    for(int i = 0; i < monsterpos.length; i++)
    {
      if (monsterpos[i][3] == 1)
        continue;

      int random = (int)(random(1, 10));
      monrollcount = random;
      int newxpos;

      if (monsterpos[i][2] > 0)  // monster is on an odd line
      {
        newxpos = monsterpos[i][0] - random;
         if (newxpos <= 0)
        {
          if (monsterpos[i][1] >= 1)
          {
            monsterpos[i][1]--;
            monsterpos[i][2] = 0;
            monsterpos[i][0] = abs(newxpos);
          }
          else
          {
            monsterwon = true;
            monsterpos[i][0] = 0;
            startTimer();
          }
        }
        else
          monsterpos[i][0] = newxpos;
      }
      else  // monster is on an even line
      {
        newxpos = monsterpos[i][0] + random;
        if (newxpos >= w-1)
        {
          if (monsterpos[i][1] >= 1)
          {
            monsterpos[i][1]--;
            monsterpos[i][2] = 1;
            monsterpos[i][0] = w-1 - newxpos%(w-1);       //Make sure pacman wraps around
          }
          else
          {
            monsterwon = true;
            monsterpos[i][0] = w-1;
            startTimer();
          }
        }
        else
          monsterpos[i][0] = newxpos;
      }
  }
}

/**
  * This method moves pacman around the gameboard from 1-6 steps ahead of him
  * and also checks to see if Pacman has won the game.
  */
void movePacman()
{
  int randommovnum = (int)(random(1, 6));
  int newxpos;
  rollcount = randommovnum;
  if (pacmandirection > 0)  // pacman is on an odd line
  {
      newxpos = pacmanxpos - randommovnum;
      if (newxpos < 0)
      {
        if (pacmanypos >= 1)
        {
          pacmanypos--;
          pacmandirection = 0;
          pacmanxpos = abs(newxpos);
        }
        else
        {                                     //Move pacman and also have him wrap around the game board
          pacmanwon = true;
          pacmanxpos = 0;
          startTimer();
        }
      }
      else
        pacmanxpos = newxpos;
  }
  else
  {
     newxpos = pacmanxpos + randommovnum;         //Create a new pos by holding the new position after pacman moves
     if (newxpos >= w-1)
     {
        if (pacmanypos >= 1)
        {
          pacmanxpos = w-1 - newxpos%(w-1);
          pacmandirection = 1;
          pacmanypos--;
        }
        else
        {
          pacmanwon = true;
          pacmanxpos = w-1;
          startTimer();
        }
     } else
     {
        pacmanxpos = newxpos;
     }
  }
}

/**
  * This method checks to see if the button has been clicked by the user.
  */
boolean clickedInButton()
{
  if (buttontimeout)
  {
    checkTimer();
    drawTime();
    if (buttontimeout)
      return false;
  }
  if (mouseX > xb && mouseX < (xb+wb) && mouseY > yb && mouseY < (yb+hb))
  {
    if (monsterwon || pacmanwon)
      resetboard();
    return true;
  }
  return false;
}

/**
  * This method moves Pacman and the monster.
  */
void mouseReleased()
{
  int xb =  (wext+w)*size + 20;
  int yb = 10*size;
  if (!clickedInButton())
    return;
  stroke(102, 255, 255);
  strokeWeight(1);
  fill(255, 255, 0, 100);
  rect(xb+2, yb+4, 85, 22);
  movePacman();
  moveMonsters();
}

void mouseClicked()
{
   return;
}