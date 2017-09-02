class AnimatedText extends AnimatedObject {
  String newline = System.getProperty("line.separator");
  PGraphics win;
  String text;
  int lines;
  int fontSize;
  float fontX, fontY;
  int alignX, alignY;
  float textWidth, textHeight;
  int aniDirection = -1;
  float offPos_X, offPos_Y;
  float endPos_X, endPos_Y;
  PFont font;
  
 //public static final int NONE = 0, REVEAL_UP = 1, REVEAL_DOWN = 2, REVEAL_LEFT = 3, REVEAL_RIGHT = 4;
  
  AnimatedText (String text, PFont font, int fS, color C, int x, int y, int aX, int aY) {
    super(x,y,0,0); 
    this.font = font;
    this.fontSize = fS;
    
    //setDefault TextAlignment
    this.alignX = aX;
    this.alignY = aY;
    
    this.setColor(C);
    this.setText(text);
  }
  void setText(String text){
    //split the Text in multiple Lines & count lines
    String[] splitText = text.split("_");
    this.lines = splitText.length;
    this.text =String.join(newline, splitText);
    
    //fetch longest String in array
    int index = 0; 
    int elementLength = splitText[0].length();
    for(int i=1; i < this.lines; i++) {
        if(splitText[i].length() > elementLength) {
            index = i; elementLength = splitText[i].length();
        }
    }
    //calculate textWidth & textHeight
    textFont(this.font, this.fontSize);
    this.textWidth = (textWidth(splitText[index]));
    this.textHeight = (this.lines > 1)?  (this.lines * this.textLead() + textAscent() + textDescent()):(textAscent() +textDescent());
    
    win = createGraphics((int)this.textWidth, (int)this.textHeight);
    
    this.endPos_X = ((this.alignX == RIGHT)?(this.textWidth):((this.alignX == CENTER)?(0.5*this.textWidth):0));
    this.endPos_Y = ((this.alignY == BOTTOM)?(this.textHeight):((this.alignY == CENTER)?(this.textHeight*0.5):0));
    
    if(this.aniDirection < 0 ){
        this.fontX = this.endPos_X;
        this.fontY = this.endPos_Y;   
    } else {
      this.setOffsetPosition();
    }
     
  }
  float textLead() {
    return g.textLeading;
  }
  void initAnimation (int direction){
    this.aniDirection = direction;
    this.setOffsetPosition();
  }
  
  void setOffsetPosition() { 
    float offX = 0, offY = 0;
    switch(this.aniDirection) {
      case RIGHT:  offX = this.textWidth; break;
      case LEFT:   offX = (-this.textWidth); break;
      case BOTTOM: offY = (-this.textHeight); break;
      case TOP:    offY = this.textHeight; break;
      default: offX = 0; offY = 0;
    }
    
    this.fontX = this.offPos_X = this.endPos_X + offX;
    this.fontY = this.offPos_Y = this.endPos_Y + offY;
  }
  
  void setAlign(int alignX) {
    this.alignX = alignX;
  }
  
  void setAlign(int alignX, int alignY) {
    this.alignX = alignX; this.alignY = alignY;
  }

  void display() {
    try {
      super.display();
    
      win.beginDraw();
      win.clear();
      win.noStroke();
      win.fill(123,123,123);
      //win.strokeWeight(4);
      //win.stroke(255,255,255);
      win.rect(0,0,this.textWidth, this.textHeight);
      win.fill(this.fillColor);
      win.textAlign(this.alignX,this.alignY);
      win.textFont(font, this.fontSize);
      win.text(this.text, this.fontX, this.fontY);
      win.endDraw();    
      image(win, this.x, this.y);
      g.removeCache(win);
    }
    catch(NullPointerException e){
      println(e.getMessage());
    }
  }
  
}