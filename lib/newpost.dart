import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'homepage.dart';

class NewPostPage extends StatefulWidget {
  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  late Map<String, dynamic> userInfo;

  final TextEditingController locationController = TextEditingController();
  File? selectedImage;

  Future<void> pickImageFromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;

    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  Future<void> pickImageFromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;
    setState(() {
      selectedImage = File(returnedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Δημιουργία Νέου Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickImageFromGallery,
              child: Text('Φωτογραφία από συλλογή'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: pickImageFromCamera,
              child: Text('Φωτογραφία από κάμερα'),
            ),
            SizedBox(height: 16),
            selectedImage != null
                ? Image.file(
                    selectedImage!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : Container(),
            SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Περιοχή'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => createPost(context),
              child: Text('Δημιουργία Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createPost(BuildContext context) async {
    if (selectedImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Σφάλμα'),
            content: Text('Παρακαλώ διαλέξτε εικόνα.'),
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
      return;
    }

    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:5000/create_post'),
    );

    // Add other fields to the request
    request.fields['location'] = locationController.text;
    request.fields['user_id'] = UserAuth.userId.toString();
    request.fields['likes'] = '0';
    request.fields['image_path'] = 'assets/pet26.png';

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Post created successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        print('Failed to create post. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }
}
