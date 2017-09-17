class TeaserList {
  ArrayList<Teaser> teasers;
  int length;
  
  TeaserList(String file) {
    this.teasers = new ArrayList<Teaser>();
    this.loadTeaser(file);
  }
  
  void loadTeaser(String file) {
    Table table = loadTable(dataPath(file), "header");
  
    this.length = table.getRowCount(); 
    Teaser tempTeaser;
    String[] fields = { "day", "time", "location", "headline", "subheadline", "type", "filename"};
  
    for (TableRow row : table.rows()) {
      tempTeaser = new Teaser(row, fields);
      this.teasers.add(tempTeaser);
    }     
  }
  
  Teaser get(int index) {
    return this.teasers.get(index); 
  }
  
}