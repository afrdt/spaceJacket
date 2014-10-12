import oscP5.*;
import netP5.*;
import processing.serial.*;
import java.util.*;
//int count;
//int sz;
Serial myPort;  // Create object from Serial class
int val;      // Data received from the serial port
OscP5 oscP5;
NetAddress myRemoteLocation;

void setup()
{
  size(200, 200);
  println(Serial.list());
  String portName = Serial.list()[5];
  myPort = new Serial(this, portName, 9600);
  oscP5 = new OscP5(this, 57120);
  // set the remote location to be the localhost on port 5001
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);
//  count = 0;
//  sz = 4;
}

void draw()
{
  if ( myPort.available() > 0)
  { 
    // If data is available,
    String inBuffer = myPort.readString();
    List<String> values = Arrays.asList(inBuffer.split(","));
    if (  values.get(0).isEmpty() &&
      values.get(1).isEmpty() &&
      values.get(2).isEmpty() &&
      values.get(3).isEmpty() )  
    {
      return;
    };


    //   if (count%sz==0)
    //   {
    //    count = 0;   
    OscMessage myMessage = new OscMessage("/jacket");
    for ( int i=0; i< values.size (); i++ )
    {
      myMessage.add(values.get(i));
    }
    // send the message
    oscP5.send(myMessage, myRemoteLocation);
  }
  //   count+=1;
  //  }
}

