// This code has been adapted from the One Week of Carsharing in Milan Project
// Author: Daniele Ciminieri, others
// https://github.com/fenicento/carSharing_paths

import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.data.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.core.Coordinate;
import de.fhpotsdam.unfolding.providers.*;
import java.util.List;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.text.SimpleDateFormat;
import java.text.ParseException;

SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
SimpleDateFormat hour = new SimpleDateFormat("h:mm a", Locale.ENGLISH);
SimpleDateFormat day = new SimpleDateFormat("MMMM dd, yyyy", Locale.ENGLISH);
SimpleDateFormat weekday = new SimpleDateFormat("EEEE", Locale.ENGLISH);

UnfoldingMap map;

List<Marker> transitMarkers = new ArrayList<Marker>();
List<Marker> addedMarkers = new ArrayList<Marker>();
List<Marker> newMarkers = new ArrayList<Marker>();
List<Car> addedCars = new ArrayList<Car>();
List<Car> newCars = new ArrayList<Car>();
MarkerManager<Marker> markerManager;
color c = color(232, 193, 2, 15);

Date starttime=new Date();
Date stoptime=new Date();
List<Date> starts = new ArrayList<Date>();
List<Date> ends = new ArrayList<Date>();

Date start = new Date();
Date end = new Date();
List<Feature> transitLines;

List<String> modes = new ArrayList<String>();
String mode;
int zoom;

PImage clock; 
PImage calendar;
PImage airport;
PFont raleway;
PFont raleway2;

void setup() {
  frameRate(30);
  size(800, 600, OPENGL);
  smooth();
  
  transitLines = GeoJSONReader.loadData(this, "../data/output.geojson");
  for (Feature feature : transitLines) {
    try {
      start=format.parse(feature.getStringProperty("start"));
      end=format.parse(feature.getStringProperty("end"));
      mode = feature.getStringProperty("mode");
      modes.add(mode);
      
      starts.add(start);
      ends.add(end);
    }
    catch (ParseException e) {}
    println(start);
    println(end);
  }
    
  raleway  = createFont("Raleway-Heavy", 32);
  raleway2  = createFont("Raleway-Bold", 14);
  clock = loadImage("google_clock.png");
  clock.resize(0, 35);
  calendar = loadImage("google_calendar.png");
  calendar.resize(0,35);
  airport = loadImage("google_airport.png");
  airport.resize(0,20);
  
  map = new UnfoldingMap(this);
  markerManager = map.getDefaultMarkerManager();
  Location nyc = new Location(40.72, -74.0);  
  zoom = 11;
  map.zoomAndPanTo(nyc, zoom);
  MapUtils.createDefaultEventDispatcher(this, map); // adds interactivity to the map

}

