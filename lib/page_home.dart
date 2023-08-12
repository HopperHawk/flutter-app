// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'api_manager.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String currentPellets = "Hickory";
  double pelletLevel = 0;
  String lastUpdated = "N/A";
  bool loadingIndicatorActive = false;  
  bool failureIndicationActive = false;

  void updateHopperLevel(){
    setState(() {
      loadingIndicatorActive = true;
    });

    fetchPelletLevel().then((String result){
      if (result == '-1'){
        setState(() {
          failureIndicationActive = true;
          loadingIndicatorActive = false;
        });
      } else {
        setState((){
          pelletLevel = double.parse(result);
          lastUpdated = DateFormat("hh:mm a  MM/dd/yyyy").format(DateTime.now());
          loadingIndicatorActive = false;
          failureIndicationActive = false;
        });
      }
    });
  }

  @override
  void initState(){
    super.initState();
    updateHopperLevel();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            
            children: [
              const Padding(padding: EdgeInsets.only(top: 50)),
              const Text('Current Hopper Level', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),

              SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(minimum: 0, maximum: 100,
                ranges: <GaugeRange>[
                  GaugeRange(startValue: 0, endValue: 25, color:Colors.red),
                  GaugeRange(startValue: 25,endValue: 60,color: Colors.orange),
                  GaugeRange(startValue: 60,endValue: 100,color: Colors.green)],
                pointers: <GaugePointer>[
                  NeedlePointer(value: pelletLevel)],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(widget: Container(child: 
                    Text(('$pelletLevel%'),style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                    angle: 90, positionFactor: 0.5
                  )]
                )]),
                
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(text: "Last Updated: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: lastUpdated),
                    ]
                  )
                ),

                const Padding(padding: EdgeInsets.only(top:15)),
                SizedBox(
                  width: 200,
                  child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                      ),
                      onPressed: loadingIndicatorActive ? null: updateHopperLevel,

                      child: const Text('Refresh'), 
                    )
                ),
                const Padding(padding: EdgeInsets.only(top:50)),
                Visibility(visible: loadingIndicatorActive, child: const CupertinoActivityIndicator(radius: 20, color: CupertinoColors.activeOrange),),
                Visibility(visible: failureIndicationActive, child: const Text('Failed to Update Data!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red, fontSize: 15),),),
                
                
                

            ]
         )),
      ),
    );
  }
}