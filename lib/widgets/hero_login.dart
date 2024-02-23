import 'package:flutter/material.dart';

class HeroLogin extends StatelessWidget {
  final bool isLoginPage;
  final String? username;
  HeroLogin({
    super.key,
    this.isLoginPage = false,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Image.asset(
          'assets/images/login-image.png',
          fit: BoxFit.cover,
          height: isLoginPage ? 350.0 : 83.0,
          width: double.infinity,
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black54,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isLoginPage ? 'Welcome to\nFood Mo!' : 'Welcome, ${username}!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 30.0,
                ),
              ),
              isLoginPage
                  ? Text(
                      'Please login to continue!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
