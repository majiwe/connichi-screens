class Videolayer extends AnimatedObject {
  PGraphics mask, background;
  PShape shape;
  boolean hasBG;
  int startX, startY, endX, endY;
  int offX, offY;

  Videolayer(PShape s, int x, int y, int w, int h) {
    super(x,y,w,h);
    this.shape = s;
    this.fillColor = color(0,0,0);
    mask = createGraphics(this.width, this.height);
  }
  
  void updateLayer(){
    this.setupLayer(this.mask, 0, 0, this.width, this.height, this.rotation);
    
    if(hasBG) {
      this.background.fill(this.fillColor);
      this.setupLayer(this.background, this.offX, this.offY, this.width, this.height, this.rotation);
    }
  }
  
  void setupBackground(int off_x, int off_y){
    this.hasBG = true; this.offX = off_x; this.offY = off_y;
    background = createGraphics(this.width, this.height);
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
 //   layer.rotate(radians(-rotation));
 //   layer.translate(-(w/2),-(h/2));
    layer.popMatrix();
    layer.endDraw();
  }
  
  void display(Movie movie) {
    float w = (this.width*this.scale);
    float h = (this.height*this.scale);
    this.updateLayer();
    if(hasBG)  {
      image(this.background, this.x,this.y,w,h);
      g.removeCache(this.background);
    }
      //mask our video with our shape & display it
    if(movie.width >= this.width) {
      movie.mask(this.mask);
      image(movie,this.x,this.y,w,h);
      g.removeCache(movie);
    }
  }

}