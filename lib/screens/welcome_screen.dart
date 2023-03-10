import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flach_chat/components/rounded_button.dart';



class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      lowerBound: 0.0,
      upperBound: 1.0,
      duration: const Duration(seconds: 1),
    );

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    //animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    // controller.reverse(from: 1.0);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      //print(controller.value);
      print(animation.value);
    });
    // animation.addListener(() {
    //   //print(animation.status);
    //   if (animation.status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (animation.status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: 60,
                    child: Image.asset('images/logo.png'), //animation.value * 100
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: const Duration(milliseconds: 120),
                  textAlign: TextAlign.start,
                  textStyle: const TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                    color: Colors.lightBlueAccent,
                  ),
                  text: const ['Flash Chat'],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              color: Colors.lightBlueAccent,
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              color: Colors.blueAccent,
              onPress: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}



// Padding(
//               padding: EdgeInsets.symmetric(vertical: 16.0),
//               child: Material(
//                 elevation: 5.0,
//                 color: Colors.lightBlueAccent,
//                 borderRadius: BorderRadius.circular(30.0),
//                 child: MaterialButton(
//                   onPressed: () {
//                     //Go to login screen.
//                     Navigator.pushNamed(context, LoginScreen.id);
//                   },
//                   minWidth: 200.0,
//                   height: 42.0,
//                   child: Text(
//                     'Log In',
//                   ),
//                 ),
//               ),
//             ),

// Padding(
//               padding: EdgeInsets.symmetric(vertical: 16.0),
//               child: Material(
//                 color: Colors.blueAccent,
//                 borderRadius: BorderRadius.circular(30.0),
//                 elevation: 5.0,
//                 child: MaterialButton(
//                   onPressed: () {
//                     //Go to registration screen.
//                     Navigator.pushNamed(context, RegistrationScreen.id);
//                   },
//                   minWidth: 200.0,
//                   height: 42.0,
//                   child: Text(
//                     'Register',
//                   ),
//                 ),
//               ),
//             ),

