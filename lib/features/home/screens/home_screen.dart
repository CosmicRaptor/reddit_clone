import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/feed/screens/feed_screen.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_clone/features/home/drawers/profile_drawer.dart';
import 'package:reddit_clone/theme/pallet.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }
  
  void displayEndDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  void navigateToAddPostScreen (BuildContext context){
    Routemaster.of(context).push('/add-post');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => displayDrawer(context),
            );
          }
        ),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: SearchCommunityDelegate(ref));
          }, icon: const Icon(Icons.search)),
          Builder(
            builder: (context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                  maxRadius: 16,
                ),
                onPressed: () => displayEndDrawer(context),
              );
            }
          )
        ],
      ),
      drawer: const CommunityListDrawer(),
      endDrawer:  ProfileDrawer(),
      body: FeedScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddPostScreen(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: currentTheme.iconTheme.color,),
      ),
    );
  }
}
