import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController _controller = TextEditingController();
  bool _isQuestionVisible = false;  
  bool _isTextFieldBlocked = false;  
  bool _isSubmitted = false; 
  int _timeLeft = 30;  
  late Timer _timer;
    // Declare the email parameter

  

  void _startTimer() {
    _isQuestionVisible = true; 
    _timeLeft = 30;  
    _isTextFieldBlocked = false; 

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _isTextFieldBlocked = true;  
          _timer.cancel();  
        }
      });
    });
  }

  void _submitAnswer() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Answer Submitted'),
        content: Text('Your answer has been submitted successfully!'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context); 
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
    setState(() {
      _isSubmitted = true;  
    });
  }

  @override
  void dispose() {
    _timer.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )
                ),
                onPressed: () {
                  _startTimer();  
                },
                child: AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText(
                      'Win Certificate',
                      textStyle: TextStyle(fontSize: 24),
                      colors: [
                        Colors.white,
                       
                        Colors.black,
                        
                      ],
                      speed: Duration(milliseconds: 100),
                    )
                  ],
                  onTap: (){
                     _startTimer();  


                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_isQuestionVisible && !_isSubmitted) ...[
              Center(
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Tell me About Yourself?',
                      textStyle: TextStyle(fontSize: 24),
                      speed: Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: _timeLeft <= 10 ? Colors.red : Colors.black, // Change border color when time is 5 or less
                      ),
                    ),
                    hintText: 'Your answer here...',
                  ),
                  enabled: !_isTextFieldBlocked,  
                ),
              ),
              SizedBox(height: 16),
              if (_isTextFieldBlocked) ...[
                Center(
                  child: ElevatedButton(
                    onPressed: _submitAnswer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    child: AnimatedTextKit(animatedTexts: [
                      ColorizeAnimatedText(
                        'Submit Answer',
                        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        colors: [Colors.white, Colors.green],
                        speed: Duration(milliseconds: 100),),
                        
                    ],
                    onTap: () {
                      _submitAnswer();
                    },
                    ),
                  ),
                ),
              ],
              if (!_isTextFieldBlocked) ...[
                Center(child: Text('Time Left: $_timeLeft seconds')),
              ],
            ],
            if (_isSubmitted) ...[
              SizedBox(height: 50),
              Column(
                children: [
                  Center(
                    child: AnimatedTextKit(
                      animatedTexts: [
                        ScaleAnimatedText(
                          'You have submitted your answer!',
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          duration: Duration(seconds: 3),
                        ),
                      
                        ScaleAnimatedText(
                          'You have won a certificate!',
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          duration: Duration(seconds: 3),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Image.network(
                      'https://cdn.pixabay.com/animation/2023/03/19/19/55/19-55-58-835_512.gif',
                      width: 200,
                      height: 200,
                    ),
                  )
                ],

              ),
            ],
          ],
        ),
      ),
    );
  }
}
