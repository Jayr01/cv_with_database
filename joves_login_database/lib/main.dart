import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'resumeMain.dart'; // Import your hello.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'joves Resume',
      theme: ThemeData(
        primarySwatch:  Colors.green,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
      },
    );
  }
}




class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  String? errorMessage;

  

  // Validation function for the password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  Future<void> login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
       Uri.parse('http://localhost/flutter_auth/login.php'),
        body: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );

      final responseData = json.decode(response.body);

      if (responseData['status'] == 'success') {
        // Handle successful login

         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResumeScreen()),
        );
        print('Login successful');
      } else {
        // Handle login error
        setState(() {
          errorMessage = 'Invalid credentials. Please check your username or password.';
        });
        print('Login failed: ${responseData['message']}');

         Future.delayed(Duration(seconds: 3), () {
          setState(() {
            errorMessage = null;
          });
        });
      }
    }
  }

  // Form key to validate the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(

          
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Image(
                image: AssetImage('assets/picture/jr.png'),
                height: 280,
                width: 280,
              ),
              
               if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                
              TextFormField(
                
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: !showPassword,
                validator: validatePassword,
              ),
              SizedBox(height: 16.0),
              Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: login,
                child: Text('Login'),
              ),
            ),
             
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: Text('Don\'t have an account? Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool showPassword = false;

  // Validation function for the username
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  // Validation function for the password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  // Validation function for the email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // You can add more sophisticated email validation if needed
    return null;
  }

  Future<void> signUp() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        final response = await http.post(
          Uri.parse('http://localhost/flutter_auth/auth.php'),
          body: {
            'username': usernameController.text,
            'password': passwordController.text,
            'email': emailController.text,
          },
        );

        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          // Handle successful signup
          print('Signup successful');

          // Show success message alert
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text('Signup successful!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Navigate back to the login screen
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('Login'),
                  ),
                ],
              );
            },
          );
        } else {
          // Handle signup error
          print('Signup failed: ${responseData['message']}');
          // You can display an error message if needed
        }
      }
    } catch (error) {
      print('Error during signup: $error');
      // Handle other errors here
    }
  }

  // Form key to validate the form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
         child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

               const Image(
                image: AssetImage('assets/picture/jr.png'),
                height: 260,
                width: 260,
              ),
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: validateUsername,
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                  ),
                ),
                obscureText: !showPassword,
                validator: validatePassword,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                //  validator: validateEmail,
                validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email address';
    }
    return null;
  },  
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: signUp,
                child: Text('Sign Up'),
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to the login screen
                },
                child: Text('Already have an account? Login'),
              ),

                
            ],
          ),
        ),
      ),
      ),
    );
  }
}


