import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;  
import 'package:text/screens/home/home.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
//the code created to safvan
  Future<void> verifyPhoneNumber(
    String phoneNumber, 
    BuildContext context, 
    Function(String) onCodeSent
  ) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          final userCredential = await _auth.signInWithCredential(credential);

          if (userCredential.user != null) {
            await _storePhoneNumberInFirestore(userCredential.user!.phoneNumber);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  email: userCredential.user?.phoneNumber,
                ),
              ),
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Phone verification failed: ${e.message}");
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code auto-retrieval timed out");
        },
      );
    } catch (e) {
      print("Error during phone verification: $e");
    }
  }

  String generateOtp() {
    final random = Random();
    return (random.nextInt(900000) + 100000).toString();
  }

  Future<bool> sendOtp(String phoneNumber, String otp) async {
    final url = Uri.parse('https://api.twilio.com/2010-04-01/Accounts/ACf4774cfea49e78a2fa0c19e314baf177/Messages.json');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('ACf4774cfea49e78a2fa0c19e314baf177:c678b8f5bfc218d090b5ca8ba010c270')),
      },
      body: {
        'To': phoneNumber,
        'From': '+1561 810 2244',
        'Body': 'Your OTP code is: $otp', 
      },
    );

    if (response.statusCode == 201) {
      return true; 
    } else {
      print('Failed to send OTP: ${response.body}');
      return false;
    }
  }

  Future<bool> verifyOtp(String inputOtp, String generatedOtp) async {
    return inputOtp == generatedOtp;
  }
  Future<void> storePhoneNumber(String phoneNumber) async {
  final userRef = _firestore.collection('users').doc(phoneNumber);
  try {
    await userRef.set({
      'phoneNumber': phoneNumber,
      'verified': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
    print('Phone number stored in Firestore!');
  } catch (e) {
    print('Error storing phone number: $e');
  }
}

  Future<void> signInWithOTP(String verificationId, String smsCode, BuildContext context) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _storePhoneNumberInFirestore(userCredential.user!.phoneNumber);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            email: userCredential.user?.phoneNumber,
          ),
        ),
      );
    } catch (e) {
      // log("Error during OTP sign-in: $e");
    }
  }

  Future<void> _storePhoneNumberInFirestore(String? phoneNumber) async {
    if (phoneNumber != null) {
      try {
        final userRef = _firestore.collection('users').doc(phoneNumber);
        await userRef.set({
          'phoneNumber': phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // log("Phone number stored successfully: $phoneNumber");
      } catch (e) {
        // log("Error storing phone number in Firestore: $e");
      }
    }
  }

  Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      // log("Google user signed in: ${userCredential.user?.email}");

      await _storeUserData(userCredential.user?.email);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            email: userCredential.user?.displayName,
            photoUrl: userCredential.user?.photoURL,
            phoneNumber: userCredential.user?.phoneNumber,
          ),
        ),
      );

      return userCredential.user;
    } catch (e) {
      // log("Something went wrong during Google Sign-In: $e");
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      // log("User signed out successfully.");
    } catch (e) {
      // log("Something went wrong during sign out: $e");
    }
  }

  // Store user data (for Google sign-in)
  Future<void> _storeUserData(String? email) async {
    if (email == null) return;

    try {
      final userRef = _firestore.collection('users').doc(email);
      final docSnapshot = await userRef.get();

      if (!docSnapshot.exists) {
        await userRef.set({
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        // log("User data saved in Firestore: $email");
      } else {
        // log("User already exists in Firestore: $email");
      }
    } catch (e) {
      // log("Error storing user data in Firestore: $e");
    }
  }
}
