import java.io.File;
import java.io.FilenameFilter;
import de.looksgood.ani.*;
import processing.video.*;
import java.util.Map;
import java.util.ArrayList;

PFont PrimaryFont;
PShape hexagon, videohexa;

final float FADE_DUR = 0.5,
            ANIMATION_DUR = 0.5,
            ANNOUNCEMENT_DUR = 10.0,
            TEASER_DUR = 15;
            
final int SCREEN_WIDTH = 1920, 
          SCREEN_HEIGHT = 1080,
          Y_AXIS = 1,
          X_AXIS = 2;

boolean record = false;
boolean framerate = false;
boolean debug = false;

// Parameter for currentTeaserList
TeaserList teaserList;
Teaser currentTeaser;

AnimatedText teaserHeadline, teaserSubheadline, teaserTime, teaserDay, teaserLocation;
AnimatedShapes leftOrnament, rightOrnament, bigOrnament;
AniSequence teaserSeq;
 AniSequence blendeSeq;
Videolayer vLayer;

Map<String, ColorSet> myColors = new HashMap<String, ColorSet>();
ColorSet aktColor;
color defaultColor;
String showDay;

Mediatype playType;
int teaserLength = 0; // Total number of movies
int teaserIndex = 0; // Initial movie to be displayed

int adsLength = 0; // Total number of movies
int adsIndex = 0; // Initial movie to be displayed

int startAnnouncement = 0;
int cicle = 1;

Movie teaser, advert;
File [] adverts;



boolean announcement = false,
        teaserReady = false,
        adsReady = false,
        firstRun = false,
        isPlaying = false;    
    
PImage bgImage,
       feierabend,
       logoImage,
       errorPage;
       
     
       
LogFile playLog, errorLog;
Blende blende;

String headline, information;

/*void settings() {
 
}*/


/************************************************************************************
                          init Objects
*************************************************************************************/  
void initBlendeAnimation(){

    //blende.initAnimationSequence(this);
    
    blendeSeq = new AniSequence(this); 
    blendeSeq.beginSequence();
           
       //Step - Close Blende   
       blendeSeq.beginStep();
         blendeSeq.add(blende.setAnimation(FADE_DUR,0.0,"maskY:540", Ani.QUAD_OUT));
         blendeSeq.add(blende.setAnimation(FADE_DUR,0.0,"maskHeight:0", Ani.QUAD_OUT, this, "onEnd:callbackClosedBlende"));
       blendeSeq.endStep();  
     
       //Step - Open Blende
       blendeSeq.beginStep();
         blendeSeq.add(blende.setAnimation(FADE_DUR,0.5,"maskY:0", Ani.QUAD_IN));
         blendeSeq.add(blende.setAnimation(FADE_DUR,0.5,"maskHeight:1080", Ani.QUAD_IN, this, "onEnd:callbackOpenBlende"));
       blendeSeq.endStep();
    blendeSeq.endSequence();
    blendeSeq.start();

}
void initTeaserAnimation (String blendType) {
float endOffset = (TEASER_DUR - (2*(FADE_DUR+ANIMATION_DUR)));
    
   teaserSeq = new AniSequence(this);
   teaserSeq.beginSequence();
       
     //Step - Move In   
     teaserSeq.beginStep();
       
       teaserSeq.add(vLayer.setAnimation(ANIMATION_DUR*2, 1.0, "x:790",Ani.LINEAR));
       teaserSeq.add(teaserHeadline.setAnimation(ANIMATION_DUR*2, 1.0,"fontX:"+teaserHeadline.endPos_X,Ani.QUAD_OUT));
       teaserSeq.add(teaserSubheadline.setAnimation(ANIMATION_DUR*2, 1.0,"fontX:"+teaserSubheadline.endPos_X,Ani.QUAD_OUT));
       
       float ornamentTime = (FADE_DUR+ANIMATION_DUR);
       teaserSeq.add(leftOrnament.setAnimation(ANIMATION_DUR, ornamentTime, "scale: 1.0", Ani.ELASTIC_OUT));
       teaserSeq.add(rightOrnament.setAnimation(ANIMATION_DUR, ornamentTime, "scale: 1.0", Ani.ELASTIC_OUT));
           
       float textTime = (FADE_DUR+ANIMATION_DUR*2);     
       teaserSeq.add(teaserTime.setAnimation(ANIMATION_DUR, textTime,"fontY:"+teaserTime.endPos_Y,Ani.QUAD_OUT));
       teaserSeq.add(teaserDay.setAnimation(ANIMATION_DUR, textTime,"fontX:"+teaserDay.endPos_X,Ani.QUAD_OUT));
       teaserSeq.add(teaserLocation.setAnimation(ANIMATION_DUR, textTime,"fontX:"+teaserLocation.endPos_X,Ani.QUAD_OUT));
     teaserSeq.endStep();  
     
     //Step - Move Out
     teaserSeq.beginStep();
     
       textTime = (endOffset - ANIMATION_DUR*2);
       teaserSeq.add(teaserTime.setAnimation(ANIMATION_DUR, textTime,"fontY:"+teaserTime.offPos_Y,Ani.QUAD_IN));
       teaserSeq.add(teaserDay.setAnimation(ANIMATION_DUR, textTime,"fontX:"+teaserDay.offPos_X,Ani.QUAD_IN));
       teaserSeq.add(teaserLocation.setAnimation(ANIMATION_DUR, textTime,"fontX:"+teaserLocation.offPos_X,Ani.QUAD_IN));
       
       ornamentTime = endOffset - (ANIMATION_DUR);
       teaserSeq.add(leftOrnament.setAnimation((ANIMATION_DUR), endOffset-ANIMATION_DUR, "scale: 0.0", Ani.ELASTIC_IN));
       teaserSeq.add(rightOrnament.setAnimation((ANIMATION_DUR), endOffset-ANIMATION_DUR, "scale: 0.0", Ani.ELASTIC_IN));
       
       teaserSeq.add( vLayer.setAnimation(ANIMATION_DUR, endOffset, "x:1920",Ani.LINEAR));
       teaserSeq.add(teaserHeadline.setAnimation(ANIMATION_DUR, endOffset,"fontX:"+teaserHeadline.offPos_X,Ani.QUAD_IN));
       teaserSeq.add(teaserSubheadline.setAnimation(ANIMATION_DUR, endOffset,"fontX:"+teaserSubheadline.offPos_X,Ani.QUAD_IN));       
     teaserSeq.endStep();
     
    teaserSeq.endSequence();
}

