import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kenmack/app/app.router.dart';
import 'package:kenmack/ui/common/app_colors.dart';
import 'package:kenmack/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../components/submit_button.dart';
import '../../components/text_field_widget.dart';
import 'auth_viewmodel.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  bool _isPasswordVisible = false;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
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
                  verticalSpaceMassive,
                  Image.asset('assets/images/logo.png', height:92, width: 92, ),
                  // verticalSpaceSmall,
                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Login to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  TextFieldWidget(
                    hint: "Email",
                    controller: model.email,
                  ),
                  verticalSpaceMedium,
                  TextFieldWidget(
                    hint: "Password",
                    controller: model.password,
                    obscureText: model.obscure,
                    suffix: InkWell(
                      onTap: () {
                        model.toggleObscure();
                      },
                      child: Icon(
                          model.obscure ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  verticalSpaceTiny,
                  Center(
                    child: TextButton(
                        onPressed: () {
                          // TODO: Navigate to Forgot Password Screen
                        },
                        child: Text('Forgot Password?', style: TextStyle(color: kcPrimaryColor),  textAlign: TextAlign.right,),
                      ),
                  ),
                  SizedBox(height: 16),
                  SubmitButton(
                    isLoading: model.isBusy,
                    boldText: true,
                    label: "Login",
                    submit: () {
                      model.login();
                    },
                    color: kcPrimaryColor,
                  ),
                  verticalSpaceSmall,
                  Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: kcPrimaryColor),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: kcPrimaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              locator<NavigationService>().replaceWithRegisterView();
                            },
                        ),
                      ],
                    ),
                  ),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
          ),
        ),
      ),
    );
  }
}

