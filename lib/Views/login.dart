// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:kalorist_mvp/Views/Home.dart';
import 'package:kalorist_mvp/Views/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  void _showErrorToast() {
    Fluttertoast.showToast(
      msg: "Invalid Username or Password",
      timeInSecForIosWeb: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(
              flex: 1,
            ),
            Text(
              "Login",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 19, 15, 104),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _email,
              decoration: InputDecoration(hintText: "Email"),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(hintText: "Password"),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: _email.text, password: _password.text);

                      User? user = FirebaseAuth.instance.currentUser;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(
                                  email: user!.email,
                                  id: user.uid,
                                )),
                      );
                    } catch (e) {
                      _showErrorToast();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        Color.fromARGB(255, 19, 15, 104), // Background color
                    onPrimary: Colors.white, // Text color
                    elevation: 2, // Elevation (shadow)
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30.0), // Button border radius
                    ),
                    padding: EdgeInsets.all(10.0), // Button padding
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Register()),
                  );
                },
                child: Text(
                  "Dont have an account?",
                ),
              ),
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
