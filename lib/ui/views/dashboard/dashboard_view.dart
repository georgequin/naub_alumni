import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:kenmack/state.dart';
import 'package:kenmack/ui/views/dashboard/recommendedCard.dart';
import 'package:openapi/api.dart';
import 'package:stacked/stacked.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import 'dashboard_viewmodel.dart';
import 'details_view.dart';

class DashboardView extends StackedView<DashboardViewModel> {
  DashboardView({Key? key}) : super(key: key);


  final PageController _pageController = PageController();
  bool _isCardVisible = true;

  bool get isCardVisible => _isCardVisible;




  @override
  void initState() {

  }


  @override
  void dispose() {

  }

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      // appBar: AppBar(
      //   title: ValueListenableBuilder(
      //   valueListenable: uiMode,
      //   builder: (context, AppUiModes mode, child) {
      //     return Image.asset(
      //       mode == AppUiModes.dark ? "assets/images/afriprize_light.png" : "assets/images/afriprize.png",
      //       width: 150,
      //       height: 50,
      //     );
      //   },
      // ),
      //   actions: [
      //     userLoggedIn.value == false
      //         ? Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: TextButton(
      //               style: ButtonStyle(
      //                   backgroundColor:
      //                       MaterialStateProperty.all(kcPrimaryColor)),
      //               onPressed: () {
      //                 locator<NavigationService>().replaceWithAuthView();
      //               },
      //               child: const Text(
      //                 "Login",
      //                 style: TextStyle(color: kcWhiteColor),
      //               ),
      //             ),
      //           )
      //         : const SizedBox()
      //   ],
      // ),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.refreshData();
        },
        child: ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 50),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 0.0, right: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${profile.value.firstName},',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'Welcome!',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ),
                Container(
                  padding: EdgeInsets.all(6), // You can adjust the padding to your needs
                  decoration: BoxDecoration(
                    color: kcPrimaryColor.withOpacity(0.4), // Background color
                    shape: BoxShape.circle, // Makes the container circular
                  ),
                  child: Icon(
                    Icons.person_2_rounded,
                    color: kcPrimaryColor, // Icon content color
                    size: 29,
                  ),
                )

              ],
            ),
            if (viewModel.isCardVisible)
              Dismissible(
                key: Key('dismiss_card'),
                onDismissed: (direction) {
                  viewModel.hideCard(); // Call viewModel to handle dismiss
                },
                child: Card(
                  color: kcFadeColor, // Set the background color of the card
                  margin: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), // Increase the radius here
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'To provide a platform where Kenyan Nurses and Midwives '
                              'can communicate and collaborate with other like-minded '
                              'people or organisations, with the aim of striving for excellence.',
                          style: TextStyle(
                            fontSize: 11,
                            color: kcPrimaryColor,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: kcPrimaryColor, // Darker shade for the button
                              primary: Colors.white, // Text color for the button
                            ),
                            onPressed: () {
                              viewModel.hideCard();
                            },
                            child: Text('HIDE'),
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              ),

            if(viewModel.recommendedService.isNotEmpty)
              const Text(
              "Recommended",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                  fontFamily: "Panchang"
              ),
            ),
            if(viewModel.recommendedService.isNotEmpty)
              SizedBox(
                 height: 170,
                child: viewModel.busy(viewModel.recommendedService)
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.recommendedService.length,
                  itemBuilder: (context, index) {
                    Service recommended = viewModel.recommendedService[index];
                    return Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 15, top: 10),
                      width: 260,
                      decoration: BoxDecoration(
                        color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcBlackColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: kcBlackColor.withOpacity(0.1),
                            offset: const Offset(0, 4),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ServiceDetailsPage(service: recommended),
                          ));
                        },
                        child: ReccommendedCard(
                          title: recommended.title ?? 'service',
                          buttonText: 'Explore more',
                          imageUrl: recommended.picture?.url ?? 'https://via.placeholder.com/120', // Replace with your actual image URL
                          onClick: () {
                            print('Card clicked');
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ServiceDetailsPage(service: recommended),
                            ));
                          },
                        )
                      ),

                    );
                  },
                ),
              ),
            verticalSpaceMedium,
            const Text(
              "Top things you need to do",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Panchang"
              ),
            ),
            verticalSpaceSmall,
            viewModel.busy(viewModel.services)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : viewModel.services.isEmpty ?
            const Center(child: Text('No service available')) :
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.5,
                ),
                itemCount: viewModel.services.length,
                itemBuilder: (context, index) {
                  if (viewModel.services.isEmpty) {
                    // Return a placeholder or an empty container
                    return Container(); // or SizedBox.shrink()
                  }

                  if (index >= viewModel.services.length) {
                    return Container(); // or SizedBox.shrink()
                  }

                  Service service = viewModel.services.elementAt(index);
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(25.0), topRight: Radius.circular(25.0)),
                            ),
                            backgroundColor: Colors.black.withOpacity(0.7),
                            builder: (BuildContext context) {
                              return FractionallySizedBox(
                                heightFactor: 0.8, // 70% of the screen's height
                                child: ServiceDetailsPage(service: service, isModal: true),
                              );
                            },
                          );

                        },
                        child:Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:   Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 0.0),
                              decoration: BoxDecoration(
                                color: kcPrimaryColor,
                                borderRadius: const BorderRadius.all( Radius.circular(12)
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all( Radius.circular(12)
                                ),
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.0, // Make the loader thinner
                                          valueColor: AlwaysStoppedAnimation<Color>(kcSecondaryColor), // Change the loader color
                                        ),
                                      ),
                                      imageUrl:  service.picture?.url ?? 'https://via.placeholder.com/150',
                                      height: 114,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      fadeInDuration: const Duration(milliseconds: 500),
                                      fadeOutDuration: const Duration(milliseconds: 300),
                                    ),
                                    Padding( // Add padding to the row
                                      padding: const EdgeInsets.fromLTRB(5.0, 5.0, 5.0,0), // Adjust padding as needed
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            service.title ?? 'service title',

                                            style: TextStyle(
                                                fontSize: 14,
                                                color: uiMode.value == AppUiModes.light ? kcSecondaryColor : kcWhiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Panchang"
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding( // Add padding to the row
                                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0,8.0), // Adjust padding as needed
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            service.provider ?? 'service provider',
                                            style:  TextStyle(
                                                fontSize: 14,
                                                color: uiMode.value == AppUiModes.light ? kcWhiteColor : kcWhiteColor,
                                                fontFamily: "Panchang"
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),),
                      ),
                      verticalSpaceMedium
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }

  @override
  void onViewModelReady(DashboardViewModel viewModel) {
    viewModel.init();
    super.onViewModelReady(viewModel);
  }


  @override
  DashboardViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DashboardViewModel();
}
