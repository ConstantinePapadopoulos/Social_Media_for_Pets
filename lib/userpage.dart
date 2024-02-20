import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'main.dart';
import 'post_comments.dart';
import 'map.dart';
import 'learn_about_me.dart';
import 'event.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class UserProfilePage extends StatefulWidget {
  final int userId;

  UserProfilePage({required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late Map<String, dynamic> userInfo;
  late List<Map<String, dynamic>> userPosts;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userResponse = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${widget.userId}'),
      );

      final postsResponse = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${widget.userId}/posts'),
      );

      if (userResponse.statusCode == 200 && postsResponse.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(userResponse.body);
        final List<Map<String, dynamic>> postsData =
            List.from(json.decode(postsResponse.body)['posts']);

        setState(() {
          userInfo = userData['user'];
          userPosts = postsData;
        });
      } else {
        print(
            'Failed to load user information or posts. Status codes: ${userResponse.statusCode}, ${postsResponse.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> sendFriendRequest(int receiverUserId) async {
    try {
      var response = await http.post(
        Uri.parse(
            'http://10.0.2.2:5000/api/friendships/${UserAuth.userId}/$receiverUserId'),
      );

      if (response.statusCode == 204) {
        showFriendRequestSentDialog();
      } else {
        print(
            'Failed to send friend request. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  void showFriendRequestSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Friend Request Sent'),
          content: Text('Your friend request has been sent.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Προφίλ Χρήστη 🐾'),
      ),
      body: //userInfo != null
          Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Spacer(),
              CircleAvatar(
                backgroundImage: AssetImage('assets/dog_cat.png'),
                radius: 40,
              ),
              SizedBox(width: 10),
              Spacer(),
              Column(children: <Widget>[
                Text(
                  userInfo['nickname'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  ' ${userInfo['account_type']}',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ]),
              Spacer(),
            ],
          ),

          // Conditionally add widgets for business type
          if (userInfo['account_type'] == 'business') ...[
            Row(
              children: [
                SizedBox(width: 16.0),
                Expanded(
                  child: ListTile(
                    title: Text('${userInfo['business_name']}'),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: launchButton(
                    title: 'Τηλέφωνο',
                    icon: Icons.phone_rounded,
                    onPressed: () async {
                      Uri uri = Uri.parse('tel:${userInfo['phone']}');
                      if (!await launcher.launchUrl(uri)) {
                        debugPrint("Could not launch the phone");
                      }
                    },
                  ),
                ),
                SizedBox(width: 16.0),
              ],
            ),
          ],

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 40.0), // You can adjust the padding value as needed
            child: launchButton(
              title: 'Email: ${userInfo['email']}',
              icon: Icons.email_rounded,
              onPressed: () async {
                Uri uri = Uri.parse('mailto:${userInfo['email']}');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint("could not launch the email");
                }
              },
            ),
          ),
          Row(
            children: <Widget>[
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  await sendFriendRequest(widget.userId);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Adjust the radius here
                  ),
                ),
                child: Text('Προσθήκη'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LearnAboutMePage(userId: widget.userId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15.0), // Adjust the radius here
                  ),
                ),
                child: Text('Μάθε για ${userInfo['nickname']}'),
              ),
              Spacer(),
            ],
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: userPosts.length,
              itemBuilder: (context, index) {
                final post = userPosts[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(post['username']),
                        subtitle: Text(
                            'Τοποθεσία: ${post['location']}, Likes: ${post['likes']}'),
                        leading: CircleAvatar(
                          child: Text(
                            post['username'] != null
                                ? post['username'][0].toUpperCase()
                                : '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Image.asset(
                        post['image_path'],
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostCommentsPage(postId: post['id']),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget launchButton({
    required String title,
    required IconData icon,
    required Function() onPressed,
  }) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ]),
        ));
  }
}
