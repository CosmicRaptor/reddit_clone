//logged out and logged in routes

import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/screens/login_screen.dart';
import 'package:reddit_clone/features/community/screens/community_screen.dart';
import 'package:reddit_clone/features/community/screens/create_community.dart';
import 'package:routemaster/routemaster.dart';

import 'features/home/screens/home_screen.dart';

final loggedOutRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
});

final loggedInRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(child: CommunityScreen(
    name: route.pathParameters['name']!,
  ))
});