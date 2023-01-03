import 'package:flutter/material.dart';
import 'package:flutter_ecommerce_ui_kit/blocks/auth_provider.dart';
import 'package:flutter_ecommerce_ui_kit/models/user.dart';
import 'package:flutter_ecommerce_ui_kit/services/auth_service.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  final textEmailController = TextEditingController();
  final textPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authBlockProvider = Provider.of<AuthBlock>(context, listen: false);
    authBlockProvider.setLoadingType(authBlockProvider.loginType);
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
                  'Launch App',
                  style: TextStyle(
                    fontSize: 50,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: TextFormField(
                    controller: textEmailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please Enter Email or Username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Username Or Email',
                      labelText: 'Email',
                    ),
                  ),
                ),
                TextFormField(
                  controller: textPasswordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 8) {
                      return 'Please Enter a Password of Valid Length';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Password',
                    labelText: 'Password',
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
                        print('button building');
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: value.isLoading &&
                                  value.loadingType == value.loginType
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.white),
                                ),
                          onPressed: () {
                            FocusScopeNode currentFocus =
                                FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();
                            }
                            if (_formKey.currentState!.validate()) {
                              value.login(textEmailController.text,
                                  textPasswordController.text, popCallBack);
                            }
                          },
                        );
                      },
                    ),
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
