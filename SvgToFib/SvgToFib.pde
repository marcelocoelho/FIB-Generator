/* //////////////////////////////////////////////////////////////////////

  Marcelo Coelho + Rehmi Post
  Septmber 23, 2012
  MIT Media Lab
  
  Processing application for transforming SVG files into FIB pattern.
  
  It only scans for simple lines in SVG and ignores paths and polylines.

////////////////////////////////////////////////////////////////////////*/

XMLElement xml;
PrintWriter output;

// Some set-up variables
float Depth = 0.500000;
float EtchingRate = 0.15;
float Current = 1000; // pA 
float Time;

float scaling = 1;

void setup() {
  size(200, 200);
  
  String loadPath = selectInput();  // Opens file chooser
    if (loadPath == null) {
      // If a file was not selected
      println("No file was selected...");
    } else {
      // If a file was selected, print path to file
      println(loadPath);
    }  
  
  
  // LOAD FILES AND OPEN WRITER
  xml = new XMLElement(this, loadPath);
  int numSites = xml.getChildCount();
  
  // EXTRACT FILE NAME
  String[] fullPath = split(loadPath, '/');                     //split path
  String[] filename = split(fullPath[fullPath.length-1], '.');  //split filename

  // USE FILENAME TO CREATE OUTPUT FILE
  output = createWriter("data/"+filename[0]+".pat"); 
  
  // WRITE FIB HEADER
  output.println("[Pattern_Summary]");
  output.println("Version=2.00");
  output.println("Patterns="+numSites);  
  


  for (int i = 0; i < numSites; i++) {
    XMLElement kid = xml.getChild(i);
    
    float x1 = kid.getFloat("x1") * scaling;
    float x2 = kid.getFloat("x2") * scaling;
    float y1 = kid.getFloat("y1") * scaling;
    float y2 = kid.getFloat("y2") * scaling;    

 
  	output.println("[Pattern_"+(i+1) + "]"); 
  	output.println("Name=Line");
  
  

  	output.println("L="+getLength(x1,x2,y1,y2));          // Line length
  
  	output.println("Angle="+getAngle(x1,x2,y1,y2));		// Line Angle
  
  	output.println("CenterX="+(x1+x2)/2);					// Center X of Line
  
  	output.println("CenterY="+(y1+y2)/2); 				 // Center Y of Line 


  	// FOOTER PER LINE
  	output.println("Type=2");    
  	output.println("Beam=1");
        output.println("MaterialFile=None");
  	//output.println("MaterialFile=c:\\xp\\Pattern\\si.mtr");
  	output.println("Depth="+ Depth);
  	output.println("Dwell=0.001000000");
  	output.println("Overlap=99.000000");

	
  Time = getLength(x1,x2,y1,y2) * 0.02 * Depth * 1000 / EtchingRate / Current;
  output.println("Time=" + Time);

  output.println("GIS=0");
  output.println("EPD=0");
  output.println("Rotation=0.000000");


  output.println("PixelsPerMicron=16.168421");  

  }


  // CLOSE FILE
  output.flush(); // Writes the remaining data to the file
  output.close(); // Finishes the file
  println("DONE!");
  exit(); // Stops the program


}


float getAngle(float _x1, float _x2, float _y1, float _y2) {
  float angleInRadian = atan2(_y2-_y1, _x2-_x1);
  float angleInDeg = degrees(angleInRadian);
  
  return angleInDeg;
  
}


float getLength(float _x1, float _x2, float _y1, float _y2) {
  float lineLength = sqrt((_x2-_x1)*(_x2-_x1)+(_y2-_y1)*(_y2-_y1));
    
  return lineLength;
  
}





