/*
   BLE server that send data of the HX711 scale and Thermistor
*/
//Libraries
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "HX711.h"

//globals variables
BLEServer* pServer = NULL;
BLECharacteristic* HX7Characteristic = NULL;
BLECharacteristic* THERCharacteristic = NULL;
bool deviceCon = false;

// HX711 weight scale
float wei;
float mea;
const int LOADCELL_DOUT_PIN = 16;
const int LOADCELL_SCK_PIN = 17;
HX711 scale;

//Thermistor
const int ThermistorPin = 35;
double Beta = 3950;
double To = 298.15;
double Ro = 50000;
double R1 = 46000;
double T, Vout, Rt;


// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define HX7CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define THERCHARACTERISTIC_UUID "f8a1ff64-1b80-4fb5-bcf8-66986168b370"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceCon = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceCon = false;
    }
};

void setup() {
  Serial.begin(115200);

  Serial.println("Initializing the scale");

  //initialize library with data output pin, clock input pin
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  mea = 6377;
  //calibrating the scale based on specifications
  scale.set_scale(mea);
  //reset the scale                     
  scale.tare();               

  //take measurements of the curernt scale so that we can start at zero even with something on the scale
  scale.read();                 
  scale.read_average(20);       
  scale.get_value(5);   
  scale.get_units(5);        

  //BLE Device, Server and Service
  BLEDevice::init("REM_ESP32");
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  BLEService *pService = pServer->createService(SERVICE_UUID);

  //BLE Characteristic for scale
  HX7Characteristic = pService->createCharacteristic(
                      HX7CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_NOTIFY 
                    );
  //BLE Descriptor for scale
  HX7Characteristic->addDescriptor(new BLE2902());


  //BLE characteristic for thermistor
  THERCharacteristic = pService->createCharacteristic(
                      THERCHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_NOTIFY 
                    );
  //BLE Descriptor for thermistor
  THERCharacteristic->addDescriptor(new BLE2902());

  //service and advertising
  pService->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

void loop() {
    //notify change
    if (deviceCon) {
        wei = scale.get_units(10);
        static char weight[6];
        dtostrf(wei, 8, 6, weight);
        HX7Characteristic->setValue(weight);
        HX7Characteristic->notify();

        //reading analog from thermistor
        Vout = analogRead(ThermistorPin);
        Vout = Vout * 3.3/4095;
        Rt = R1 * Vout/(3.3 - Vout);
        //Kelvin Conversion
        T = 1/(1/To + log(Rt/Ro)/Beta);
        //Celsius Conversion
        T = T - 273.15;
        //Fahrenheit Conversion, 5-7 F error margin
        T = T * (9/5) + 69; 
        static char temp[6];
        dtostrf(T, 8, 6, temp);s
        THERCharacteristic->setValue(temp);
        THERCharacteristic->notify();
   
        delay(1000); //if too many packets bluetooth may be backed up 
    }

}
