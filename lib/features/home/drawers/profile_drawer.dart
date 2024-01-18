import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallet.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  
  void logOut(WidgetRef ref){
    ref.read(AuthControllerProvider.notifier).logOut();
  }

  void navigateToUserProfile(BuildContext context, String uid){
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref){
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
                radius: 75,
              ),
              const SizedBox(height: 10,),
              Text(user.name, style: const TextStyle(fontSize: 26),),
              const SizedBox(height: 10,),
              const Divider(),
              ListTile(
                title: const Text('Profile'),
                leading: const Icon(Icons.person),
                onTap: () => navigateToUserProfile(context, user.uid),
              ),
              ListTile(
                title: const Text('Log out'),
                leading: Icon(Icons.exit_to_app, color: Pallete.redColor,),
                onTap: () => logOut(ref)
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.sunny),
                    Switch.adaptive(value: ref.watch(themeNotifierProvider.notifier).mode == ThemeMode.light ? false : true, onChanged: (value)=> toggleTheme(ref)),
                    const Icon(Icons.nightlight_round_rounded)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}