import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavBar extends StatelessWidget {
  final void Function(int)? onTabChange;
  const MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            color: const Color.fromARGB(255, 1, 130, 117),
            padding: EdgeInsets.symmetric(
                horizontal: orientation == Orientation.portrait ? 7 : 165),
            child: GNav(
              color: Colors.grey[200],
              activeColor: Colors.grey.shade900,
              tabActiveBorder: Border.all(color: Colors.white),
              tabBackgroundColor: Colors.grey.shade100,
              mainAxisAlignment: MainAxisAlignment.center,
              tabBorderRadius: 35,
              onTabChange: (value) => onTabChange!(value),
              tabs: const [
                GButton(
                  icon: Icons.dining,
                  text: 'Inicio',
                ),
                GButton(
                  icon: Icons.group_work_outlined,
                  text: 'Pupusas',
                ),
                GButton(
                  icon: Icons.coffee,
                  text: 'Bebidas',
                ),
                GButton(
                  icon: Icons.shopping_bag_rounded,
                  text: 'Pedidos',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
