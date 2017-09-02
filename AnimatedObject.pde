import de.looksgood.ani.easing.*;

class AnimatedObject {
    color fillColor;
    color strokeColor;
    Ani animation;

public int x, y, 
           width, height, borderWidth = 0;
public float scale = 1.0, rotation = 0.0;

  AnimatedObject(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.width = w;
    this.height = h;
    this.animation = new Ani(this, 0, "", 0, Ani.LINEAR);
  }
  Ani[] setAnimation(float dur, float offset, String propertylist, Easing easing){
     return animation.to(this, dur, offset, propertylist, easing);
  }
  
  void setRotation(int r){
    this.rotation = r;
    this.update();
  }
  void setScale(float sc){
    this.scale = sc;
    this.update();
  }
  
  void setBorder(color sC, int bW){
    this.strokeColor = sC;
    this.borderWidth = bW;
    this.update();
  }
  
  void setColor( color fC) {
    this.fillColor = fC;
    this.update();
  }
  void update() {
  }
  
  void display() {
  }
}