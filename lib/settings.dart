import 'package:flutter/material.dart';
import 'main.dart';
import 'learn_about_me_settings.dart';
import 'changemyinfo.dart';
import 'package:app_settings/app_settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationSound = false;
  bool locationService = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ρυθμίσεις'), // "Settings" in Greek
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              title: Text(
                  'Αλλαγη Πληρογοριών Χρήστη'), // "Learn about me!" in Greek
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeMyInfoPage()),
                );
              },
            ),
            ListTile(
              title: Text(
                  'Αλλαγή πληροφοριων: Μάθε για εμένα'), // "Change username" in Greek
              trailing: Icon(Icons.edit),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LearnAboutMeSettingsPage(userId: UserAuth.userId)),
                );
              },
            ),
            SwitchListTile(
              title: Text(
                  'Ενεργοποίηση τοποθεσίας'), // "Notification sound" in Greek
              value: locationService,

              onChanged: (bool value) {
                if (value) {
                  print(value);
                  // Open app-specific settings when switched on
                  AppSettings.openAppSettings();
                }
                setState(() {
                  locationService = value;
                });
              },
              secondary: Icon(Icons.notifications_active),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: ElevatedButton(
                child: Text('Αποσύνδεση'), // "Log out" in Greek
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Red color for the log out button
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Αποσύνδεση'),
                        content: Text('Είστε σίγουρος;'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            child: Text('Άκυρο'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Perform logout logic here
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                            child: Text('Αποσύνδεση'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ).toList(),
      ),
    );
  }
}

class ChangeNicknamePage extends StatefulWidget {
  @override
  _ChangeNicknamePageState createState() => _ChangeNicknamePageState();
}

class _ChangeNicknamePageState extends State<ChangeNicknamePage> {
  final TextEditingController _newNicknameController = TextEditingController();
  final TextEditingController _confirmNicknameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Username'), // "Settings" in Greek
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Πληκτρολόγησε τα στοιχεία σου προκειμένου να αλλάξεις το όνομα χρήστη:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _newNicknameController,
              decoration: InputDecoration(
                labelText: 'Νέο nickname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmNicknameController,
              decoration: InputDecoration(
                labelText: 'Επιβεβαίωση nickname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Αλλαγή ονόματος χρήστη'),
                onPressed: () {
                  // Handle the submit action
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _newNicknameController = TextEditingController();
  final TextEditingController _confirmNicknameController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Username'), // "Settings" in Greek
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Πληκτρολόγησε τα στοιχεία σου προκειμένου να αλλάξεις το όνομα χρήστη:',
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _newNicknameController,
              decoration: InputDecoration(
                labelText: 'Νέο nickname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmNicknameController,
              decoration: InputDecoration(
                labelText: 'Επιβεβαίωση nickname',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text('Αλλαγή ονόματος χρήστη'),
                onPressed: () {
                  // Handle the submit action
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  SettingOption({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
