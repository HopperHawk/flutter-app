import 'package:flutter/material.dart';
import 'package:hopperhawk/preferences.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:flutter/cupertino.dart';
import 'api_manager.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _textController;
  String deviceIP = "";
  int pollFrequency = 0;
  String wifiSSID = "";
  String wifiPass = "";
  String mqttBroker = "";
  int mqttPort = 0;
  String mqttUser = "";
  String mqttPass = "";
  String connectionStatus = "Disconnected";

  bool isWifiEnabled = false;
  bool isMQTTEnabled = false;


  void loadSettings(){

    getSharedPref('device_ip').then((String result){
      if (result == 'None'){
        setState(() {
          connectionStatus = "Disconnected";
       });
      } else {
        setState(() {deviceIP = result;});
        getWifiSettings().then((Map<dynamic,dynamic> data){
          setState((){
            wifiSSID = data['ssid'];
            wifiPass = data['password'];
            if (data['status'] == 1){isWifiEnabled = true;}
          });
        });

        getMQTTSettings().then((Map<dynamic,dynamic> data){
          setState((){
            mqttBroker = data['broker_ip'];
            mqttPort = data['broker_port'];
            mqttUser = data['user'];
            mqttPass = data['password'];
            if (data['status'] == 1){isMQTTEnabled = true;}
          });
        });

        getHopperSettings().then((Map<dynamic,dynamic> data){
          setState((){
            pollFrequency = data['frequency'];
          });
        });
        


        fetchConnStatus().then((String result){
          if (result == '0'){
            setState(() {
              connectionStatus = "Disconnected";
            });
          } else {
            setState(() {
              connectionStatus = "Connected";
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    try{
      loadSettings();
    } catch (e) {
      setState(() {
          connectionStatus = "Disconnected";
        });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
  

  // ========== Alert Interfaces for System Configuration ========== //

  // IP Address
  void _showAlertDialogIPConfig(BuildContext context) {

    _textController.text = deviceIP;

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('IP Address to Connect To'),
        content: CupertinoTextField(controller: _textController,),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              
              setState((){
                deviceIP = _textController.text;
                saveSharedPref('device_ip',deviceIP);
              });

                fetchConnStatus().then((String result){
                  if (result == '0'){
                    setState(() {
                      connectionStatus = "Disconnected";
                    });
                  } else {
                    setState(() {
                      connectionStatus = "Connected";
                    });
                  }
                });

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

// Polling Frequency
  void _showAlertDialogPollFreq(BuildContext context) {
    
    _textController.text = pollFrequency.toString();
   
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Polling Frequency (Seconds)'),
        content: CupertinoTextField(controller: _textController,),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              
              setState((){
                pollFrequency = int.parse(_textController.text);
              });
              postHopperSettings(pollFrequency);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


// SSID/Password
  void _showAlertDialogWifiSSID(BuildContext context) {
    
    _textController.text = wifiSSID;
   
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Wi-Fi SSID'),
        content: CupertinoTextField(controller: _textController,),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              
              setState((){
                wifiSSID = _textController.text;
              });

              postWifiSettings(isWifiEnabled, wifiSSID, wifiPass);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAlertDialogWifiPass(BuildContext context) {
    
    _textController.text = "";
   
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Wi-Fi Password'),
        content: CupertinoTextField(controller: _textController,),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              wifiPass = _textController.text;
              postWifiSettings(isWifiEnabled, wifiSSID, wifiPass);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }





// MQTT Broker
  void _showAlertDialogPMQTTBroker(BuildContext context) {
    
    _textController.text = mqttBroker;
   
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('MQTT Broker (IP:Port)'),
        content: CupertinoTextField(controller: _textController,),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              final temp = _textController.text.split(':');
              setState((){
                mqttBroker = temp[0];
                mqttPort = int.parse(temp[1]);
              });

              posMQTTSettings(isMQTTEnabled, mqttBroker, mqttPort, mqttUser, mqttPass);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


// SSID/Password
  void _showAlertDialogMQTTUser(BuildContext context) {
    
    _textController.text = mqttUser;
   
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('MQTT Username'),
        content: CupertinoTextField(controller: _textController,),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              
              setState((){
                mqttUser = _textController.text;
              });
              posMQTTSettings(isMQTTEnabled, mqttBroker, mqttPort, mqttUser, mqttPass);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAlertDialogMQTTPass(BuildContext context) {
    
    _textController.text = "";
   
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('MQTT Password'),
        content: CupertinoTextField(controller: _textController,),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              mqttPass = _textController.text;
              posMQTTSettings(isMQTTEnabled, mqttBroker, mqttPort, mqttUser, mqttPass);
              Navigator.pop(context);
            },

            child: const Text('Save'),
          ),
        ],
      ),
    );
  }




  void _showAlertDialogFactoryReset(BuildContext context) {
   
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Perform Factory Reset'),
        content: const Text('This will erase all system settings. After this is performed you will need to connect to the HopperHawk Wi-Fi to reconfigure.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child:  Text('Cancel', style: TextStyle(color: Colors.blue.shade400, fontWeight: FontWeight.normal)),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              triggerFactoryReset();
              Navigator.pop(context);
            },
            child: const Text('Reset System', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }




  void _showAlertDialogRebootSystem(BuildContext context) {
   
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Reboot System'),
        content: const Text('This will restart the sensor, it may take a few moments to reconnect.'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates this action is the default,
            /// and turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child:  Text('Cancel', style: TextStyle(color: Colors.blue.shade400, fontWeight: FontWeight.normal)),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              triggerReboot();
              Navigator.pop(context);
            },
            child: const Text('Reboot', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }








// ========== Main Display ========== //
  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Device'),
          tiles: <SettingsTile>[
            SettingsTile(
              leading: const Icon(Icons.start),
              title: const Text('Status'),
              value: Text(connectionStatus),
            ),
            SettingsTile(
              leading: const Icon(Icons.wifi_find),
              title: const Text('Device IP Address'),
              value: Text(deviceIP),
              onPressed: _showAlertDialogIPConfig,
            ),
            SettingsTile(
              leading: const Icon(Icons.timer),
              title: const Text('Polling Frequency (Seconds)'),
              value: Text(pollFrequency.toString()),
              description: const Text('Polling frequency is how often the sensor will take a new measurement'),
              onPressed: _showAlertDialogPollFreq,
            ),

          ],
        ),

        SettingsSection(
          title: const Text('Wi-Fi'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
              onToggle: (bool? value) {
                setState(() {
                  isWifiEnabled = value ?? false;
                  postWifiSettings(isWifiEnabled, wifiSSID, wifiPass);
                });
              },
              initialValue: isWifiEnabled,
              leading: const Icon(Icons.wifi),
              title: const Text('Enabled'),
            ),
            SettingsTile(
              leading: const Icon(Icons.note),
              title: const Text('SSID'),
              value: Text(wifiSSID),
              onPressed: _showAlertDialogWifiSSID,
            ),
            SettingsTile(
              leading: const Icon(Icons.key),
              title: const Text('Password'),
              value: const Text('********'),
              onPressed: _showAlertDialogWifiPass,
            ),
          ],
        ),

          SettingsSection(
          title: const Text('MQTT'),
          tiles: <SettingsTile>[
            SettingsTile.switchTile(
            onToggle: (bool? value) {
                setState(() {
                  isMQTTEnabled = value ?? false;
                  posMQTTSettings(isMQTTEnabled, mqttBroker, mqttPort, mqttUser, mqttPass);
                });
            },
              initialValue: isMQTTEnabled,
              leading: const Icon(Icons.comment),
              title: const Text('Enabled'),
            ),
            SettingsTile(
              leading: const Icon(Icons.computer),
              title: const Text('Broker (IP:Port)'),
              value: Text(mqttBroker),
              onPressed: _showAlertDialogPMQTTBroker,
            ),
            SettingsTile(
              leading: const Icon(Icons.note),
              title: const Text('Username'),
              value: Text(mqttUser),
              onPressed: _showAlertDialogMQTTUser,
            ),
            SettingsTile(
              leading: const Icon(Icons.key),
              title: const Text('Password'),
              value: const Text('********'),
              onPressed: _showAlertDialogMQTTPass,
              description: const Text('If MQTT is enabled, it will publish to the following topics:\n/HopperHawk/pellets/level\n/HopperHawk/pellets/type\n/HopperHawk/sensor/battery')
            ),
          ],
        ),

        SettingsSection(
          title: const Text('System'),
          tiles: <SettingsTile>[
            SettingsTile(
              leading: const Icon(Icons.dangerous_outlined),
              title: const Text('Factory Reset'),
              value: const Text('Factory Reset', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              onPressed: _showAlertDialogFactoryReset,
            ),
            SettingsTile(
              leading: const Icon(Icons.restart_alt),
              title: const Text('Reboot'),
              value: const Text('Restart System', style: TextStyle(color: Colors.blue)),
              onPressed: _showAlertDialogRebootSystem,
            ),
          ]

        )

      ],
    );
  }
}