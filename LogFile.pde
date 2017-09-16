class LogFile {
  String name;
  PrintWriter logfile;
  
  LogFile(String n){
    this.name = n;
     logfile = createWriter(dataPath("log/"+name+"-log.txt"));
  }
  
  void write(String data) {
    this.logfile.println(this.name+": "+data);
    this.logfile.flush();
  }
}