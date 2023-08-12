import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


// ========== GET DATA ========== //
Future<Map<dynamic,dynamic>> getWifiSettings() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';

  try{
    final response = await http.get(Uri.parse('http://$savedDeviceIP/configure/wifi'));
    final Map parsed = json.decode(response.body); 
    return parsed;
  } catch (e) {
    final Map parsed = {'state': 'failed'};
    return parsed;
  }
}

Future<Map<dynamic,dynamic>> getMQTTSettings() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';

  try{
    final response = await http.get(Uri.parse('http://$savedDeviceIP/configure/mqtt'));
    final Map parsed = json.decode(response.body); 
    return parsed;
  } catch (e) {
    final Map parsed = {'state': 'failed'};
    return parsed;
  }
}

Future<Map<dynamic,dynamic>> getHopperSettings() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';
  try{
    final response = await http.get(Uri.parse('http://$savedDeviceIP/configure/hopper'));
    final Map parsed = json.decode(response.body); 
    return parsed;
  } catch (e) {
    final Map parsed = {'state': 'failed'};
    return parsed;
  }
  
}

// Get Current Pellet Level
Future<String> fetchPelletLevel() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';

  try {
  
    final response = await http.get(Uri.parse('http://$savedDeviceIP/pelletlevel'));
    
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      print('Not 200');
      return('-1');
    }
  } catch (e) {
      print(e);
      return('-1');
  }
}

// Get the Empty Measurement
Future<String> fetchEmptyMeasurement() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';
  
  try {
  
    final response = await http.get(Uri.parse('http://$savedDeviceIP/calibrate/empty'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return('0');
    }
  } catch (e) {
    return('0');
  }
}

// Get the Full Measurement
Future<String> fetchFullMeasurement() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';
  
  try {
  
    final response = await http.get(Uri.parse('http://$savedDeviceIP/calibrate/full'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return('0');
    }
  } catch (e) {
    return('0');
  }
}

// Get Connection Status
Future<String> fetchConnStatus() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';
  
  try {
  
    final response = await http.get(Uri.parse('http://$savedDeviceIP/alive'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return('0');
    }
  } catch (e) {
    return('0');
  }
}




// ========== POST DATA ========== //
Future<http.Response> triggerEmptyMeasurement() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';

  return http.post(Uri.parse('http://$savedDeviceIP/calibrate/empty'));
}

Future<http.Response> triggerFullMeasurement() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';

  return http.post(Uri.parse('http://$savedDeviceIP/calibrate/full'));
}

Future<http.Response> triggerReboot() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';

  return http.post(Uri.parse('http://$savedDeviceIP/sys/reboot'));
}

Future<http.Response> triggerFactoryReset() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';

  return http.post(Uri.parse('http://$savedDeviceIP/sys/reset'));
}

Future<http.Response> postWifiSettings(bool s, String ssid, String pass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';
  int status = s ? 1: 0;
  return http.post(Uri.parse('http://$savedDeviceIP/configure/wifi'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
    'status': status,
    'ssid': ssid,
    'password': pass,
  }));
}

Future<http.Response> posMQTTSettings(bool s, String ip, int port, String user, String pass) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';
  int status = s ? 1: 0;
  
  return http.post(Uri.parse('http://$savedDeviceIP/configure/mqtt'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
    'status': status,
    'broker_ip': ip,
    'broker_port': port,
    'user': user,
    'password': pass,
  }));
}

Future<http.Response> postHopperSettings(int f) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String savedDeviceIP = prefs.getString('device_ip') ?? '0.0.0.0';

  return http.post(Uri.parse('http://$savedDeviceIP/configure/hopper'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
    'frequency': f,
  }));
}



/*
return http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  */