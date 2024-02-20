// // events.dart

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class Event {
//   final int id;
//   final int userId;
//   final String userName;
//   final String description;
//   final DateTime time;
//   final String location;

//   Event({
//     required this.id,
//     required this.userId,
//     required this.userName,
//     required this.description,
//     required this.time,
//     required this.location,
//   });

//   factory Event.fromJson(Map<String, dynamic> json) {
//     return Event(
//       id: json['id'],
//       userId: json['user_id'],
//       userName: json['user_name'],
//       description: json['description'],
//       time: DateTime.parse(json['time']),
//       location: json['location']
//     );
//   }
// }

// class EventsPage extends StatefulWidget {
//   @override
//   _EventsPageState createState() => _EventsPageState();
// }

// class _EventsPageState extends State<EventsPage> {
//   List<Event> events = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchEvents();
//   }

//   Future<void> fetchEvents() async {
//     try {
//       var response = await http.get(
//         Uri.parse('http://10.0.2.2:5000/api/events'),
//       );

//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           events = data.map((e) => Event.fromJson(e)).toList();
//         });
//       } else {
//         print('Failed to fetch events. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching events: $e');
//     }
//   }

//     bool isChecked = false;

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Events'),
//       ),
//       body: ListView.builder(
//         itemCount: events.length,
//         itemBuilder: (context, index) {
//           Event event = events[index];
//           return Card(
//             elevation: 5.0,
//             margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//             child: ListTile(
//               title: Text(event.userName),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Description: ${event.description}'),
//                   Text('Time: ${event.time.toString()}'),
//                   Text('Location: ${event.location}'),

//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'homepage.dart';

class Event {
  final int id;
  final String userName;
  final String description;
  final DateTime time;
  final String location;
  bool isSelected;

  Event({
    required this.id,
    required this.userName,
    required this.description,
    required this.time,
    required this.location,
    this.isSelected = false,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      userName: json['user_name'],
      description: json['description'],
      time: DateTime.parse(
          json['time']), // Assuming 'time' is a string in ISO 8601 format
      location: json['location'],
    );
  }
}

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();
    fetchAllEvents();
    fetchUserEvents();
  }

  Future<void> fetchUserEvents() async {
    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/user_events/${UserAuth.userId}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        List<int> userEventIds = data.map<int>((e) => e[0]).toList();

        setState(() {
          events.forEach((event) {
            if (userEventIds.contains(event.id)) {
              event.isSelected = true;
            }
          });
        });
      } else {
        print(
            'Failed to fetch user events. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user events: $e');
    }
  }

  Future<void> fetchAllEvents() async {
    try {
      var response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/events'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          events = data.map((e) => Event.fromJson(e)).toList();
        });
      } else {
        print(
            'Failed to fetch all events. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching all events: $e');
    }
  }

  Future<void> updateEventSelection(Event event, bool isSelected) async {
    try {
      String url = 'http://10.0.2.2:5000/api/update_user_event';
      Map<String, dynamic> body = {
        'user_id': UserAuth.userId,
        'event_id': event.id,
        'add_relation': isSelected,
      };

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        print('User event updated successfully');
      } else {
        print(
            'Failed to update user event. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          Event event = events[index];
          return Card(
            elevation: 5.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(event.userName),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Περιγραφή: ${event.description}'),
                  Text('Ώρα: ${event.time.toString()}'),
                  Text('Τοποθεσία: ${event.location}'),
                ],
              ),
              trailing: Checkbox(
                value: event.isSelected,
                onChanged: (value) {
                  setState(() {
                    event.isSelected = value ?? false;
                  });
                  updateEventSelection(event, event.isSelected);
                },
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomNavigationBar(
        currentPage: NavigationPage.notification,
      ),
    );
  }
}
