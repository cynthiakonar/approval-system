import 'package:approval_system/features/administrator/admin_screen.dart';
import 'package:approval_system/features/approver/approver_screen.dart';
import 'package:approval_system/features/requester/requester_screen.dart';
import 'package:approval_system/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          margin: const EdgeInsets.all(defaultPadding),
          padding: const EdgeInsets.all(defaultPadding),
          decoration: const BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    width: 30,
                  ),
                  SizedBox(width: defaultPadding / 2),
                  const Text(
                    "Approval System",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColor.withOpacity(0.15),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(defaultPadding),
                    ),
                    labelText: 'Email ID',
                    hintText: 'abc@gmail.com',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email cannot be empty";
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return ("Please enter a valid email");
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    emailController.text = value!;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(height: defaultPadding / 2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColor.withOpacity(0.15),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(defaultPadding),
                    ),
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    RegExp regex = new RegExp(r'^.{6,}$');
                    if (value!.isEmpty) {
                      return "Password cannot be empty";
                    }
                    if (!regex.hasMatch(value)) {
                      return ("please enter valid password min. 6 character");
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    passwordController.text = value!;
                  },
                ),
              ),
              const SizedBox(height: defaultPadding * 1.5),
              Container(
                height: 50,
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(defaultPadding / 2)),
                child: ElevatedButton(
                  onPressed: () {
                    emailLogin(emailController.text, passwordController.text);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ),
    );
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    // print(user!.email);
    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get()
        .then((snapshot) {
      if (snapshot.docs[0].data()['role'] == "Administrator") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminScreen(),
          ),
        );
      } else if (snapshot.docs[0].data()['role'] == "Approver") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ApproverScreen(emailId: snapshot.docs[0].data()['email']),
          ),
        );
      } else if (snapshot.docs[0].data()['role'] == "Requester") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RequesterScreen(emailId: snapshot.docs[0].data()['email']),
          ),
        );
      } else {
        print('Document does not exist on the database');
      }
    });
  }

// login with email & password
  Future emailLogin(String email, String password) async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      route();
    } catch (ex) {
      switch (ex) {
        case 'user-disabled':
          print(ex.toString());
          return null;
        case 'invalid-email':
          print(ex.toString());
          return null;
        case 'user-not-found':
          print(ex.toString());
          return null;
        case 'wrong-password':
          print(ex.toString());
          return null;
        default:
          print(ex.toString());
          return null;
      }
    }
  }
}
