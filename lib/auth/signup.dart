import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/blocks/auth_provider.dart';
import 'package:flutter_ecommerce_ui_kit/models/user.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authBlockProvider = Provider.of<AuthBlock>(context, listen: false);
    authBlockProvider.setLoadingType(authBlockProvider.createType);
    final popCallBack = Navigator.of(context).pop;
    return Center(
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.asset('assets/images/logo.jpg'),
                ),
                Container(
                    child: Text(
                  'Welcome to Launch App',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: usernameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter your Full Name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Fullname',
                      labelText: 'Fullname',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Email Address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Email',
                      labelText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Password',
                        labelText: 'Password',
                      ),
                      obscureText: true),
                ),
                TextFormField(
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please Enter Confirm Password';
                    } else if (passwordController.text !=
                        confirmPasswordController.text) {
                      return 'Password fields dont match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Same Password',
                    labelText: 'Confirm Password',
                  ),
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Consumer<AuthBlock>(
                        builder: (BuildContext context, value, Widget? child) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: value.isLoading &&
                                value.loadingType == value.createType
                            ? CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                            : Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                        onPressed: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                          if (_formKey.currentState!.validate()) {
                            value.createAccount(
                                emailController.text,
                                passwordController.text,
                                usernameController.text,
                                popCallBack);
                          }
                        },
                      );
                    }),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
