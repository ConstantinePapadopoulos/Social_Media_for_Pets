import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'main.dart';
import 'post_comments.dart';
import 'map.dart';
import 'settings.dart';
import 'newpost.dart';
import 'newevent.dart'; // Import the NewEventPage
import 'friendspage.dart';
import 'friend_request.dart';
import 'event.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
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
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}'),
      );

      final postsResponse = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/users/${UserAuth.userId}/posts'),
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

  Future<void> showPostTypeSelectionDialog() async {
    String? result = await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Είδος Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'post'); // 'post' indicates a new post
              },
              child: Text('Νέο Post'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context, 'event'); // 'event' indicates a new event
              },
              child: Text('Νέο Event'),
            ),
          ],
        ),
      ),
    );

    if (result == 'post') {
      // Navigate to new post page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewPostPage(),
        ),
      );
    } else if (result == 'event') {
      // Navigate to new event page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NewEventPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! > 0) {
            // Swipe left: Navigate to HomePage
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomePage()));
          }
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('Το προφίλ μου 🐾'),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: userInfo != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      Container(
                        //padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/dog_cat.png'), // Replace with your avatar image asset
                              radius: 35,
                            ),
                            SizedBox(width: 30), // For spacing
                            Flexible(
                              flex: 1,

                              // Wrap the first button in a Flexible widget
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      130, 40), // Adjust the size as needed
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FriendsPage(userId: UserAuth.userId),
                                    ),
                                  );
                                },
                                child:
                                    Text('Οι φίλοι μου'), // My Friends in Greek
                              ),
                            ),

                            SizedBox(width: 10), // For spacing

                            Flexible(
                              flex: 1,
                              // Wrap the second button in a Flexible widget
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(
                                      120, 40), // Adjust the size as needed
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FriendRequestsPage(
                                          userId: UserAuth.userId),
                                    ),
                                  );
                                },
                                child: Text('Αιτήματα'), // Requests in Greek
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                16.0), // Adjust the horizontal padding as needed
                        child: Divider(
                          color: Colors.black,
                          thickness: 0.6,
                        ),
                      ),
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
                                        'Τοποθεσία: ${post['location']}, Likes:  ${post['likes']}'),
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
                                  // Add more post information fields as needed

                                  // Display the post image
                                  Image.asset(
                                    post['image_path'],
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, // Adjust alignment as needed
                                    children: <Widget>[
                                      Spacer(),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () async {
                                          final response = await http.delete(
                                            Uri.parse(
                                                'http://10.0.2.2:5000/api/posts/${post['id']}/delete_post'),
                                          );

                                          if (response.statusCode == 200) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Success'),
                                                  content: Text(
                                                      'The post was deleted successfully.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('OK'),
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                MyProfilePage(),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            print(
                                                'Failed to delete the post. Status code: ${response.statusCode}');
                                          }
                                        },
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showPostTypeSelectionDialog(); // Display the dialog for selecting post type
              },
              child: Icon(Icons.add),
              //backgroundColor: Colors.green,
            )));
  }
}
