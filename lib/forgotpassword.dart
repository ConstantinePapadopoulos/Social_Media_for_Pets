import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ξέχασα τον κωδικό μου'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Νέος κωδικός πρόσβασης',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Επιβεβαιώση κωδικού πρόσβασης',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => changePassword(context),
              child: Text('Αλλαγή κωδικού'),
            ),
          ],
        ),
      ),
    );
  }

  void changePassword(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/change-password'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'new_password': newPasswordController.text,
          'confirm_password': confirmPasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Password changed successfully
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Αλλαγή κωδικού πρόσβασης'),
              content: Text('Ο κωδικός σας άλλαξε επιτυχώς!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigate back to the login page
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Πρόβλημα Αλλαγής κωδικού πρόσβασης'),
              content: Text('Προσπαθήστε ξανά!'),
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
    } catch (e) {
      print('Error during password change: $e');
    }
  }
}
