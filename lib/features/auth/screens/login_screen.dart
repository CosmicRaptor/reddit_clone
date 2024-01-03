import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref){
    ref.read(AuthControllerProvider).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.grey.shade900,
        title: const Text('Sign in', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 50,),
          Center(child: SvgPicture.asset('lib/assets/images/jubler.svg', width: 300, height: 300)),
          const SizedBox(height: 160,),
          SignInButton(Buttons.googleDark, onPressed: () => signInWithGoogle(context, ref)),
        ],
      )
    );
  }
}
