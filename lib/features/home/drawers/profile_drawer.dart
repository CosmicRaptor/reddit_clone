import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/pallet.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});
  
  void logOut(WidgetRef ref){
    ref.read(AuthControllerProvider.notifier).logOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
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
              onTap: (){},
            ),
            ListTile(
              title: const Text('Log out'),
              leading: Icon(Icons.exit_to_app, color: Pallete.redColor,),
              onTap: () => logOut(ref)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.sunny),
                Switch.adaptive(value: true, onChanged: (value){}),
                Icon(Icons.nightlight_round_rounded)
              ],
            )
          ],
        ),
      ),
    );
  }
}