#include <EEPROM.h> // functions to read and write eeprom
#include <Wire.h>
#include <LCDi2cNHD.h> // include the library code:
#include "config.h"
#include <Encoder.h>

//____________________declare variables_____________________________
// define the LCD address is 0x50>>1 which equals 0x28 NEWHEAVEN
LCDi2cNHD lcd = LCDi2cNHD(2,16,0x50>>1,0);



Encoder myEnc(EncoderA, EncoderB);

int amountmenuitems=11;
char menuitems[11][19] = {"evac.program      ",  //0
                     "evac.target       ",  //1
                     "max.evac.time     ",  //2
                     "rot.center        ",  //3
                     "needle.in         ",  //4
                     "needle.out        ",  //5
                     "max.bad.in.row    ", //6
                     "flush.air.time    ", //7
                     "flush.gas.time    ", //8
                     "pre.flush.air     ", //9
                     "back.start.program"};//10
                      
int defaultvalues[11]={0,   //evac.program
                      55,   //evac.target
                      180,  //max.evac.time
                      0, //rot.servo.center
                      1000, //needle.servo.in
                      2000, //needle.servo.out
                      5,    //max.bad.in.row
                      5,   //flush.air.time
                      5,   //flush.gas.time
                      0 }; // pre-flush with air

char menuOptions[3][19] = {
                     "Save setting      ",  //0
                     "Test setting      ",  //1
                     "Dont save setting "};  //2


int evacprogram;
int evactarget;
int maxevactime;  
int rotcenter;
int needlein;
int needleout;
int maxbadinrow;
int flushairtime;
int flushgastime;
int preflushair;

int rotbitleft;
int rotbitright;
int rotdropbad;
int rotdropgood;
int halfevactarget;
int rotposnow;

//vacuum gauge
float runavgvac=1023.0; // running average of pwm needed for therm
unsigned long timelastvacread=millis();
float vacstart=1023.0;
float vacpercnow=100.0;
float tempfloat;

int tempint; // reusable temporary variable

long oldPosition=0;
long newPosition=0;
int encoderPressed=0;
int encoderChanged=0;
long timeLastPosition=millis();

int counter; 
unsigned long startMillis = millis();
unsigned long curMillis;  
unsigned long startMillis2= millis();

int tubegood=0;
int curposus=0;
int badinrow=0;


//---------------------------------------------------------------------------------------------
//______________________________ MAIN PROGRAM__________________________________________________
//---------------------------------------------------------------------------------------------
void setup() {
  delay(150); // let the chip stabilize
  pinMode(thermpin, INPUT);
  pinMode(vacvpin, OUTPUT);      // sets the digital pin as output
  pinMode(gasvpin, OUTPUT);      // sets the digital pin as output
  pinMode(airvpin, OUTPUT);      // sets the digital pin as output
  pinMode(needlepowerpin, OUTPUT);    // sets the digital pin as output
  pinMode(needlecontrolpin, OUTPUT);    // sets the digital pin as output
  
  pinMode(rotenpin, OUTPUT);    // sets the digital pin as output
  pinMode(rotdirpin, OUTPUT);    // sets the digital pin as output
  pinMode(rotsteppin, OUTPUT);    // sets the digital pin as output
  pinMode(optopin, INPUT);    // sets the digital pin as input

  digitalWrite(vacvpin, LOW);     // sets the digital pin low
  digitalWrite(gasvpin, LOW);     // sets the digital pin low
  digitalWrite(airvpin, LOW);     // sets the digital pin low
  digitalWrite(needlepowerpin, LOW);   // sets the digital pin low
  digitalWrite(needlecontrolpin, LOW);   // sets the digital pin low
  
  digitalWrite(rotenpin, HIGH);      // sets the digital pin high (inverted input)
  digitalWrite(rotdirpin, LOW);      // sets the digital pin low
  digitalWrite(rotsteppin, LOW);      // sets the digital pin low
  
  pinMode(EncoderPress, INPUT);    // sets the digital pin as input
  digitalWrite(EncoderPress, HIGH);      // sets pull-up of the digital pin high
  digitalWrite(optopin, LOW);      // sets pull-up of the digital pin high

  oldPosition = myEnc.read();
  newPosition = myEnc.read();
  
  //start the LCD
  lcd.init();                     // Init the display, clears the display
  lcd.setDelay (100,1);
  delay(100);
  printwelcome();
                      
  evacprogram=readinteeprom(firsteepromaddress+2*0);
  evactarget=readinteeprom(firsteepromaddress+2*1);
  maxevactime=readinteeprom(firsteepromaddress+2*2);  
  rotcenter=readinteeprom(firsteepromaddress+2*3);
  needlein=readinteeprom(firsteepromaddress+2*4);
  needleout=readinteeprom(firsteepromaddress+2*5);
  maxbadinrow=readinteeprom(firsteepromaddress+2*6);
  flushairtime=readinteeprom(firsteepromaddress+2*7);
  flushgastime=readinteeprom(firsteepromaddress+2*8);
  
  rotbitleft= rotcenter-rotshake;
  rotbitright= rotcenter+rotshake;
  rotdropgood= rotcenter+rotdrop;
  rotdropbad= rotcenter-rotdrop;
  halfevactarget= (100-(100-evactarget)/2);
  
  allhome();
}


