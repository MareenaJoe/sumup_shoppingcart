
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

import '../model/event.dart';

const API = 'http://192.168.0.178:8080';
const headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};

class EventsService{
  Future<List<Event>> loadEvents() async {
    print("About to get events");
    final events = <Event>[];
    http.Response response = await http.get(API + '/events', headers: headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      for (var item in jsonData) {
        events.add(Event.fromJson(item));
      }
      return events;
    }
    else {
      print("Data error");
      return null;
    }
  }
}