void initColorSet() {

  //default
  myColors.put ("default", new ColorSet(
      color(255, 255, 255),
      color(175 ,175, 175),
      color(154, 154, 154),
      color(37,37,37),
      color(101, 101, 101),
      color(60, 60, 60)
  )); 

   //guests **
   myColors.put ("guest", new ColorSet(
      color(255, 255, 255),
      color(155 ,155, 155),
      color(138, 41, 138),
      color(39, 20, 39),
      color(130, 40, 119),
      color(77, 28, 77)
    ));
    
  //programm
  myColors.put ("programm", new ColorSet(
      color(0, 0, 0),
      color(75 ,75, 75),
      color(188, 174, 5),
      color(250, 231, 7),
      color(143, 132, 6),
      color(188, 174, 5)
    ));
  
  //showact
  myColors.put ("showact", new ColorSet(
     color(255, 255, 255),
     color(175, 175, 175),
     color(118, 38, 5),
     color(234, 96, 37),
     color(225, 130, 48),
     color(127, 42, 6)
  ));
  
  //contest **
  myColors.put ("contest", new ColorSet(
     color(255, 255, 255),
     color(175, 175, 175),
     color(188, 70, 115),
     color(45, 3, 20),
     color(101, 8, 43),
     color(188, 0, 78)
  ));
  
  //event **
  myColors.put ("event", new ColorSet(
     color(255, 255, 255),
     color(175, 175, 175),
     color(50, 80, 139),
     color(13, 22, 41),
     color(19, 59, 139),
     color(43, 75, 139)
  ));
  
  //workshop **
  myColors.put ("workshop", new ColorSet(
     color(255, 255, 255),
     color(175, 175, 175),
     color(0, 96, 126),
     color(13, 29, 39),
     color(77, 169,227),
     color(0, 195, 255)
  ));
  
  //vortrag **
  myColors.put ("vortrag", new ColorSet(
     color(255, 255, 255),
     color(47, 71,3),
     color(121, 181, 10),
     color(47, 71,3),
     color(145, 187,66),
     color(170, 255,10)
     
  ));
  
  myColors.put ("booth", new ColorSet(
     color(255, 255, 255),
     color(175, 175, 175),
     color(109, 174, 255),
     color(36, 63, 94),
     color(42, 99, 171),
     color(66, 106, 155)
  )); 
}