void loop() {
  if (preflushair>0) { // if helium or hydrogen is attached do pwmzero in air
    flushlines();
    pwmzero();  
  }
  if (evacprogram!=0) { //if temperature of vacuum sensor is ok
      stirandgrab(); // grab tube and put needle in    
      
      if (evacprogram==1)  {
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(evactarget);          
      }
      else if (evacprogram==2) {
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(evactarget);
          flushair();
          evacuate(evactarget);
      }
      else if (evacprogram==3) {
          flushair();
          if (preflushair<1){ pwmzero(); }        
          evacuate(halfevactarget);
          flushair();
          evacuate(evactarget);
      }
      else if (evacprogram==4) {
          flushair();
          if (preflushair<1){ pwmzero(); }        
          evacuate(halfevactarget);
          flushair();
          evacuate(halfevactarget);
          flushair();
          evacuate(evactarget);
      }
      else if (evacprogram==5) {
          flushgas();
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(evactarget);
      }
      else if (evacprogram==6) {
          flushgas();
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(evactarget);
          flushgas();
          flushair();
          evacuate(evactarget);
      }    
      else if (evacprogram==7) {
          flushgas();
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(halfevactarget);
          flushgas();
          flushair();
          evacuate(evactarget);
      }  
      else if (evacprogram==8) {
          flushgas();
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(halfevactarget);
          flushgas();
          flushair();
          evacuate(halfevactarget);
          flushgas();
          flushair();
          evacuate(evactarget);
      }  
       else if (evacprogram==9) {
          flushair(); 
          if (preflushair<1){ pwmzero(); }
          evacuate(evactarget);
          flushgas();
          flushair();
      }       
       else if (evacprogram==10) {
          flushgas();
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(evactarget);
          flushgas();
          flushair();
      }   
      else if (evacprogram==11) {
          flushgas();
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(halfevactarget);
          flushgas();
          flushair();
          evacuate(evactarget);
          flushgas();
          flushair();
      } 
      
      else if (evacprogram==12) {
          flushgas();
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(evactarget);
          flushgas();
      } 
      else if (evacprogram==13) {
          flushgas();
          flushair();
          if (preflushair<1){ pwmzero(); }
          evacuate(halfevactarget);
          flushgas();
          flushair();
          evacuate(evactarget);
          flushgas();
      }    
      
      // ADD MORE PROGRAMS HERE

      else {
         lcd.clear(); 
         lcd.setCursor(0, 0);
         lcd.print("Program unknown"); 
         delay(5000);       
         emergencystop();
      }   
      drop();  // drop tube 
  }
  else if (evacprogram==0) {

  }  
  else if (evacprogram==20) {
        digitalWrite(airvpin,HIGH);
        pausems(flushlinetime);
        digitalWrite(airvpin,LOW);
        
        digitalWrite(vacvpin,HIGH);
        pausems(flushlinetime);
        digitalWrite(vacvpin,LOW);

        digitalWrite(gasvpin,HIGH);
        pausems(flushlinetime);
        digitalWrite(gasvpin,LOW);  
        pausems(2000);       

  }
  readvacuum();
  printpwminfo();  // show current temperature
  delay(50); 
}

