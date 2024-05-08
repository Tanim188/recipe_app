import 'package:string_validator/string_validator.dart';

class AuthenticationValidator {
  static String? nameValidator(String? name) {
    if (name != null && name.trim().isEmpty) {
      return "Field cant be empty";
    } else if (name != null && isNumeric(name.trim())) {
      return "Invalid name";
    } else {
      return null;
    }
  }

  static String? emailValidator(String? email) {
    if (email != null && isEmail(email)) {
      return null;
    } else {
      return "Invalid email";
    }
  }

  static String? passwordValidator(String? password) {
    /*
     * Minimum 1 Upper case
     * Minimum 1 lowercase
     * Minimum 1 Numeric Number
     * Minimum 1 Special Character
     * Common Allow Character ( ! @ # $ & * ~ )
     * */
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (password != null && password.isEmpty) {
      return 'Please enter password';
    } else {
      if (!regex.hasMatch(password!)) {
        // * Minimum 1 Upper case
        //               * Minimum 1 Alphabet
        //               * Minimum 1 Numeric Number
        //               * Minimum 1 Special Character
        //               * Common Allow Character ( ! @ # $ & * ~ )
        return 'Password does not meet the standard\n   * Password must contain Minimum 1 Alphabet \n   * Minimum 1 Numeric Number \n   * Minimum 1 Special Character';
      } else {
        return null;
      }
    }
  }

  static bool isValidPassword(String? password) {
    /*
     * Minimum 1 Upper case
     * Minimum 1 lowercase
     * Minimum 1 Numeric Number
     * Minimum 1 Special Character
     * Common Allow Character ( ! @ # $ & * ~ )
     * */
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (password != null && password.isEmpty) {
      return false;
    } else {
      if (!regex.hasMatch(password!)) {
        return false;
      } else {
        return true;
      }
    }
  }

  static bool isValidEmail(String? email) {
    if (email != null && isEmail(email)) {
      return true;
    } else {
      return false;
    }
  }
}
