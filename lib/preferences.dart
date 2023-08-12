import 'package:shared_preferences/shared_preferences.dart';


// Get Preferences
Future<String> getSharedPref(String setting) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String result = prefs.getString(setting) ?? 'None';
  return result;
}

// Save Preferences
saveSharedPref(String setting, String value) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(setting, value);
}





/*
class ApiConstants {

  String baseUrl = "";

  void apimanLoadSettings(){
    getDeviceIP().then((String result){String baseUrl = 'http://$result:3000';});
  }

  static String pelletLevelEndpoint = '/pelletlevel';
  static String emptyMeasurementEndpoint = '/calibrate/empty';
  static String fullMeasurementEndpoint = '/calibrate/full';
  static String connectionStatusEndpoint = '/alive';
}
*/