//------------------------------------------------------------------------------------------------
//___________________________SUB-ROUTINES_________________________________________________________
//------------------------------------------------------------------------------------------------
void readvacuum()
{
  tempint=analogRead(thermpin);
  tempfloat=tempint;
  tempfloat=tempfloat/10.0;
  runavgvac=runavgvac*0.9;
  runavgvac=runavgvac+tempfloat;
}

// Convert ADC value to key number

void checkkeys()
{
  if (millis()>timeLastPosition+20){
      newPosition = myEnc.read();
      if (newPosition>oldPosition+1){
          oldPosition = newPosition;
          encoderChanged=1;
       }
       else if (newPosition<oldPosition-1){
           oldPosition = newPosition;
           encoderChanged=-1;
       }
       else {
            encoderChanged=0;    
       }
          
      if (digitalRead(EncoderPress)==0){
          encoderPressed=1;
          delay(200);
      }
      else {
          encoderPressed=0;
      }
   }
   else{
     encoderChanged=0;
     encoderPressed=0;
   } 
}


void printwelcome()
{ 
  if (readinteeprom(eepromisfirstrun)!=firstruncheck){
    lcd.print("FIRSTRUN");  // Print a message to the LCD.
    delay(5000);  
    writeinteeprom(eepromisfirstrun,firstruncheck);
    for (tempint = 0; tempint < amountmenuitems; tempint++) {
      writeinteeprom(firsteepromaddress+tempint*2,defaultvalues[tempint]);
    }
    lcd.clear();
  }
  
  lcd.setCursor(0, 0);
  lcd.print("TR-1200B   ");  // Print a message to the LCD.
  lcd.setCursor(1,0);
  lcd.print("press for setup");
  
  startMillis=millis();
  while (millis() < (startMillis+4000)) {
       checkkeys(); 
       if (encoderPressed >0){ 
          lcd.clear(); 
          lcd.setCursor(0, 0);
          lcd.print("Entering Setup");
          delay(1000);
          setupmenu();
       }
  }
  lcd.clear();
  delay(50); 
}

void setupmenu()
{
  int setupitem=0;
  mainmenu:
  lcd.clear(); 
  lcd.setCursor(0, 0);
  lcd.print("CHOOSE ITEM ");
  int itemselected=-1;
  while (itemselected<0){
     checkkeys(); 
     if (encoderChanged==1){
       setupitem=setupitem+1;
     }
     if (encoderChanged==-1){
       setupitem=setupitem-1;
     }
     if (encoderPressed==1){
       itemselected=1;
     }
     
 
     lcd.setCursor(1,0);
     if (setupitem<0) setupitem=amountmenuitems-1;
     else if (setupitem>amountmenuitems-1) setupitem=0; 
     lcd.print(menuitems[setupitem]);
     lcd.setCursor(0, 14);
     lcd.print(setupitem);
     lcd.print(" ");
    
  }
  if (itemselected>-1){
    if (setupitem==amountmenuitems-1){ //last item is to start program
         lcd.clear();           
         lcd.setCursor(0, 0);
         lcd.print("exiting setup");              
         lcd.setCursor(1,0);
         lcd.print("starting program");             
         delay(1500);
         return;
     }
     int tempvalue=readinteeprom(firsteepromaddress+setupitem*2);
     int adjstep=1;
     if (setupitem==3 | setupitem==4 | setupitem==5) {
       adjstep=10;
     }
     
     submenu:   
     lcd.clear();
     lcd.setCursor(0, 0);
     lcd.print(menuitems[setupitem]);
     int done=-1;
     while (done<0){
         checkkeys(); 
         lcd.setCursor(1,0);
         lcd.print(tempvalue); 
         lcd.print("    "); 
         checkkeys(); 
         if (encoderChanged==1){
            tempvalue=tempvalue+1*adjstep;
         }
         if (encoderChanged==-1){
            tempvalue=tempvalue-1*adjstep;
         }
         if (encoderPressed==1){
            done=1;
         }
     }
     
     done=-1;
     int menuOption=0;
     while (done<0){
         checkkeys();
         lcd.setCursor(1,0);
         lcd.print(menuOptions[menuOption]); 
         lcd.print("    ");
          if (encoderChanged==1){
            menuOption=menuOption+1;
         }
         if (encoderChanged==-1){
            menuOption=menuOption-1;
         }
         if (menuOption>2) menuOption=0;
         if (menuOption<0) menuOption=2;
         if (encoderPressed==1){
            done=1;
         }
     }
     // if to be saved
     if (menuOption==0){
          writeinteeprom(firsteepromaddress+setupitem*2,tempvalue); 
          lcd.clear();
          lcd.setCursor(0,0);
          lcd.print("value saved");           
     }
     //test setting
     else if (menuOption==1){
         if (setupitem==4 | setupitem==5 ) { //needlepositions
            lcd.setCursor(1,6);
            lcd.print("moving");              
            moveneedle(tempvalue);    
            lcd.setCursor(1,6);
            lcd.print("       ");         
         }
         if (setupitem==3 ) { //rotation center
            lcd.setCursor(1,6);
            lcd.print("moving");              
            rotate(tempvalue);    
            lcd.setCursor(1,6);
            lcd.print("       ");         
         }
         goto submenu;  
     }
     else {
         lcd.clear();
         lcd.setCursor(0,0);
         lcd.print("value not saved");       
     }
     delay(1000);
     goto mainmenu;  
  }
}