/************************************************************************************
                          init Objects to Display
*************************************************************************************/  
void initTeaserText() {

      teaserHeadline = new AnimatedText("Teaserheadline", PrimaryFont, 100, defaultColor, 100,450, LEFT, BOTTOM);
      teaserHeadline.initAnimation(LEFT);
      
      teaserSubheadline = new AnimatedText("TeaserSubheadline", PrimaryFont, 65, defaultColor, 100,475, LEFT, TOP);
      teaserSubheadline.initAnimation(LEFT);
      
      teaserTime = new AnimatedText("11:30", PrimaryFont, 100, defaultColor, 500, 850, CENTER,CENTER);
      teaserTime.initAnimation(BOTTOM);
      
      teaserDay = new AnimatedText(showDay, PrimaryFont, 60, defaultColor, 380, 720, RIGHT, TOP);
      teaserDay.initAnimation(RIGHT);
      
      teaserLocation = new AnimatedText("Gesellschaftsaal", PrimaryFont, 65, defaultColor, 615, 1000, LEFT, BOTTOM);
      teaserLocation.initAnimation(LEFT);  
}

void initOrnament() {
   leftOrnament = new AnimatedShapes(hexagon, 350, 700, 300, 300);
   leftOrnament.setScale(0.0);
   leftOrnament.setRotation(90);
   
   bigOrnament = new AnimatedShapes(hexagon, -100, -200, 1080, 1080);
   bigOrnament.setRotation(-45);
   
   rightOrnament = new AnimatedShapes(hexagon, 1610, 700, 300, 300);
   rightOrnament.setScale(0.0);
   rightOrnament.setRotation(-45);
}


/************************************************************************************
                          basic Programm Functions
*************************************************************************************/  

void setup() {
  
  //set Size of our canvas & framerate
  size(1920,1080);
  surface.setResizable(true);
  smooth(2);
  //fullScreen(1); 
  
  // Init AnimationClasses
  Ani.init(this);

  //load Shape 
  hexagon = loadShape(dataPath("assets/shapes/hexa-sharp.svg"));
  videohexa = loadShape(dataPath("assets/shapes/new-hexa.svg"));
  defaultColor = color(0,0,0);
   
  //set Font
  PrimaryFont = createFont(dataPath("assets/fonts/FTY SPEEDY CASUAL NCV.ttf"),80);
    
  //setup a default Background

  
  logoImage = loadImage(dataPath("assets/images/logo_small.png"));
  feierabend = loadImage(dataPath("assets/images/feierabend.jpg"));
  
  if(day() == 22) { showDay = "Freitag"; }
  else if(day() == 23) { showDay = "Samstag";}
  else { showDay = "Sonntag"; }
  showDay = "Freitag";
  // init default-styling
  noStroke();
  fill(255);
  
  errorPage = loadImage(dataPath("default/error.jpg"));
  
  //init Blende
  blende = new Blende(0,0,SCREEN_WIDTH, SCREEN_HEIGHT);
  //background(blende.getImage(0)); //draw it once
  blende.initMask("diagonal");
  //blende.setLogo(logoImage);
    
  // set up the videoLayer
  vLayer = new Videolayer (videohexa, 1920, 0, 1080, 1080);
  vLayer.setRotation(0);
  vLayer.setupBackground(50,-50);
   
  //Set up our TeaserFiles
  teaserList = new TeaserList("teaser-utf8.csv");
  
  firstRun = true;
  playType = Mediatype.TEASER;
  
  this.initColorSet();
  this.initTeaserText();
  this.initOrnament();
  
  

  this.initBlendeAnimation();
  this.initTeaserAnimation("diagonal");
  
  //Write File
  playLog = new LogFile("play");
  errorLog = new LogFile("error");
  
  loadFiles("werbung");
}
void exit() {
  super.exit();
}

