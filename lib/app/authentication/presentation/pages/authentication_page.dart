import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:receipe_app/app/recipe_app/presentation/homepage.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../core/app_routing/route_names.dart';
import '../../../../core/local_db/box_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utility/alert_header_design.dart';
import '../../../../core/utility/keyboard_utility.dart';
import '../../../../core/utility/text_sizes.dart';
import '../../../../core/utility/validator.dart';
import '../../../../core/widgets/custom_textfield.dart';
import '../../../../core/widgets/horizontal_bar.dart';
import '../../../../core/widgets/round_button.dart';
import '../../../recipe_app/models/food_dish_model.dart';
import '../../../recipe_app/providers/refresh_provider.dart';
import '../../../recipe_app/providers/search_bar_provider.dart';
import '../../model/signup_model.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordResetFormKey = GlobalKey<FormState>();

  bool isLogin = true;
  late final Box signupBox;
  late final Box foodRecipeStoreBox;
  // late final Box sessionStorageStoreBox;

  @override
  void initState() {
    // TODO: implement initState
    print("Auth page: email:}");
    super.initState();
    signupBox = Hive.box(HiveBoxName.signupBox);
    foodRecipeStoreBox = Hive.box(HiveBoxName.foodRecipeStoreBox);
    //
    // sessionStorageStoreBox =
    //     Hive.box(HiveBoxName.sessionStatePersistentStoreBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 60.0),
              Text(
                "Recipe Management Application",
                style: CustomTextStyle.getBoldTextStyle(
                  textColor: AppColor.primaryColor,
                  textSize: AppTextSize.extraLarge,
                ),
              ),
              const SizedBox(height: 30.0),
              Flexible(
                child: SingleChildScrollView(
                  child: Card(
                    margin: const EdgeInsets.all(0),
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        //
                        Form(
                          key: _formKey,
                          child: isLogin ? loginForm() : signUpForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loginForm() {
    String emailValue = "";
    String passwordValue = "";
    return Container(
      width: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor, // .withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          const SizedBox(height: 10.0),
          Center(
            child: Text(
              "Login",
              style: CustomTextStyle.getBoldTextStyle(
                textColor: Colors.black,
                textSize: AppTextSize.large,
              ),
            ),
          ),

          // Email field
          const SizedBox(height: 30.0),
          AuthenticationTextFormField(
            isTextHide: false,
            focusNode: null,
            hintText: "Enter email",
            labelText: "Email",
            isEnd: false,
            isNumKeyboardType: false,
            validate: (String? email) {
              return AuthenticationValidator.emailValidator(email);
            },
            save: (email) {
              emailValue = email!;
            },
          ),

          // Password field
          const SizedBox(height: 20.0),
          AuthenticationTextFormField(
            isTextHide: true,
            focusNode: null,
            hintText: "Enter Password",
            labelText: "Password",
            isEnd: false,
            isNumKeyboardType: false,
            validate: (String? password) {
              return AuthenticationValidator.passwordValidator(password);
            },
            save: (password) {
              passwordValue = password!;
            },
          ),

          const SizedBox(height: 10.0),
          // forget password
          Align(
            alignment: const Alignment(0.9, 0.0),
            child: Text.rich(
              TextSpan(
                  text: "Forget password",
                  style: const TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // changing password functionalities here
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(20),
                            insetPadding: const EdgeInsets.all(0),
                            titlePadding: const EdgeInsetsDirectional.all(0),
                            // title: Text(
                            //   "Favourite Food Item",
                            //   style: CustomTextStyle.getBoldTextStyle(
                            //     textColor: Colors.black,
                            //     textSize: AppTextSize.large,
                            //   ),
                            // ),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            title: getDesignedHeader("Resetting password"),
                            content: SizedBox(
                              width: 300,
                              child: Form(
                                key: _passwordResetFormKey,
                                child: resetPasswordWidget(),
                              ),
                            ),
                          );
                        },
                      );
                    }),
            ),
          ),

          const SizedBox(height: 10.0),

          // continue button
          Center(
            child: RoundedButtonStyle(
              isEnable: true,
              text: "Login",
              onTap: () async {
                //
                closeKeyboard();

                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  // everything is valid, proceed next
                  _formKey.currentState!.save();
                  print("Email: $emailValue, Password: $passwordValue");
                  /*
                  * Steps:
                  * 1:) verify the email and password from database
                  * 2:) if valid show the homepage, otherwise show the error message
                  * */
                  EasyLoading.show(
                      status: "Please wait, verifying account",
                      dismissOnTap: false);

                  await Future.delayed(
                      const Duration(milliseconds: 300), () {});

                  if (signupBox.containsKey(emailValue)) {
                    // if email found, then match the password
                    Map<dynamic, dynamic> userData = signupBox
                        .get(emailValue); // will return Map<dynamic, dynamic>
                    print("User data: ${userData}");
                    if (userData["password"].toString() ==
                        passwordValue.trim().toString()) {
                      // password checking

                      EasyLoading.dismiss();
                      userData["isLogout"] = "true";
                      // saving state back to hive
                      await signupBox.put(emailValue, userData);

                      // proceed to the homepage
                      print(
                          "Account with email: $emailValue, password: $passwordValue has verified");
                    } else {
                      // password does not match
                      EasyLoading.showError("Password does not match",
                          dismissOnTap: false);
                      return;
                    }
                    // proceed to the homepage
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) {
                          // SearchBarProvider
                          return MultiProvider(
                            providers: [
                              ChangeNotifierProvider<SearchBarProvider>(
                                create: (context) => SearchBarProvider(),
                              ),
                              // ChangeNotifierProvider<RefreshProvider>(
                              //   create: (context) => RefreshProvider(),
                              // ),
                            ],
                            child: RecipeHomepage(email: emailValue),
                          );
                          // return RecipeHomepage(email: emailValue);
                        },
                      ),
                      (route) => false,
                    );
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   RecipeRouteName.homepage,
                    //   (route) => false,
                    // );
                    // arguments: {"email": emailValue}
                    // Navigator.of(context).pushNamed(RecipeRouteName.homepage);
                    //
                  } else {
                    // email not found
                    EasyLoading.showError("Email account is not registered",
                        dismissOnTap: false);
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 20.0),
          horizontalBar(width: 250, height: 0.7),
          const SizedBox(height: 20.0),

          Center(
            child: Text.rich(
              TextSpan(
                text: "Don't have account?  ",
                style: const TextStyle(
                  color: AppColor.onSecondaryColor,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    text: "Signup",
                    style: const TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // resetAppExitCounter();
                        setState(() {
                          isLogin = false;
                          _formKey.currentState?.reset();
                        });
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget signUpForm() {
    String nameValue = "";
    String emailValue = "";
    String passwordValue = "";
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.secondaryColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          //
          const SizedBox(height: 10.0),
          Center(
            child: Text(
              "Create an account",
              style: CustomTextStyle.getBoldTextStyle(
                textColor: Colors.black,
                textSize: AppTextSize.large,
              ),
            ),
          ),

          // name field
          const SizedBox(height: 30.0),
          AuthenticationTextFormField(
            isTextHide: false,
            focusNode: null,
            hintText: "Enter name",
            labelText: "Name",
            isEnd: false,
            isNumKeyboardType: false,
            validate: (name) {
              return AuthenticationValidator.nameValidator(name);
            },
            save: (name) {
              nameValue = name!;
            },
          ),

          // email field
          const SizedBox(height: 20.0),
          AuthenticationTextFormField(
            isTextHide: false,
            focusNode: null,
            hintText: "Enter email",
            labelText: "Email",
            isEnd: false,
            isNumKeyboardType: false,
            validate: (String? email) {
              return AuthenticationValidator.emailValidator(email);

              /*
              if (email != null && isEmail(email)) {
                return null;
              } else {
                return "Invalid email";
              }
              */
              // if ((mobileNumber != null && mobileNumber.isEmpty) ||
              //     mobileNumber?.length != 11) {
              //   print("mobile number length: ${mobileNumber?.length}");
              //   mobilePhoneFocusNode.requestFocus();
              //   return "Mobile number must be 11 digits long";
              //   // return AppLocalizations.of(context)!
              //   //     .mobileNumberMustNotBeEmpty;
              // } else {
              //   return null;
              // }
            },
            save: (email) {
              emailValue = email!;
            },
          ),

          // Password field
          const SizedBox(height: 20.0),
          AuthenticationTextFormField(
            isTextHide: true,
            focusNode: null,
            hintText: "Enter Password",
            labelText: "Password",
            isEnd: false,
            isNumKeyboardType: false,
            validate: (String? password) {
              return AuthenticationValidator.passwordValidator(password);
            },
            save: (password) {
              passwordValue = password!;
            },
          ),

          const SizedBox(height: 20.0),
          // continue button
          Center(
            child: RoundedButtonStyle(
              isEnable: true,
              text: "Signup",
              onTap: () async {
                //
                closeKeyboard();

                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  // everything is valid, proceed next
                  // save the name, email, password
                  /**/
                  EasyLoading.show(
                    status: "Please wait, while creating an account",
                    dismissOnTap: false,
                  );
                  await Future.delayed(
                      const Duration(milliseconds: 300), () {});
                  _formKey.currentState!.save();
                  print(
                      "Name: $nameValue, Email: $emailValue, Password: $passwordValue");
                  /*
                  * Steps:
                  * 1:) save the name,email,password in a database
                  * 2:) show the homepage
                  * */
                  // check if email already registered or not
                  if (signupBox.containsKey(emailValue)) {
                    EasyLoading.showInfo(
                        "User is already registered. Please do login");
                    return;
                  }
                  // signupBox
                  Map<String, String> userData = SignupModel(
                    name: nameValue,
                    email: emailValue,
                    password: passwordValue,
                    isLogout: true,
                  ).toHiveFormat();
                  print("Box Length before: ${signupBox.length}");
                  await signupBox.put(
                      emailValue, userData); // email: user data in Map format
                  print("Box Length after: ${signupBox.length}");
                  print("Box data: ${signupBox.toString()}");
                  EasyLoading.showSuccess(
                    "Account has created successfully",
                    dismissOnTap: false,
                    duration: const Duration(milliseconds: 1500),
                  );

                  // store all runtime food recipe database into hive for user specific
                  // each a new user is created will have this list of food item
                  // foodRecipeStoreBox
                  /*
                  * structure -- food item store box
                    {
                      "email" :  {
                        "id" : "food recipe",
                        "id" : "food recipe",
                      }",
                      "email" :  {
                        "id" : "food recipe",
                        "id" : "food recipe",
                      }"
                    }
                  * */
                  // ukFoodDishList

                  // await foodRecipeStoreBox.put("email", emailValue);
                  Map<String, dynamic> userFoodBoxData = {};
                  for (final foodItem in ukFoodDishList) {
                    // await foodRecipeStoreBox.put(foodItem.id, foodItem.toMap());
                    userFoodBoxData[foodItem.id] = foodItem.toMap();
                  }
                  await foodRecipeStoreBox.put(emailValue, userFoodBoxData);
                  print("data Store");
                  log("userFoodBoxData: $userFoodBoxData");
                  /*
                  * email : email,
                  * food_id: Map
                  *
                  * */

                  // // store user session state
                  // sessionStorageStoreBox.put(
                  //     emailValue, UserLoginState.login.name);
                  // Proceed to the homepage
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) {
                        // SearchBarProvider
                        return MultiProvider(
                          providers: [
                            ChangeNotifierProvider<SearchBarProvider>(
                              create: (context) => SearchBarProvider(),
                            ),
                            // ChangeNotifierProvider<RefreshProvider>(
                            //   create: (context) => RefreshProvider(),
                            // ),
                          ],
                          child: RecipeHomepage(email: emailValue),
                        );
                        // return RecipeHomepage(email: emailValue);
                      },
                    ),
                    (route) => false,
                  );
                  /*
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) {
                        return RecipeHomepage(email: emailValue);
                      },
                    ),
                    (route) => false,
                  );
                  */
                  // Navigator.of(context).pushNamedAndRemoveUntil(
                  //   RecipeRouteName.homepage,
                  //   (route) => false,
                  // );
                  // arguments: {"email": emailValue}
                }
              },
            ),
          ),

          const SizedBox(height: 20.0),
          horizontalBar(width: 250, height: 0.7),
          const SizedBox(height: 20.0),
          // already a user
          Center(
            child: Text.rich(
              TextSpan(
                text: "Already a user?  ",
                style: const TextStyle(
                  color: AppColor.onSecondaryColor,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  TextSpan(
                    text: "Login",
                    style: const TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // resetAppExitCounter();
                        setState(() {
                          isLogin = true;
                          _formKey.currentState?.reset();
                        });
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget resetPasswordWidget() {
    String emailValue = "";
    String passwordValue = "";

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //
        const SizedBox(height: 10.0),

        // email field
        const SizedBox(height: 20.0),
        AuthenticationTextFormField(
          isTextHide: false,
          focusNode: null,
          hintText: "Enter email",
          labelText: "Email",
          isEnd: false,
          isNumKeyboardType: false,
          validate: (String? email) {
            return AuthenticationValidator.emailValidator(email);

            /*
            if (email != null && isEmail(email)) {
              return null;
            } else {
              return "Invalid email";
            }
            */
            // if ((mobileNumber != null && mobileNumber.isEmpty) ||
            //     mobileNumber?.length != 11) {
            //   print("mobile number length: ${mobileNumber?.length}");
            //   mobilePhoneFocusNode.requestFocus();
            //   return "Mobile number must be 11 digits long";
            //   // return AppLocalizations.of(context)!
            //   //     .mobileNumberMustNotBeEmpty;
            // } else {
            //   return null;
            // }
          },
          save: (email) {
            emailValue = email!;
          },
        ),

        // Password field
        const SizedBox(height: 20.0),
        AuthenticationTextFormField(
          isTextHide: true,
          focusNode: null,
          hintText: "Enter new password",
          labelText: "New Password",
          isEnd: false,
          isNumKeyboardType: false,
          validate: (String? password) {
            return AuthenticationValidator.passwordValidator(password);
          },
          save: (password) {
            passwordValue = password!;
          },
        ),
        const SizedBox(height: 20.0),

        // continue button
        Center(
          child: RoundedButtonStyle(
            isEnable: true,
            text: "Reset password",
            onTap: () async {
              //
              closeKeyboard();

              if (_passwordResetFormKey.currentState != null &&
                  _passwordResetFormKey.currentState!.validate()) {
                _passwordResetFormKey.currentState!.save();
                //
                print("Email: $emailValue, Password: $passwordValue");
                // 1:) check user account exist
                print(
                    "signupBox.containsKey(emailValue): ${signupBox.containsKey(emailValue)}");
                if (signupBox.containsKey(emailValue) == false) {
                  EasyLoading.showError(
                    "User with this email account is not registered",
                    dismissOnTap: false,
                    duration: const Duration(
                      seconds: 1,
                    ),
                  );
                  return;
                }

                // everything is valid, proceed next
                // save the name, email, password
                /**/
                EasyLoading.show(
                  status: "Please wait, while resetting an password",
                  dismissOnTap: false,
                );
                await Future.delayed(const Duration(milliseconds: 300), () {});

                // 2:) if email account exist, match the password
                final Map userPasswordModel = signupBox.get(emailValue);
                userPasswordModel["password"] = passwordValue;
                await signupBox.put(emailValue, userPasswordModel);
                EasyLoading.showSuccess(
                  "Password has reset successfully",
                  dismissOnTap: false,
                  duration: const Duration(milliseconds: 1500),
                );
                Navigator.of(context).pop();
              }
            },
          ),
        ),

        const SizedBox(height: 20.0), // already a user
      ],
    );
  }
}
