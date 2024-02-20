import 'package:flutter/material.dart';
import 'main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'map.dart';
import 'event.dart';
import 'post_comments.dart';
import 'myprofile.dart';
import 'userpage.dart';
import 'package:url_launcher/url_launcher.dart';

class Post {
  final String username;
  final String imagePath;
  final String location;
  final int userId;
  final int postId; // Add userId to represent the foreign key
  final int likes;

  Post({
    required this.username,
    required this.imagePath,
    required this.location,
    required this.userId,
    required this.postId,
    required this.likes,
  });
}

Future<List<Post>> fetchPosts() async {
  try {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:5000/api/posts'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((post) => Post(
              username: post['username'],
              imagePath: post['image_path'],
              location: post['location'],
              userId: post['user_id'], // Include userId from the response
              postId: post['id'],
              likes: post['likes']))
          .toList();
    } else {
      print('Failed to load posts. Status code: ${response.statusCode}');
      return [];
    }
  } catch (e) {
    print('Error fetching posts: $e');
    return [];
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(children: [
        // Custom app bar replacement
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          color: Colors.white,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(
              onTap: () => navigateToProfile(context),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/dog_cat.png'),
                radius: 30, // Increased avatar size
              ),
            ),
            Expanded(
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.home,
                color: Theme.of(context)
                    .primaryColor, // Set the icon color to the theme's primary color
              ),
              onPressed: () => navigateToProfile(context),
            ),
          ]),
        ),

        Expanded(
            child: FutureBuilder<List<Post>>(
                future: fetchPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<Post> posts = snapshot.data!;
                    return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        Post post = posts[index];
                        return InstagramPostWidget(
                          username: post.username,
                          location: post.location,
                          postImage: AssetImage(post.imagePath),
                          userId: post.userId,
                          postId: post.postId,
                          likes: post.likes,
                        );
                      },
                    );
                  } else {
                    return Text('No data available');
                  }
                }))
      ])),
      bottomNavigationBar: CustomNavigationBar(
        currentPage: NavigationPage.main,
      ),
    );
  }

  void navigateToProfile(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => MyProfilePage()));
  }
}

enum NavigationPage {
  main,
  map,
  notification,
}

class CustomNavigationBar extends StatelessWidget {
  final NavigationPage currentPage;

  CustomNavigationBar({
    Key? key,
    required this.currentPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildNavItem(
            icon: Icons.home,
            label: 'Main',
            isActive: currentPage == NavigationPage.main,
            onTap: () {
              if (currentPage != NavigationPage.main) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
            },
          ),
          _buildNavItem(
            icon: Icons.map,
            label: 'Map',
            isActive: currentPage == NavigationPage.map,
            onTap: () {
              if (currentPage != NavigationPage.map) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              }
            },
          ),
          _buildNavItem(
            icon: Icons.notifications,
            label: 'Notifications',
            isActive: currentPage == NavigationPage.notification,
            onTap: () {
              if (currentPage != NavigationPage.notification) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(icon, color: isActive ? Colors.green : Colors.grey),
      onPressed: onTap,
    );
  }
}

class InstagramPostWidget extends StatefulWidget {
  final String username;
  final String location;
  final ImageProvider postImage;
  final int userId;
  final int postId;
  int likes; // Add likes property

  InstagramPostWidget({
    required this.username,
    required this.location,
    required this.postImage,
    required this.userId,
    required this.postId,
    required this.likes,
  });

  @override
  _InstagramPostWidgetState createState() => _InstagramPostWidgetState();
}

class _InstagramPostWidgetState extends State<InstagramPostWidget> {
  bool isLiked = false;
  final TransformationController _transformationController =
      TransformationController();

  void _onInteractionEnd(ScaleEndDetails details) {
    // Reset the transformation to its default state
    _transformationController.value = Matrix4.identity();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    // Call the API to get the like status when the widget is initialized
    fetchLikeStatus();
  }

