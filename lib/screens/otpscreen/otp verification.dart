import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:text/screens/home/home.dart';
import 'package:text/service/auth.dart';

class OTPVerificationScreen extends StatefulWidget {
  // final String verificationId;
  final String phoneNumber;
  final String otp;


  const OTPVerificationScreen({Key? key, required this.phoneNumber, required this.otp})
      : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final AuthService _authService = AuthService();
  String otpCode = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.1),
           
            const SizedBox(height: 20),
            const Text(
              "Enter the OTP sent to your phone",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: OtpTextField(
                  numberOfFields: 6,
                  borderColor: const Color(0xFF512DA8),
                  fieldWidth: 40,
                  textStyle: const TextStyle(fontSize: 18),
                  showFieldAsBox: true,
                  onCodeChanged: (String code) {
                    setState(() {
                      otpCode = code;
                
                    });},
                  onSubmit: (String verificationCode) {
                    setState(() {
                      otpCode = verificationCode;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                
              if (otpCode == widget.otp) {
                 Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            email: widget.phoneNumber,
            
          ),
        ),
      );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Invalid OTP. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Verify OTP', style: TextStyle(fontSize: 18 ,color: Colors.white),),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF512DA8),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
