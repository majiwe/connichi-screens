class Teaser {
  String filePath;
  String headline;
  String subheadline;
  String location;
  String description;
  String time;
  String day;
  String type;  
  
  public Teaser (TableRow r, String[] f){
  
    this.day = r.getString(f[0]);
    this.time = r.getString(f[1]);
    this.location = r.getString(f[2]);
    this.headline = r.getString(f[3]);
    this.subheadline = r.getString(f[4]);
    this.type = r.getString(f[5]);
    this.filePath = r.getString(f[6]);
  }
  public boolean shouldPlay(){
    if (this.time != "off"){ 
       int teaserTime = (parseInt((this.time).replace(":","")));
       String aktTime = ""+hour()+minute();
     
       if (teaserTime < parseInt(aktTime)){
         return false; 
       }
     }
       return true;
   }
}