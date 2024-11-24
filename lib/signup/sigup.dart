
import 'package:flutter/material.dart';
import 'package:text/service/auth.dart';
import 'package:text/screens/login/loginsign.dart';
import 'package:text/screens/otpscreen/otp%20verification.dart';

class MyPhones extends StatefulWidget {
  const MyPhones({Key? key}) : super(key: key);

  @override
  State<MyPhones> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhones> {
  TextEditingController countryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    countryController.text = "+91"; 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://img.freepik.com/premium-vector/hand-drawn-vpn-illustration_23-2149229488.jpg?w=740',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 30),
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome! Please enter your phone number to continue.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                height: 55,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        readOnly: true,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Phone",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 166, 11, 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
onPressed: () async {
  String phoneNumber = countryController.text + phoneController.text.trim();

  if (_isValidPhoneNumber(phoneNumber)) {
    String otp = _authService.generateOtp();

    bool otpSent = await _authService.sendOtp(phoneNumber, otp);

    if (otpSent) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            phoneNumber: phoneNumber, 
            otp: otp, 
          ),
        ),
      );
    } else {
      _showErrorDialog(context, "Failed to send OTP. Please try again.");
    }
  } else {
    _showErrorDialog(context, "Please enter a valid phone number.");
  }
},

                  child: const Text(
                    "Send the code",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.grey),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => loginscreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                      )
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    final regex = RegExp(r'^\+[1-9]\d{1,14}$');
    return regex.hasMatch(phoneNumber);
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
