import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../state.dart';
import '../../common/app_colors.dart';
import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context,
      HomeViewModel viewModel,
      Widget? child,
      ) {
    return Scaffold(
      body: viewModel.pages[viewModel.selectedTab],
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: uiMode,
        builder: (context, AppUiModes mode, child) {
          Color iconColor = mode == AppUiModes.dark ? Colors.white : Colors.grey;
          Color selectedColor = mode == AppUiModes.dark ? Colors.white : kcPrimaryColor;
          // ValueListenable<List<dynamic>> filteredNotifications = ValueNotifier(
          //     notifications.value.where((notification) => notification.status != 1).toList()
          // );
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: mode == AppUiModes.dark ? Colors.black.withOpacity(0.9) : Colors.white.withOpacity(0.9),
            selectedLabelStyle: TextStyle(color: selectedColor),
            selectedItemColor: selectedColor,
            unselectedItemColor: iconColor,
            onTap: viewModel.changeSelected,
            currentIndex: viewModel.selectedTab,
            items: [
              BottomNavigationBarItem(
                icon: _navBarItemIcon(Icons.home_outlined, "Home", viewModel.selectedTab == 0, iconColor),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: _navBarItemIcon(Icons.miscellaneous_services, "Services", viewModel.selectedTab == 1, iconColor),
                label: "Services",
              ),
              BottomNavigationBarItem(
                icon: _navBarItemIcon(Icons.notifications, "Notification", viewModel.selectedTab == 2, iconColor),
                label: "Notification",
              ),
              // BottomNavigationBarItem(
              //   icon: _navBarItemWithCounter(Icons.shopping_cart_outlined, viewModel.selectedTab == 2, cart, iconColor),
              //   label: "Cart",
              // ),
              // //TODO : MAKE SURE TO CHECK WHY THE VALUE ISNT CORRECT
              // BottomNavigationBarItem(
              //   icon: _navBarItemWithCounter(Icons.notifications_none, viewModel.selectedTab == 3, filteredNotifications, iconColor),
              //   label: "Notifications",
              // ),
              BottomNavigationBarItem(
                icon: _navBarItemIcon(Icons.person_outline, "Account", viewModel.selectedTab == 3, iconColor),
                label: "Account",
              ),
            ],
          );
        },
      ),
    );


  }

  Widget _navBarItemIcon(IconData iconData, String label, bool isSelected, Color iconColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? kcPrimaryColor.withOpacity(0.2) : Colors.transparent,
      ),
      child: Icon(
        iconData,
        color: isSelected ? kcPrimaryColor : iconColor,
      )
    );
  }

  Widget _navBarItemWithCounter(IconData icon, bool isSelected, ValueListenable<List<dynamic>> counterListenable, Color color) {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: counterListenable,
      builder: (context, value, child) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _navBarItemIcon(icon, '', isSelected, color),
            if (value.isNotEmpty)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${value.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  HomeViewModel viewModelBuilder(
      BuildContext context,
      ) =>
      HomeViewModel();
}
