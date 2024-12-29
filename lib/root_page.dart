import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:distribuidora_app/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';

import 'cart_page.dart';
import 'favorite_page.dart';
import 'profile_page.dart';

class RootPage extends HookConsumerWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final bottomNavIndex = useState<int>(0);

    List<Widget> widgetOptions() {
      return [
        const HomePage(),
        const FavoritePage(),
        const CartPage(),
        const ProfilePage(),
      ];
    }

    List<IconData> iconList = const [
      Icons.home,
      Icons.favorite,
      Icons.shopping_cart,
      Icons.person
    ];

    List<String> iconTitle = const [
      'Home',
      'Favorite',
      'Cart',
      'Profile',
    ];

    return Scaffold(
      body: IndexedStack(
        index: bottomNavIndex.value,
        children: widgetOptions(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Asegura bordes redondeados
        ),
        onPressed: () {
          Navigator.push(
              context,
              PageTransition(
                  child: const Center(
                    child: Text('Scan Page'),
                  ),
                  type: PageTransitionType.bottomToTop));
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.qr_code_scanner_outlined,
          color: Theme.of(context).colorScheme.onPrimary,
          size: 35,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
          splashColor: Theme.of(context).colorScheme.primary,
          activeColor: Theme.of(context).colorScheme.primary,
          inactiveColor: Colors.black.withOpacity(.5),
          icons: iconList,
          activeIndex: bottomNavIndex.value,
          gapLocation: GapLocation.center,
          notchSmoothness: NotchSmoothness.softEdge,
          onTap: (index) {
            bottomNavIndex.value = index;
          }),
    );
  }
}
