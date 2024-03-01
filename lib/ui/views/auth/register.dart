
import 'package:flutter/material.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kenmack/app/app.router.dart';
import 'package:openapi/api.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/app.locator.dart';
import '../../common/app_colors.dart';
import '../../common/ui_helpers.dart';
import '../../components/submit_button.dart';
import '../../components/text_field_widget.dart';
import 'auth_viewmodel.dart';

class Register extends StatefulWidget {
  // final TabController controller;

  const Register({Key? key}) : super(key: key);



  @override
  State<Register> createState() => _RegisterState();

}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final List<String> genderOptions = ['Male', 'Female'];


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Account'),

        ),
        body: ViewModelBuilder<AuthViewModel>.reactive(
          onViewModelReady: (model) {
            model.init();
          },
          viewModelBuilder: () => AuthViewModel(),
          builder: (context, model, child) => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      verticalSpaceMedium,
                      const Text(
                        "Sign up to get started",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Panchang"
                        ),
                      ),
                      verticalSpaceTiny,
                      Row(
                          children:  [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                locator<NavigationService>().replaceWithLoginView();
                              },
                              child: const Text(
                                "login Account",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: kcPrimaryColor,
                                  decoration: TextDecoration.underline
                                ),
                              ),
                            )

                          ]
                      ),
                      verticalSpaceMedium,
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              hint: "Firstname",
                              controller: model.firstname,
                              inputType: TextInputType.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'required';
                                }
                                return null; // Return null to indicate no validation error
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: TextFieldWidget(
                              hint: "Lastname",
                              controller: model.lastname,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'required';
                                }
                                return null; // Return null to indicate no validation error
                              },
                            ),
                          ),
                          verticalSpaceSmall,
                        ],
                      ),
                      verticalSpaceMedium,
                      TextFieldWidget(
                        hint: "Email Address",
                        controller: model.email,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'required';
                          }
                          if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                            return 'Invalid email address';
                          }
                          return null; // Return null to indicate no validation error
                        },
                      ),
                      verticalSpaceSmall,
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                            style: TextStyle(
                              fontSize: 11,
                            ),
                            "A valid email is required for pin resetting and withdrawal requests"),
                      ),
                      verticalSpaceMedium,
                      IntlPhoneField(
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: const TextStyle(color: Colors.black,fontSize: 13),
                          floatingLabelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), // Add border curve
                            borderSide: const BorderSide(color: Color(0xFFCC9933)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), // Add border curve
                            borderSide: const BorderSide(color: Color(0xFFCC9933)),
                          ),
                        ),
                        validator: (value) {
                          if (value!.completeNumber.isEmpty) {
                            return 'required';
                          }
                          return null; // Return null to indicate no validation error
                        },
                        initialCountryCode: 'NG',
                        controller: model.phone,
                        onChanged: (phone) {
                          model.phoneNumber = phone;
                        },
                      ),
                      //
                      verticalSpaceSmall,
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          labelStyle: const TextStyle(color: Colors.black,fontSize: 13),
                          floatingLabelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Color(0xFFCC9933)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Color(0xFFCC9933)),
                          ),
                        ),
                        value: model.selectedGender, // You should add selectedGender to your model
                        onSaved: (String? newValue) {
                          model.selectedGender = newValue!;
                        },
                        onChanged: (String? newValue) {
                          model.selectedGender = newValue!;
                        },
                        items: genderOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        validator: (value) => value == null ? 'Please select a gender' : null,
                      ),
                      verticalSpaceSmall,
                      DropdownButtonFormField<int>(
                        decoration: InputDecoration(
                          labelText: 'Profession',
                          labelStyle: const TextStyle(color: Colors.black,fontSize: 13),
                          floatingLabelStyle: const TextStyle(color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Color(0xFFCC9933)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(color: Color(0xFFCC9933)),
                          ),
                        ),
                        value: model.selectedProfessionId,
                        onSaved: (newValue) => model.selectedProfessionId = newValue,
                        validator: (value) => value == null ? 'Please select a profession' : null,
                        onChanged: (newValue) {
                          setState(() {
                            model.selectedProfessionId = newValue;
                          });
                        },
                        items: model.professions.map<DropdownMenuItem<int>>((Profession profession) {
                          return DropdownMenuItem<int>(
                            value: profession.id,
                            child: Text(profession.name!),
                          );
                        }).toList(),
                        // ... rest of your dropdown setup ...
                      ),

                    verticalSpaceSmall,
                      TextFieldWidget(
                        inputType: TextInputType.visiblePassword,
                        hint: "Password",
                        controller: model.password,
                        obscureText: model.obscure,
                        suffix: InkWell(
                          onTap: () {
                            model.toggleObscure();
                          },
                          child:
                          Icon(model.obscure ? Icons.visibility_off : Icons.visibility),
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          if (!RegExp(r'[A-Z]').hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter';
                          }
                          if (!RegExp(r'[a-z]').hasMatch(value)) {
                            return 'Password must contain at least one lowercase letter';
                          }
                          if (!RegExp(r'[0-9]').hasMatch(value)) {
                            return 'Password must contain at least one digit';
                          }
                          if (!RegExp(r'[!@#$%^&*]').hasMatch(value)) {
                            return 'Password must contain at least one special character';
                          }
                          return null; // Return null to indicate no validation error
                        },
                      ),
                      verticalSpaceSmall,
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text( style: TextStyle(
                          fontSize: 11,
                        ),
                            "Must be at least 8 characters with a combination of letters and numbers"),
                      ),
                      verticalSpaceMedium,
                      TextFieldWidget(
                        hint: "Confirm password",
                        controller: model.cPassword,
                        obscureText: model.obscure,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Password confirmation is required';
                          }
                          if (value != model.password.text) {
                            return 'Passwords do not match';
                          }
                          return null; // Return null to indicate no validation error
                        },
                        suffix: InkWell(
                          onTap: () {
                            model.toggleObscure();
                          },
                          child:
                          Icon(model.obscure ? Icons.visibility_off : Icons.visibility),
                        ),
                      ),
                      verticalSpace(60),
                      InkWell(
                        onTap: model.toggleTerms,
                        child: Row(
                          children: [
                            Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color:
                                    model.terms ? kcSecondaryColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: model.terms
                                            ? Colors.transparent
                                            : kcSecondaryColor)),
                                child: model.terms
                                    ? const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: kcWhiteColor,
                                    size: 14,
                                  ),
                                )
                                    : const SizedBox()),
                            horizontalSpaceSmall,
                            const Text(
                              "I ACCEPT TERMS & CONDITIONS",
                              style: TextStyle(
                                  fontSize: 12, decoration: TextDecoration.underline),
                            )
                          ],
                        ),
                      ),
                      // verticalSpaceSmall,
                      // InkWell(
                      //   onTap: () async {
                      //     final Uri toLaunch =
                      //     Uri(scheme: 'https', host: 'www.kenmack.com', path: '/');
                      //
                      //     if (!await launchUrl(toLaunch, mode: LaunchMode.inAppBrowserView)) {
                      //       throw Exception('Could not launch www.kenmack.com/');
                      //     }
                      //   },
                      //   child: const Row(
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "View our Privacy Policy",
                      //         style: TextStyle(
                      //           fontSize: 15,
                      //           decoration: TextDecoration.underline,
                      //           color: kcSecondaryColor, // Feel free to change the color
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      verticalSpaceMedium,
                      SubmitButton(
                        isLoading: model.isBusy,
                        label: "Create Account",
                        submit: () {
                          if (_formKey.currentState!.validate()) {
                            model.register();
                          }
                        },
                        color: kcPrimaryColor,
                        boldText: true,
                      ),

                      verticalSpaceLarge,
                      const SizedBox(
                        height: 50,
                      ),
                      verticalSpaceMassive
                    ],
                  ),
                ),
               ],
            ),
          ),
        ),
      ),
    );
  }

  void gotoLogin() {

  }


}
