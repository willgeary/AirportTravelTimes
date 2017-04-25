class Car extends SimpleLinesMarker {

  List<PVector> vecs;
  float duration;
  float dist;
  List<Float> checks = new ArrayList<Float>();
  Date st;
  Date en;

  Car() {   
    super();
  };

  Car(List<PVector> v, String s, String e) {   
    vecs=v;
    try {
      st = format.parse(s);
      en = format.parse(e);
    }
    catch(Exception ex) {
      println(ex);
    }
    long lst = st.getTime();
    long len = en.getTime();
    duration = (len-lst);

    for (int i =0; i<vecs.size ()-1; i++) {
      float d = vecs.get(i).dist(vecs.get(i+1));
      dist+=d;
      checks.add(d);
    }
  };

  public String toString() {
    return "duration: "+duration/(1000*60)+" distance: "+dist+" checkPoints:"+vecs.size()+" times:"+checks.size();
  }

  public void draw() {

    long lstart = start.getTime();
    float passed = (lstart-st.getTime())/duration;
    float currdist = passed * dist; 
    //println("distance: "+dist+" curr distance: "+currdist+" passedPerc:"+passed);
    int n=0;
    float totdist=0;
    float diff = 0;
    for(int i = 0; i<checks.size(); i++) {
      totdist+=checks.get(i);
      if(currdist < totdist) {
        n=i-1;
        totdist-=checks.get(i);
        diff=currdist-totdist;
        break;
      }
    }
    float checkperc = diff/checks.get(n+1);    
    PVector middle = PVector.lerp(vecs.get(n), vecs.get(n+1), checkperc);
        
    noStroke();
    ellipse(middle.x,middle.y,10,10);
    
    fill(255, 255, 255, 255);
    ellipse(middle.x,middle.y,4,4);
  }
}