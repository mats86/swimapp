import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../../AppConfig.dart';
import 'models.dart';

Future<List<SwimCourse>> getSwimCourses() async {
  try {
    final response = await http.get(
      Uri.parse('${AppConfig.serverUrl}/getSwimCourse'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin':
            '*', // Erlaubt Anfragen von allen Domänen
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['swim_courses'];

      return List<SwimCourse>.from(data.map((item) => SwimCourse(
            item['KursID'],
            item['Name'],
            item['Preis'],
            item['Beschreibung'],
            item['HatFixtermine'],
            item['Altersgruppe'],
            item['KursDauer'],
          )));

      // Refresh the UI with fetched data
    } else {
      // Handle other status codes or errors
      print('Error while fetching data: ${response.statusCode}');
      throw Exception(
          'Failed to fetch swim courses'); // Hier wird eine Ausnahme geworfen
    }
  } catch (e) {
    // Handle network errors or exceptions
    print('Error while fetching data: $e');
    throw Exception(
        'Failed to fetch swim courses'); // Hier wird eine Ausnahme geworfen
  }
}

Future<List<SwimPools>> getSwimPools() async {
  List<SwimPool> swimPools = [];
  List<OpenTime> openTimes = [];
  try {
    final response = await http.get(
      Uri.parse('${AppConfig.serverUrl}/getSwimPools'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['swim_pools'];

      swimPools = List<SwimPool>.from(data.map((item) => SwimPool(
            item['SchwimmbadID'],
            item['Name'],
            item['Adresse'],
            item['Telefonnummer'],
            item['Oeffnungszeiten'],
          )));

      final List<dynamic> openTimeData = jsonDecode(swimPools[0].openingTime);
      openTimes = [];
      for (int i = 0; i < openTimeData.length; i++) {
        openTimes.add(OpenTime(
          openTimeData[i]['day'],
          openTimeData[i]['openTime'],
          openTimeData[i]['closeTime'],
        ));
      }

      return List<SwimPools>.from(swimPools.map((item) => SwimPools(
          item.schwimmbadID,
          item.name,
          item.address,
          item.phoneNumber,
          openTimes)));

      // Refresh the UI with fetched data
    } else {
      // Handle other status codes or errors
      print('Error while fetching data: ${response.statusCode}');
      throw Exception(
          'Failed to fetch swim pools'); // Hier wird eine Ausnahme geworfen
    }
  } catch (e) {
    // Handle network errors or exceptions
    print('Error while fetching data: $e');
    throw Exception(
        'Failed to fetch swim pools'); // Hier wird eine Ausnahme geworfen
  }
}