void printpwminfo()
{
  lcd.setCursor( 1, 0);
  lcd.print("P" ); 
  lcd.print(runavgvac);
  lcd.print(" ");  
  tempint=digitalRead(optopin);
  lcd.setCursor( 1, 8);
  lcd.print("opto: " ); 
  lcd.print(tempint);
  lcd.print(" ");  
}


void pwmzero()
{
  long templong=millis();
  
  while (millis()<templong+3000){
     readvacuum();
     delay(20);
  } 
  vacstart=runavgvac; 
}

void pausems(int pausetime)
{
    startMillis=millis();
    startMillis2=millis();
    printpwminfo(); 
    while (millis() < (startMillis+pausetime))  {
       if ((millis() -startMillis2)>251)  {
           printpwminfo();  // print info every 200ms 
           startMillis2=millis();
       }  
    }
}

//________________________________________________________________________________________
//--------------------------MOVES--------------------------------------------------------
//________________________________________________________________________________________

void allhome() 
{
  lcd.setCursor(0,0);
  lcd.print("moving home  ");
  moveneedle(needleout);  
  rotator2home(); 
  rotate(rotcenter);
}

void stirandgrab() 
{
 lcd.setCursor(0,0);
 lcd.print("stir and grab  ");
 rotate(rotbitleft);
 rotate(rotbitright);
 rotate(rotcenter);
 lcd.setCursor(1,0);
 lcd.print("needle in   ");
 moveneedle(needlein); 
}

void flushlines() 
{
  lcd.setCursor(0,0);
  lcd.print("flushing lines ");
  digitalWrite(airvpin,HIGH);
  digitalWrite(vacvpin,HIGH);
  pausems(flushlinetime);  
  digitalWrite(vacvpin,LOW);
  digitalWrite(airvpin,LOW);
}

void flushair() 
{
  lcd.setCursor(0,0);
  lcd.print("flushing air  ");
  digitalWrite(airvpin,HIGH);
  pausems(flushairtime*1000);  
  digitalWrite(airvpin,LOW);
}

void flushgas()
{
  lcd.setCursor(0,0);
  lcd.print("flushing gas  ");
  digitalWrite(gasvpin,HIGH);
  pausems(flushgastime*1000);  
  digitalWrite(gasvpin,LOW);
}

void evacuate(int target)
{
  lcd.setCursor(0,0);
  lcd.print("evacuating  ");
  digitalWrite(vacvpin,HIGH);

  tubegood=0;
  long millisstarted=millis();

  while ((millis()-millisstarted)/1000 < maxevactime){
     pausems(100);
     readvacuum();
     
     vacpercnow=runavgvac/vacstart*100;
     lcd.setCursor(0, 0);
     lcd.print(vacpercnow);
     lcd.print("% ");
     lcd.setCursor(0, 13);
     lcd.print((millis()-millisstarted)/1000);
     lcd.print("  ");
     if (vacpercnow<target)  {
       tubegood=1;
       break;
     }
     else if ((millis()-millisstarted)/1000> maxevactime/3)  {
        if (vacpercnow>80) break;
     }
     else if ((millis()-millisstarted)/1000> maxevactime/6)  {
        if (vacpercnow>95) break;
     }
  }
  digitalWrite(vacvpin,LOW); 
}

