// friend_requests_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_5/myprofile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class FriendRequestsPage extends StatefulWidget {
  final int userId;

  FriendRequestsPage({required this.userId});

  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  List<Map<String, dynamic>> friendRequests = [];
  late List<int> friendIds;
  late Map<String, dynamic> userInfo;

  @override
  void initState() {
    super.initState();
    fetchFriendRequests();
  }

  Future<void> fetchUserData() async {
    try {
      final userResponse = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}'),
      );

      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(userResponse.body);
        setState(() {
          userInfo = userData['user'];
        });
      } else {
        print(
            'Failed to load user information. Status codes: ${userResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchFriendRequests() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:5000/api/users/${UserAuth.userId}/friend-requests'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          friendIds = List<int>.from(data['users_ids']);
        });
        await fetchFriendDetails();
      } else {
        print(
            'Failed to load friend requests. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching friend requests: $e');
    }
  }

  Future<void> fetchFriendDetails() async {
    for (int friendId in friendIds) {
      try {
        print("11111111111111111111111");
        final response = await http.get(
          Uri.parse('http://10.0.2.2:5000/api/users/$friendId'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> friendData = json.decode(response.body);
          setState(() {
            friendRequests.add(friendData['user']);
            print(friendRequests);
          });
        } else {
          print(
              'Failed to load friend details. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching friend details: $e');
      }
    }
  }

  Future<void> acceptFriendRequest(int friendId) async {
    try {
      var response = await http.post(
        Uri.parse(
            'http://10.0.2.2:5000/api/create_friendships/${UserAuth.userId}/$friendId'),
      );

      if (response.statusCode == 204) {
        // Friendship created successfully, you may want to refresh the friend requests list
        await fetchFriendRequests();
      } else {
        // Handle the case where the request was not successful
        print(
            'Failed to accept friend request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error accepting friend request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Αιτήματα Φιλίας'),
      ),
      body: friendRequests.isNotEmpty
          ? ListView.builder(
              itemCount: friendRequests.length,
              itemBuilder: (context, index) {
                final friend = friendRequests[index];
                return ListTile(
                  title: Text(friend['nickname']),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      await acceptFriendRequest(friend['id']);
                      // After accepting the friend request, fetch the list again to update the UI

                      // Navigate to MyProfile
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyProfilePage()), // Replace MyProfile with your profile screen widget
                      );
                    },
                    child: Text('Αποδοχή Αιτήματος'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text('Δεν υπάρχουν αιτήματα.'),
            ),
    );
  }
}
