class AnimatedShapes extends AnimatedObject {
  PShape shape;
  color strokeColor;
  Ani animation;

  AnimatedShapes(PShape s, int x, int y, int w, int h) {
    super(x,y,w,h);
    this.shape = s;
    this.shape.disableStyle();
    shapeMode(CENTER);
    this.animation = new Ani(this, 0, "", 0, Ani.QUINT_IN_OUT);
  }
  
  void display() {
    super.display();
    pushMatrix();
    translate((this.x+(this.height/2)), (this.y+(this.width/2)));
    rotate(radians(this.rotation));
    fill(this.fillColor);
    scale(this.scale);
    shape(this.shape,0,0, this.height, this.width);
    popMatrix();
  }
}