void draw() {
  switch(playType) {
    case ANNOUNCE: 
      showAnnouncement(headline, information);
      break;
    case TEASER: 
      if (teaserReady) { playMovie(teaser, true); }
      break;
    case ADVERT: 
      if (adsReady) { playMovie(advert, false); }
      break;
    case CLOSING:
       image(feierabend,0,0); break;
    default:     
  }
  
  if (record) {
    saveFrame(dataPath("screenshot/frame-#########.tga"));
  }
}

void checkNext(boolean next) {
  firstRun = false;
  
  if (checkAnnouncement("announcement.json")) { 
    playType = Mediatype.ANNOUNCE; 
    playLog.write("Announcement was played");    
    return;
  }
  else if (int(""+hour()+""+minute()) >= 2200 ) {
      playType = Mediatype.CLOSING;
      println("ClosingTime");
      return;
  }
  else if (playType == Mediatype.ADVERT){
    adsReady = false;
    if(next) {
      next = false;    
      if (adsIndex+1 >= adsLength){
          adsIndex = 0;
          playType = Mediatype.TEASER;
          firstRun = true;
          checkNext();
          return;
      } else { ++adsIndex; }
    }
    advert = this.loadMovie(adverts[adsIndex].getPath());
    adsReady = true;
    playLog.write("Advertisment was played");  
    return;
  }
  else if(playType == Mediatype.TEASER) {
    if (next) {
      next = false;
      if (teaserIndex+1 >= teaserList.length){
          teaserIndex = 0;
          cicle++;
          playType = Mediatype.ADVERT;
          firstRun = true;
          checkNext();
          return;
      } else { ++teaserIndex;}
    }
    loadTeaser(teaserIndex);
       
  }
  playType = Mediatype.TEASER;
}
void checkNext() { checkNext(false); }

void playMovie(Movie movie, boolean isTeaser){
  if(movie.available()){
    movie.read();
  }
  debugLog("drawcurrentTeaser");
 
  debugLog("backgroundimage");
  
  if(isTeaser){ displayTeaser(movie); }
  else { displayAdvert(movie); }
  
  blende.display();
  debugLog("after backgroundImage");

  showFramerate ();
}


/************************************************************************************
                          LoadFiles
*************************************************************************************/   
void loadFiles (String folderName){
  File dir = new File(dataPath(folderName));
  File [] files = dir.listFiles(
                  new FilenameFilter() { 
                     public boolean accept(File dir, String filename){ 
                       return filename.endsWith(".mp4"); 
                     }
                  });
  adverts = files;
  adsLength = files.length;
}

/************************************************************************************
                          Teasers 
*************************************************************************************/  

void loadTeaser(int index) {
     this.currentTeaser = teaserList.get(index);
     
     if(!currentTeaser.shouldPlay()) {
       playLog.write("Skip T_"+(teaserIndex+1)+": "+this.currentTeaser.day+" "+this.currentTeaser.time+" - ‘"+this.currentTeaser.headline+"‘");
       teaserIndex++;
       loadTeaser(teaserIndex);
       
       return;
     }
     
     aktColor = myColors.get(currentTeaser.type);
     playLog.write("Play T_"+(teaserIndex+1)+": "+this.currentTeaser.day+" "+this.currentTeaser.time+" - ‘"+this.currentTeaser.headline+"‘");
     
     this.updateTeaser();
     this.resetTeaser();
}

Movie loadMovie(String Path) {
  Movie tempM = new Movie(this, Path);
  tempM.noLoop();
  tempM.play();
  tempM.volume(0);
  return tempM;
}

void updateTeaser() {
      
      //TeaserVideo
      teaser = new Movie(this, dataPath("teaser/"+currentTeaser.filePath+".mp4"));
      teaser.noLoop();
      teaser.play();
      
      teaserHeadline.setText(currentTeaser.headline);
      teaserHeadline.setColor(aktColor.primary);
      
      teaserSubheadline.setText(currentTeaser.subheadline);
      teaserSubheadline.setColor(aktColor.secondary);
      
      teaserTime.setText(currentTeaser.time);
      teaserTime.setColor(aktColor.primary);
      
      teaserDay.setText(currentTeaser.day);
      teaserDay.setColor(aktColor.primary);
      
      teaserLocation.setText(currentTeaser.location);
      teaserLocation.setColor(aktColor.third);
      
      color newColor = (aktColor.highlight & 0xffffff) | (25 << 24);
      bigOrnament.setColor(newColor);
      leftOrnament.setColor(aktColor.elements);
      rightOrnament.setColor(aktColor.elements);
      
      vLayer.setBorder(aktColor.background, 10);
      vLayer.setColor(aktColor.highlight);  
      teaserReady = true;
}

