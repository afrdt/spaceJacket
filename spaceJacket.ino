/*
 * Capacitive sensing jacket at E-Textiles Live Lab @Schmiede
 * September 2014
 *
 * Afroditi Psarra
 */

#include <CapacitiveSensor.h> // include CapSense library
CapacitiveSensor particles = CapacitiveSensor(12,14); // 3.3M resistor between pins 12 & 14 (A0), pin 14 is the sensor pin
CapacitiveSensor matter = CapacitiveSensor(10,11); // 3.3M resistor between pins 10 & 11, pin 11 is the sensor pin
CapacitiveSensor galaxies = CapacitiveSensor(7,8); // 3.3M resistor between pins 7 & 8, pin 8 is the sensor pin
CapacitiveSensor expansion = CapacitiveSensor(5,6); // 3.3M resistor between pins 5 & 6, pin 6 is the sensor pin

void setup() {
//  matter.set_CS_AutocaL_Millis(0xFFFFFFFF);     // turn off autocalibrate on channel 1 - just as an example
  Serial.begin(9600);
}

void loop() {
  //long start = millis();
 unsigned long particlesVal =  particles.capacitiveSensor(30);
 unsigned long matterVal = matter.capacitiveSensor(30);
 unsigned long galaxiesVal = galaxies.capacitiveSensor(30);
 unsigned long expansionVal = expansion.capacitiveSensor(30);

  //    Serial.print(millis() - start);        // check on performance in milliseconds
  //    Serial.print("\t");                    // tab character for debug windown spacing
  
//  Serial.print("[");
 String msg = String(particlesVal) +","+String(matterVal)+","+String(galaxiesVal)+","+String(expansionVal);
 Serial.println(msg);
//  Serial.print(particlesVal);                  // print capacitive sensor output
//  Serial.print(",");
//  Serial.print(matterVal);                 // print sensor output
//  Serial.print(",");
//  Serial.print(galaxiesVal);            // print sensor output
//  Serial.print(",");
//  Serial.println(expansionVal);           // print sensor output
//  Serial.println("]");

  //delay(1);                             // arbitrary delay to limit data to serial port 
}
