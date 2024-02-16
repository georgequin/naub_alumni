

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kenmack/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import 'onboarding_viewmodel.dart';

class OnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OnboardingViewModel>.reactive(
      viewModelBuilder: () => OnboardingViewModel(),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Align(
              //   alignment: Alignment.topRight,
              //   child: TextButton(
              //     onPressed: () {
              //       // Handle skip action
              //     },
              //     child: Text('Skip'),
              //   ),
              // ),
              Expanded(
                child: Center(
                  child:  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Image.asset('assets/images/onboarding-.png'),
                  ),
                ),

              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'KENMA-UK',
                  style: TextStyle(fontSize: 30, color: kcPrimaryColor, fontFamily: 'Poppins',  fontWeight: FontWeight.w700),
                  textAlign: TextAlign.left,
                ),
              ),
              verticalSpaceSmall,
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0,),
                child: Text(
                  'To provide a platform where Kenyan Nurses and Midwives can communicate and collaborate with other like-minded people or organisations, with the aim of striving for excellence.',
                  style: TextStyle(color: kcBlackColor, fontFamily: 'Poppins', fontSize: 15),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add padding if you want more space around the button
                        child: OutlinedButton(
                          onPressed: () {
                            locator<NavigationService>().replaceWithRegisterView();
                          },
                          child: const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 15), // Adjust font size to match the 'Login' button
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 15.0), // Add vertical padding to make the button taller
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Rounded edges
                            ),
                            side: BorderSide(color: kcPrimaryColor), // Border color
                            foregroundColor: kcPrimaryColor, // Text color
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            locator<NavigationService>().replaceWithLoginView();
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 15),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: kcPrimaryColor,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


