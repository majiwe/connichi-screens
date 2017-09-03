class Blende extends AnimatedObject{
  int maskX, maskY, maskWidth, maskHeight;
  PGraphics mask;
  
  Blende(int x , int y, int w, int h){
    super(x,y,w,h);
    this.maskWidth = w;
    this.maskHeight = h;
    mask = createGraphics(this.width, this.height);
    
  }
  void initMask(String type) {
     if (type == "curtain") {
       this.maskWidth = 1920;
       this.maskHeight = 0;
       this.maskY = (this.height/2);
     }
  }
  
  void display(PImage myImage){
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
    myImage.mask(mask);
    // println ("after append blendeMask: "+ millis());
    image(myImage,0,0);
    // println ("after blendeMask drawn: "+ millis());
    g.removeCache(myImage);
  }
  
  Ani[] setAnimation(String type, float dur, float offset, String direction){
      // if (type == "curtain") { 
         return blendTypeCurtain (dur, offset, direction); 
       //}
  }

  Ani[] blendTypeCurtain(float dur, float offset, String direction) {
      String propertylist = (direction == "in") ? ("maskY:0,maskHeight:"+this.height) : ("maskY:"+(this.height/2)+",maskHeight:0");
      return super.setAnimation(dur, offset, propertylist, Ani.QUINT_IN);
  }
      return super.setAnimation(dur, offset, propertylist, Ani.QUINT_IN);
  }
}