void drop()
{
  lcd.setCursor(0,0);
  lcd.print("needle out  ");
  moveneedle(needleout); 
  if (tubegood<1)  {
    rotate(rotdropbad);
    lcd.setCursor(0,0);
    lcd.print("Bad tube ");
    badinrow=badinrow+1;
    if (badinrow>maxbadinrow) emergencystop();
    delay(500); 
  }
  else  {
    lcd.setCursor(0,0);
    lcd.print("Good tube ");
    rotate(rotdropgood); 
    badinrow=0;
  }
  pausems(500);
  rotator2home();
  rotate(rotcenter); 
}

void emergencystop()
{
  digitalWrite(rotenpin,HIGH); //inverted
  lcd.clear();
  delay(150);
  while(0<1)   {
    lcd.setCursor(0,0);
    lcd.print("!!PROBLEM!!");
    lcd.setCursor(1,0);
    lcd.print("fix & reset me"); 
    delay(2000);  
  }  
}

void rotate( int target)
{  
  digitalWrite(rotenpin,LOW); //inverted
  digitalWrite(rotdirpin,LOW);
  while (target<rotposnow){
    digitalWrite(rotsteppin, HIGH);
    delayMicroseconds(1);
    digitalWrite(rotsteppin, LOW);
    delayMicroseconds(steptimeus);
    rotposnow=rotposnow-1;    
  }
  digitalWrite(rotdirpin,HIGH);
  while (target>rotposnow){
    digitalWrite(rotsteppin, HIGH);
    delayMicroseconds(1);
    digitalWrite(rotsteppin, LOW);
    delayMicroseconds(steptimeus);
    rotposnow=rotposnow+1;    
  }
  delay(50);
  digitalWrite(rotenpin,HIGH); //inverted
}

void rotator2home()
{
  long templong=millis();

  digitalWrite(rotenpin,LOW); //inverted
  digitalWrite(rotdirpin,LOW);
  while (digitalRead(optopin)==HIGH){
    if(millis()>templong+5000) emergencystop();
    digitalWrite(rotsteppin, HIGH);
    delayMicroseconds(1);
    digitalWrite(rotsteppin, LOW);
    delayMicroseconds(steptimeus);
  } 
  
  templong=millis();
  digitalWrite(rotdirpin,HIGH);
  while (digitalRead(optopin)==LOW){
    if(millis()>templong+5000) emergencystop();
    digitalWrite(rotsteppin, HIGH);
    delayMicroseconds(1);
    digitalWrite(rotsteppin, LOW);
    delayMicroseconds(steptimeus);
  }
  rotposnow=0;
  digitalWrite(rotenpin,HIGH); //inverted  
}

void moveneedle(int posus)
{    
    digitalWrite(needlepowerpin,HIGH);
    pausems(10);
    
    startMillis=millis();
    while (millis() < (startMillis+needlemovetime))     {
     noInterrupts(); // critical, time-sensitive code here so temporary disable interrupts
     digitalWrite(needlecontrolpin, HIGH);      // sets the digital pin high   
     delayMicroseconds(posus);
     digitalWrite(needlecontrolpin, LOW);      // sets the digital pin high
     interrupts(); //end of time-sensitive code so enable interrupts
     delay(16); 
    }
    digitalWrite(needlepowerpin,LOW);
}


// _____________________________________________________________________________________________________
//------------------EEPROM-------------------------------------------------------------------------------
//_______________________________________________________________________________________________________

void writeinteeprom(int address, int value)
{
  int a = value/256;
  int b = value % 256;
  EEPROM.write(address,a);
  EEPROM.write(address+1,b);
}

int readinteeprom (int address)
{
  int value;
  int a=EEPROM.read(address);
  int b=EEPROM.read(address+1);
  value = a*256+b; 
  return value;
}


