// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hopperhawk/api_manager.dart';

class CalibratePage extends StatefulWidget {
  const CalibratePage({super.key});

  @override
  State<CalibratePage> createState() => _CalibratePageState();
}

class _CalibratePageState extends State<CalibratePage> {
  // Variables
  double emptyPlaceholder = 75.5;
  double fullPlaceholder = 10.2;
  bool _calibrationModeEnabled = false;
  bool loadingIndicatorActive = false;  
  bool failureIndicationActive = false;


  void loadMeasurements(){

    setState(() {
      loadingIndicatorActive = true;
    });



    fetchEmptyMeasurement().then((String result){
      if (result == '0'){
        setState(() {
          failureIndicationActive = true;
          loadingIndicatorActive = false;
        });
      } else {
        setState(() {
          emptyPlaceholder = double.parse(result);
          failureIndicationActive = false;
          loadingIndicatorActive = false;
        });
      }
    });

    fetchFullMeasurement().then((String result){
      if (result == '0'){
        setState(() {
          failureIndicationActive = true;
          loadingIndicatorActive = false;
        });
      } else {
        setState(() {
          fullPlaceholder = double.parse(result);
          failureIndicationActive = false;
          loadingIndicatorActive = false;
        });
      }
    });
  }


  @override
  void initState(){
    super.initState();
    loadMeasurements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 75)),
                    const Text('Enable Calibration Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const Padding(padding: EdgeInsets.only(left: 75)),
                    CupertinoSwitch(
                      // This bool value toggles the switch.
                      value: _calibrationModeEnabled,
                      activeColor: CupertinoColors.activeOrange,
                      onChanged: (bool? value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          _calibrationModeEnabled = value ?? false;
                          if (_calibrationModeEnabled == false){loadMeasurements();}
                        });}),                 
                  ]
                ),

                const Padding(padding: EdgeInsets.only(top:100)),

                SizedBox(height: 60, width: 275, child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                  onPressed: _calibrationModeEnabled ? triggerEmptyMeasurement: null,
                  child: _calibrationModeEnabled ? const Text('Take Empty Measurement'): Text('Empty Measurement: $emptyPlaceholder cm.'),
                ),),

                const Padding(padding: EdgeInsets.only(top:20)),

                SizedBox(height: 60, width: 275, child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                  onPressed: _calibrationModeEnabled ? triggerFullMeasurement: null,
                  child: _calibrationModeEnabled ? const Text('Take Full Measurement'): Text('Full Measurement: $fullPlaceholder cm.'),
                ),),

                const Padding(padding: EdgeInsets.only(top:50)),
                Visibility(visible: loadingIndicatorActive, child: const CupertinoActivityIndicator(radius: 20, color: CupertinoColors.activeOrange),),
                Visibility(visible: failureIndicationActive, child: const Text('Failed to Update Data!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 15),),),
              ],
            ),        
          ),
        ),
      );    
  }
}