void unloadTeaser() {
    
    teaser.stop();
    //teaser = null;
    
    bigOrnament = null;
    leftOrnament = null;
    rightOrnament = null;
    
    teaserLocation = null;
    teaserTime = null;
    teaserHeadline = null;
    teaserDay = null;
    
    teaserReady = false;
}

void resetTeaser(){
  teaser.jump(0);
  teaser.volume(0);
    
}

void displayTeaser(Movie movie){
 if(!isPlaying){ teaserSeq.start(); movie.play(); isPlaying = true;}
   
  clear();
   debugLog("teaserBg");
  fill(aktColor.background);
  rect(0,0, SCREEN_WIDTH, SCREEN_HEIGHT);
  
  debugLog("bigOrnament");
  bigOrnament.display();
  debugLog("videolayer");
  vLayer.display(movie);
  debugLog("littleOrnament");
  rightOrnament.display();
  leftOrnament.display();
  
  debugLog("text");
  teaserHeadline.display();
  teaserSubheadline.display();
  teaserDay.display();
  teaserTime.display();
  teaserLocation.display();
  debugLog("afterText");
  if(teaserSeq.isEnded()){ isPlaying = false; blendeSeq.start();}
}
void displayAdvert(Movie movie) {
    if(!isPlaying){ isPlaying = true; movie.play();}
    float mt = movie.time();
    float md = movie.duration();
    image(movie,0,0); 
    g.removeCache(movie);
    if(isPlaying && (mt >= md-1)){adsReady = false; isPlaying = false; blendeSeq.start();}
}

/************************************************************************************
                          PSA Public Service Announcement
*************************************************************************************/   

boolean checkAnnouncement(String filename) {
  JSONArray values = loadJSONArray(dataPath(filename));
  JSONObject json;
  
  for (int i = 0; i < values.size(); i++) {
    json = values.getJSONObject(i);
    announcement = json.getBoolean("active");
    if(!announcement){ return announcement; }
    headline = json.getString("headline");
    information = json.getString("information");
  }
  
  // clearing Elements so GarbageCollector can dump it
  values = null; json = null;
  return announcement;
}

void showAnnouncement(String headline, String information){
  if (!isPlaying) { startAnnouncement = millis(); isPlaying= true; }
  image(errorPage,0,0);
  if(timePassed(startAnnouncement) >= ANNOUNCEMENT_DUR){isPlaying = false; blendeSeq.start();}
}


/************************************************************************************
                          Generic Methods for Movies
*************************************************************************************/     

void movieEvent(Movie myMovies) {
  //myMovies.read();
  //redraw();
}

/************************************************************************************
                          Generic Methods for Movies
*************************************************************************************/  

void setGradiant (int x, int y, float w, float h, color c1, color c2, int axis) {
  noFill();

  if (axis == Y_AXIS) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == X_AXIS) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
}

float timePassed(int timeStamp){
  return ((millis() - timeStamp)/1000);
}  

void showFramerate(){
  if (framerate){
    textSize(24);
    fill(125);
    text("Framerate: "+frameRate, 50,50);
  }  
}

void keyPressed() {
  switch (key) {
    case 'F': framerate = !framerate; break;
    case 'T': /*reset*/; break; //reload Teaser
    case 'X': this.exit();
    case 'P': if(looping){ noLoop(); } else { loop(); } break;
    case 'D': debug = !debug; break;
    case 'R': record =!record; break;
  }
}

/************************************************************************************
                          LoadFiles
*************************************************************************************/   
  void callbackOpenBlende() {
    blende.sequenceEnd();
  }
  void callbackClosedBlende() { checkNext(!firstRun);}
  
/************************************************************************************
                          Write Log
*************************************************************************************/   

void debugLog(String milestone){
  if(debug) {
    println("before "+milestone+" "+millis());
  }
}