  Future<void> fetchLikeStatus() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://10.0.2.2:5000/api/posts/${widget.postId}/like-status/${UserAuth.userId}'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          isLiked = data['liked'];
        });
      } else {
        print(
            'Failed to fetch like status. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching like status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null && details.primaryVelocity! < 0) {
            // Swipe left: Navigate to HomePage
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyProfilePage()));
          }
        },
        child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFF9FAF5), // Set your desired color here
              border: Border(
                top: BorderSide(color: Colors.black, width: 0.3), // Top border
                bottom: BorderSide(
                    color: Colors.black, width: 0.3), // Bottom border
              ),
            ),
            child: Card(
              color: Color(0xFFF9FAF5), // Set your desired color here
              //   shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(15.0),
              //),
              elevation: 0,
              //margin: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      child: Text(
                        widget.username.substring(0, 1),
                      ),
                    ),
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                UserProfilePage(userId: widget.userId),
                          ),
                        );
                      },
                      child: Text(widget.username,
                          style: TextStyle(
                            fontSize: 18, // Set your desired font size here
                          )),
                    ),
                    subtitle: Text(widget.location,
                        style: TextStyle(
                          fontSize: 14, // Set your desired font size here
                        )),
                  ),
                  InteractiveViewer(
                    transformationController: _transformationController,
                    onInteractionEnd: _onInteractionEnd,
                    panEnabled: false, // Allows panning
                    boundaryMargin: EdgeInsets.all(80),
                    minScale: 1,
                    maxScale: 4, // Set maximum zoom level (adjust as needed)

                    child: GestureDetector(
                      onDoubleTap: () async {
                        // Send a POST request to like or unlike the post
                        final response = await http.post(Uri.parse(
                            'http://10.0.2.2:5000/api/posts/${widget.postId}/${UserAuth.userId}/like'));
                        if (response.statusCode == 200) {
                          print(
                              "111111111111111111111111111111111111111111111111111111111111");
                          final Map<String, dynamic> data =
                              json.decode(response.body);
                          setState(() {
                            // Update isLiked and likes based on the server response
                            isLiked = data['liked'];
                            widget.likes = data['likes'];
                          });
                        } else {
                          print(
                              'Failed to like or unlike the post. Status code: ${response.statusCode}');
                        }
                      },
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10.0)),
                        child: Image(
                            image: widget.postImage, fit: BoxFit.scaleDown),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(
                        children: [
                          IconButton(
                            icon: Container(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                isLiked
                                    ? 'assets/paw_pink.png'
                                    : 'assets/paw_black.png',
                              ),
                            ),
                            onPressed: () async {
                              // Send a POST request to like or unlike the post
                              final response = await http.post(Uri.parse(
                                  'http://10.0.2.2:5000/api/posts/${widget.postId}/${UserAuth.userId}/like'));
                              if (response.statusCode == 200) {
                                final Map<String, dynamic> data =
                                    json.decode(response.body);
                                setState(() {
                                  // Update isLiked and likes based on the server response
                                  isLiked = data['liked'];
                                  widget.likes = data['likes'];
                                });
                              } else {
                                print(
                                    'Failed to like or unlike the post. Status code: ${response.statusCode}');
                              }
                            },
                          ),
                          Text('${widget.likes} likes'),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.comment),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostCommentsPage(postId: widget.postId),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () async {
                          const url =
                              'https://youtu.be/dQw4w9WgXcQ?si=eWBKRRDwSWFKDzgv';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            // Can't launch the URL, handle the error
                            print('Could not launch $url');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final VoidCallback onHomePressed;
  final VoidCallback onMapPressed;
  final VoidCallback onNotificationsPressed;

  CustomBottomNavigationBar({
    required this.onHomePressed,
    required this.onMapPressed,
    required this.onNotificationsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Events',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 0:
            onHomePressed();
            break;
          case 1:
            onMapPressed();
            break;
          case 2:
            onNotificationsPressed();
            break;
        }
      },
    );
  }
}
