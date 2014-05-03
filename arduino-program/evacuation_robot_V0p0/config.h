//______________________PINS________________________________

const int thermpin =2; // pin for analog-in of supply voltage to thermistor vacuum gauge

const int vacvpin =7;  // pin to MOSFET for vacuum valve
const int airvpin =5; //pin to MOSFET for air vent valve
const int gasvpin =6; // pin to MOSFET for gas valve
const int needlepowerpin =8; //pin to mosfet for needle actuator
const int needlecontrolpin =9; //pin to mosfet for needle actuator

const int rotenpin =13 ; //pin to enable rotator stepper
const int rotdirpin=11 ; //pin to set direction rotator stepper
const int rotsteppin=12 ; //pin to step rotator stepper

const int optopin=10 ; //pin for opto-endstop

const int EncoderA=3;
const int EncoderB=4;
const int EncoderPress=2;

const int lcdsdapin=4; // lcd sda pin (analog 4)
const int lcdsclpin=5; // lcd scl pin (analog 5)

const int rotdrop=11000 ; //steps from center to drop
const int rotshake=5000 ; //steps from center to drop
// (16 microsteps*200=3200steps/rot, gearing is 1/3, so 9600 steps/rot, 2700 steps=105 deg
const int steptimeus=75 ;  //in microseconds: 9600steps/rot, rot in 3 seconds ->3200steps/second -> 1,000,000/3200=313
const int needlemovetime =2500; //time needed for the needle to move (ms)
const int flushlinetime = 1000; //time to flush the lines (vacuum and air open) (ms)
//____________________CONSTANTS__________________________________


const int firstruncheck=346;  //number used for uploading new defaults to eeprom change to replace values staored in eeprom

//________________EEPROM_ADDRESSES_______________________
// all values are stored as integer which need 2 bytes

const int firsteepromaddress=102;
const int eepromisfirstrun=100;



