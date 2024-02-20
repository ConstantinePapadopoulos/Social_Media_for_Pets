import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homepage.dart';
import 'forgotpassword.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Woof World',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(), // Use SplashScreen as the initial route
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay of 3 seconds and then navigate to LoginPage
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/paw1.png',
              height: 200,
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

// class LoginPage extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: passwordController,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Password'),
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () => login(context),
//               child: Text('Login'),
//             ),
//             SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 // Navigate to SignUpPage when the "Sign Up" button is pressed
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SignUpPage()),
//                 );
//               },
//               child: Text('Sign Up'),
//             ),
//             SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 // Navigate to ForgotPasswordPage when the "Forgot Password" button is pressed
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
//                 );
//               },
//               child: Text('Forgot Password'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void login(BuildContext context) async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://10.0.2.2:5000/api/login'),
//         headers: {'Content-Type': 'application/json'},
//         body: json.encode({
//           'email': emailController.text,
//           'password': passwordController.text,
//         }),
//       );

//       if (response.statusCode == 200) {
//         // Extract user ID from the response
//         final Map<String, dynamic> data = json.decode(response.body);
//         final int userId = data['user_id'];

//         // Store the user ID globally
//         UserAuth.userId = userId;

//         // Navigate to HomePage
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => HomePage()),
//         );
//       } else {
//         // Show error dialog
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Login Error'),
//               content: Text('Invalid credentials. Please try again!'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     } catch (e) {
//       print('Error during login: $e');
//     }
//   }
// }

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80), // Adjust the size as per the design
              Image.asset(
                'assets/paw1.png',
                //height: 50,
              ),
              SizedBox(height: 50), // Spacing between text and text fields
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email ή Όνομα χρήστη',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Κωδικός Πρόσβασης',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => login(context),
                child: Text(
                  'Είσοδος🐾',
                  style: TextStyle(
                    fontSize: 18, // Set your desired font size here
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text(
                  'Ξέχασα τον κωδικό μου',
                  style: TextStyle(
                    fontSize: 18, // Set your desired font size here
                  ),
                ), // Forgot my password in Greek
              ),
              SizedBox(height: 18), // Spacing before the bottom text
              Divider(),
              SizedBox(height: 250), // Spacing before the bottom text

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text(
                  'Δεν έχεις λογαριασμό; Join Woof World!',
                  style: TextStyle(
                    fontSize: 18, // Set your desired font size here
                  ),
                ), // Sign up in Greek
              ),
            ],
          ),
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // Extract user ID from the response
        final Map<String, dynamic> data = json.decode(response.body);
        final int userId = data['user_id'];

        // Store the user ID globally
        UserAuth.userId = userId;

        // Navigate to HomePage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Σφάλμα εισόδου'),
              content: Text(
                  'Λάθος κωδικός πρόσβασης ή email(demo: email: example@email.com, password:pass2)'),
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
      print('Error during login: $e');
    }
  }
}

// Create a class to hold the user ID globally
class UserAuth {
  static int userId = 0;
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String selectedAccountType = 'Private'; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, //
      appBar: AppBar(
        title: Text('Εγγραφή'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(), // Corrected line
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nicknameController,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  border: OutlineInputBorder(), // Corrected line
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Κωδικός Πρόσβασης',
                  border: OutlineInputBorder(), // Corrected line
                ),
              ),
              SizedBox(height: 16),
              DropdownButton<String>(
                value: selectedAccountType,
                onChanged: (String? value) {
                  setState(() {
                    selectedAccountType = value!;
                  });
                },
                items: <String>['Private', 'Business'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              if (selectedAccountType == 'Business')
                TextField(
                  controller: businessNameController,
                  decoration: InputDecoration(
                    labelText: 'Επωνυμία',
                    border: OutlineInputBorder(), // Corrected line
                  ),
                ),
              if (selectedAccountType == 'Business') SizedBox(height: 16),
              if (selectedAccountType == 'Business')
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Τηλέφωνο',
                    border: OutlineInputBorder(), // Corrected line
                  ),
                ),
              if (selectedAccountType == 'Business') SizedBox(height: 16),
              if (selectedAccountType == 'Business')
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Διεύθυνση',
                    border: OutlineInputBorder(), // Corrected line
                  ),
                ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => signUp(context),
                child: Text('Εγγραφή'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(BuildContext context) async {
    if (nicknameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      // Show an alert or snackbar to inform the user that all fields are required
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Παρακαλώ συμπληρώστε όλα τα πεδία!'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop the function if any field is empty
    }
    if (selectedAccountType == 'Business' &&
        (phoneController.text.isEmpty ||
            addressController.text.isEmpty ||
            businessNameController.text.isEmpty)) {
      // Show an alert or snackbar to inform the user that all fields are required
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Παρακαλώ συμπληρώστε όλα τα πεδία!'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop the function if any field is empty
    }
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/signup'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': emailController.text,
          'nickname': nicknameController.text,
          'password': passwordController.text,
          'account_type': selectedAccountType,
          'business_name': selectedAccountType == 'Business'
              ? businessNameController.text
              : null,
          'phone':
              selectedAccountType == 'Business' ? phoneController.text : null,
          'address':
              selectedAccountType == 'Business' ? addressController.text : null,
        }),
      );

      if (response.statusCode == 200) {
        print('Sign Up successful');
        // Navigate to the login screen upon successful signup
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        print('Failed to sign up. Status code: ${response.statusCode}');
        // Handle signup failure (show error message, etc.)
      }
    } catch (e) {
      print('Error during signup: $e');
    }
  }
}
