class Blende extends AnimatedObject{
  int maskX, maskY, maskWidth, maskHeight;
  PGraphics mask;
  boolean logo = false;
  PImage logoImage, stage;
  ArrayList<PImage> backgroundImage; 
  
  Blende(int x , int y, int w, int h){
    super(x,y,w,h);
    this.maskWidth = w;
    this.maskHeight = h;
    
    this.backgroundImage = new ArrayList<PImage>();
    for(int i=0; i<4; i++) {
      this.backgroundImage.add(loadImage(dataPath("assets/images/inBetweener/inBetweener"+(i+1)+".png")));
    }
    this.stage = this.backgroundImage.get(0);
    mask = createGraphics(this.width, this.height);
    
  }
  
  void initMask(String type) {
    /* if (type == "curtain") {*/
       this.maskWidth = 1920;
       this.maskHeight = 1080;
       this.maskY = 0;
     /*}*/
  }
  void setLogo (PImage l) {
    this.logoImage = l;
    this.logo = true;
  }
  PImage getImage(int index) {
     return this.backgroundImage.get(3);
  }
  
  void display(){
    float p1X = this.maskX, 
          p1Y = this.maskY,
          p2X = (this.maskX+this.maskWidth), 
          p2Y = (this.maskY+this.maskHeight);
          
    mask.beginDraw(); // begin
    mask.background(255); //white background
    mask.noStroke();
    mask.fill(0);
    // println ("before blendeDrawMask: "+ millis());

    mask.quad( p1X, p1Y, p2X, p1Y, p2X, p2Y, p1X, p2Y );
    mask.endDraw(); // end 
    
    // println ("append blendeMask: "+ millis());
    this.stage.mask(mask);
    // println ("after append blendeMask: "+ millis());
    //image(mask,0,0);
    image(this.stage,0,0);
    // println ("after blendeMask drawn: "+ millis());
    if(this.logo) {
      imageMode(CENTER);
      image(this.logoImage,this.width/2,this.height/2);
      imageMode(CORNER);
    }
    g.removeCache(this.stage);
  }
  
  void sequenceEnd() {
    int in = int(random(4));
      this.stage = this.backgroundImage.get(in);
  }
  void seqEnd() {println("seqEnd"); }
  
  Ani[] setAnimation(String type, float dur, float offset, String direction){
      // if (type == "curtain") { 
         return blendTypeCurtain (dur, offset, direction); 
       //}
  }

  Ani[] blendTypeCurtain(float dur, float offset, String direction) {
      String propertylist = (direction == "close") ? ("maskY:540,maskHeight:0") : ("maskY:0,maskHeight:1080");
      return super.setAnimation(dur, offset, propertylist, Ani.LINEAR);
  }

}