void draw() {
  map.draw();
  fill(0,100);
  rect(0,0,width,height);
  
    newMarkers.clear();
    newCars.clear();

    Iterator<Marker> i = addedMarkers.iterator();
    Iterator<Car> z = addedCars.iterator();
    Iterator<Feature> j = transitLines.iterator();

    //************************
    while (j.hasNext ()) {
      Feature f = j.next(); // must be called before you can call i.remove()
      if (f.getStringProperty("start")=="") {
        j.remove();
      }
    }
    //************************


    //****************************
    while (i.hasNext ()) {
      Marker s = i.next(); // must be called before you can call i.remove()
      Date currend=new Date();
      try {
        currend=format.parse(s.getStringProperty("end"));
      }
      catch (ParseException e) {
        println("end");
        println(e);
      }
      if (currend.before(start)) {
        markerManager.removeMarker(s);
        i.remove();
      }
    }
    //*****************************

    while (z.hasNext ()) {
      Car c = z.next(); // must be called before you can call i.remove()
      if (c.en.before(start)) {
        z.remove();
      }
    }


    for (Feature feature : transitLines) {

      Date curr=new Date();
      if (feature.getProperty("start")!="") {
        try {
          curr=format.parse(feature.getStringProperty("start"));
        }
        catch (ParseException e) {
          println("start");
          println(e);
        }

        if (curr.before(start)) {

          ShapeFeature lineFeature = (ShapeFeature) feature;
          SimpleLinesMarker m = new SimpleLinesMarker(lineFeature.getLocations());
          m.setColor(c);
          List<PVector> vecs = getPixelPos(m);
          HashMap<java.lang.String, java.lang.Object> props = feature.getProperties();
          props.put("vecs", vecs);
          m.setProperties(props);
          m.setStrokeWeight(0);
          Car c = new Car(vecs, m.getStringProperty("start"), m.getStringProperty("end"));
          
          feature.putProperty("start", "");
          addedMarkers.add(m);
          newMarkers.add(m);
          addedCars.add(c);
          newCars.add(c);

        } else {
          break;
        }
      }
    }
    map.addMarkers(newMarkers);
    for (int x=0; x < addedCars.size(); x++){
      Car c = addedCars.get(x);
      String mode = modes.get(x);
      
      if (mode.equals("driving") == true){
        fill(30,144,255); // blue
        c.draw();
        //map.draw();
      } else if (mode.equals("transit") == true) {
        fill(255,0,0); // red
        c.draw();
        //map.draw();
      } else if (mode.equals("bicycling") == true) {
        fill(0,255,0); // green
        c.draw();
        //map.draw();
      } else if (mode.equals("walking") == true) {
        fill(255,255,255); // white
        c.draw();
        //map.draw();
      }
    
    }
    start = new Date(start.getTime() + TimeUnit.SECONDS.toMillis(18));
        
    textSize(32);
    //map.draw();
    
    fill(255, 255, 255, 255);
    image(clock, 30, 25);
    stroke(255, 255, 255, 255);
    line(30,70,200,70);
    image(calendar, 30, 80 );
    textFont(raleway);
    noStroke();
    text(hour.format(start), 75, 55);
    
    textFont(raleway2);
    text(day.format(start), 80, 95);
    text(weekday.format(start), 80, 115);
    
  Location JFK = new Location(40.65561, -73.80754);
  Location LGA = new Location(40.773153, -73.872257);
  Location EWR = new Location(40.69348, -74.18711);
  
     
  // Create point markers for locations
  image(airport, map.getScreenPosition(JFK).x, map.getScreenPosition(JFK).y);
  image(airport, map.getScreenPosition(LGA).x, map.getScreenPosition(LGA).y);
  image(airport, map.getScreenPosition(EWR).x, map.getScreenPosition(EWR).y);
  
  fill(255,255,255);
  textFont(raleway, 14);
  
  text("JFK", map.getScreenPosition(JFK).x-2, map.getScreenPosition(JFK).y+32);
  text("LGA", map.getScreenPosition(LGA).x-2, map.getScreenPosition(LGA).y-5);
  text("EWR", map.getScreenPosition(EWR).x-5, map.getScreenPosition(EWR).y+32);
  
  fill(30,144,255);
  ellipse(45, 180, 20, 20);
  fill(255,255,255);
  ellipse(45, 180, 8, 8);
  fill(255,255,255);
  textFont(raleway2);
  text("Car", 65, 185);
  
  fill(255,0,0);
  ellipse(45, 220, 20, 20);
  fill(255,255,255);
  ellipse(45, 220, 8, 8);
  fill(255,255,255);
  textFont(raleway2);
  text("Transit", 65, 225);
  
  fill(200,200,200);
  textFont(raleway2);
  text("Source: Google Maps Directions API", 20, 580);
  
  fill(200,200,200);
  textFont(raleway2);
  text("@wgeary", width-100, 580);
    
  //saveFrame("frames/frame-######.png");

}


public List<PVector> getPixelPos(SimpleLinesMarker m) {
  List<PVector> vecs = new ArrayList<PVector>();
  List<Location> locs = m.getLocations();
  for (Location l : locs) {
    PVector p = map.mapDisplay.getScreenPosition(l);
    vecs.add(p);
  }
  return vecs;
}