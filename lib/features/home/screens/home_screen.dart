import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/feed/screens/feed_screen.dart';
import 'package:reddit_clone/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/drawers/community_list_drawer.dart';
import 'package:reddit_clone/features/home/drawers/profile_drawer.dart';
import 'package:reddit_clone/theme/pallet.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }

  void navigateToAddPostScreen (BuildContext context){
    Routemaster.of(context).push('/add-post');
  }

  void refreshSortMethod(){
    setState(() {
      //this should work I guess?
    });
  }
  String? sortChoice = 'top';

  @override
  Widget build(BuildContext context) {
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
            showDialog(context: context, builder: (context) => StatefulBuilder(
              builder: (context, setstate) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Dialog(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: 120,
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Top'),
                              leading: Radio(
                                value: 'top',
                                groupValue: sortChoice,
                                onChanged: (value) {
                                  setState(() {
                                    sortChoice = value!;
                                    refreshSortMethod();
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('New'),
                              leading: Radio(
                                value: 'new',
                                groupValue: sortChoice,
                                onChanged: (value) {
                                  setState(() {
                                    sortChoice = value!;
                                    refreshSortMethod();
                                    Navigator.of(context).pop();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            ));
          }, icon: const Icon(Icons.sort)),
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
      endDrawer:  const ProfileDrawer(),
      body: FeedScreen(sortChoice),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigateToAddPostScreen(context),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: currentTheme.iconTheme.color,),
      ),
    );
  }
}
