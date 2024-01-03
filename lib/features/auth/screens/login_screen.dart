import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/loader.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInWithGoogle(BuildContext context, WidgetRef ref){
    ref.read(AuthControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(AuthControllerProvider);
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.grey.shade900,
        title: const Text('Sign in', style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: isLoading ? const Loader(): Column(
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
