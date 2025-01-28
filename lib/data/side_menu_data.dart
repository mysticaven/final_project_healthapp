import 'package:fitness_dashboard_ui/model/dashboard_page.dart';
import 'package:fitness_dashboard_ui/model/exercise_page.dart';
import 'package:fitness_dashboard_ui/model/menu_model.dart';
import 'package:fitness_dashboard_ui/model/profile_page.dart';
import 'package:fitness_dashboard_ui/model/signout_page.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = const <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.person, title: 'Profile'),
    MenuModel(icon: Icons.run_circle, title: 'Exercise'),
    MenuModel(icon: Icons.logout, title: 'SignOut'),
  ];

  // Method to handle navigation based on the selected menu item
  void navigateToPage(BuildContext context, String title) {
    switch (title) {
      case 'Dashboard':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
        break;
      case 'Profile':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
      case 'Exercise':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ExercisePage()),
        );
        break;

      case 'SignOut':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignOutPage()),
        );
        break;
      default:
        break;
    }
  }
}
