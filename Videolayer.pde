class Videolayer extends AnimatedShapes {
  PGraphics mask;
  boolean hasBG;
  int offX = 0, offY = 0;

  Videolayer(PShape s, int x, int y, int w, int h) {
    super(s,x,y,w,h);
    this.shape = s;
    this.fillColor = color(0,0,0);
    mask = createGraphics(this.width, this.height);
  }
  
  void updateLayer(){
    this.setupLayer(this.mask, 0, 0, this.width, this.height, this.rotation);
  }
  
  void setupBackground(int off_x, int off_y){
    this.hasBG = true;
    this.offX = off_x;
    this.offY = off_y;
  }
  
 
  void setupLayer (PGraphics layer, int x, int y, int w, int h, float rotation){
    layer.beginDraw();
    layer.clear();
    //layer.background(0);
    layer.pushMatrix();
    layer.shapeMode(CENTER);
    layer.translate((w/2),(h/2));
    layer.rotate(radians(rotation));
    layer.shape(this.shape, x, y, w, h);
    layer.popMatrix();
    layer.endDraw();
  }
  
  void display(Movie movie) {
    float w = (this.width*this.scale);
    float h = (this.height*this.scale);
    this.updateLayer();
    if(hasBG)  { displayBG(); }
    
    //mask our video with our shape & display it
    if(movie.width >= this.width) {
      movie.mask(this.mask);
      image(movie,(this.x+this.offX),(this.y+this.offY),w,h);
      g.removeCache(movie);
    }
  }
  
  void displayBG() {
    super.display();
  }

}