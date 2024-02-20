import 'package:flutter/material.dart';
import 'package:flutter_application_5/myprofile.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'event.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'userpage.dart';
import 'homepage.dart';

class MapPage extends StatelessWidget {
  Future<Map<String, dynamic>> fetchEvent() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/api/get_event'));
    if (response.statusCode == 200) {
      // Return the JSON response as a Map
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load event');
    }
  }

  @override
  Widget build(BuildContext context) {
    final LatLng zografouLatLng = LatLng(37.9757, 23.7677);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ο χάρτης μου'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: zografouLatLng,
                zoom: 16.0,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayerOptions(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: zografouLatLng,
                      builder: (ctx) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfilePage(userId: 1),
                            ),
                          );
                        },
                        child: Container(
                          child: Text('🏥', style: TextStyle(fontSize: 40)),
                        ),
                      ),
                    ),
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: LatLng(37.9757, 23.7177),
                      builder: (ctx) => GestureDetector(
                        onTap: () async {
                          try {
                            Map<String, dynamic> eventData = await fetchEvent();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      "Event του χρήστη: ${eventData['user_name']}"), // Use data from the API
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text("${eventData['description']}"),
                                        Text("${eventData['time']}"),
                                        Text("${eventData['location']}"),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Άκυρο"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Events"),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => EventsPage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            // Handle the error, for example, by showing an error message
                          }
                        },
                        child: Container(
                          child: Text('🔔', style: TextStyle(fontSize: 40)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ), // Add the custom bottom navigation bar
      bottomNavigationBar: CustomNavigationBar(
        currentPage: NavigationPage.map,
      ),
    );
  }
}
