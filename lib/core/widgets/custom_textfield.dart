import 'package:flutter/material.dart';

class AuthenticationTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final String hintText;
  final String labelText;
  final String? Function(String? value) validate;
  final void Function(String? newValue) save;
  final bool isEnd;
  final bool isNumKeyboardType;
  final bool isTextHide;
  // final bool isMobileNumberTextField;
  const AuthenticationTextFormField({
    this.focusNode,
    required this.hintText,
    required this.labelText,
    required this.validate,
    required this.save,
    required this.isEnd,
    required this.isNumKeyboardType,
    required this.isTextHide,
    // this.isMobileNumberTextField = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // maxLength: isMobileNumberTextField ? 11 : null,
      obscureText: isTextHide,
      style: const TextStyle(fontSize: 18),
      focusNode: focusNode,
      textInputAction: isEnd ? TextInputAction.done : TextInputAction.next,
      keyboardType:
          isNumKeyboardType ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        errorMaxLines: 10,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          // borderSide: const BorderSide(color: AppColor.primaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        label: Text(labelText),
        isDense: false,
      ),
      validator: validate,
      onSaved: save,
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final String? Function(String? value) validate;
  final void Function(String? newValue) save;
  final bool isEnd;
  final bool isNumKeyboardType;
  final int maxlines;
  const CustomTextFormField({
    required this.hintText,
    required this.labelText,
    required this.validate,
    required this.save,
    required this.isEnd,
    required this.isNumKeyboardType,
    this.maxlines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(fontSize: 14),
      maxLines: maxlines,
      textInputAction: isEnd ? TextInputAction.done : TextInputAction.newline,
      keyboardType:
          isNumKeyboardType ? TextInputType.number : TextInputType.multiline,
      decoration: InputDecoration(
        errorMaxLines: 10,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        label: Text(labelText),
        isDense: true,
      ),
      validator: validate,
      onSaved: save,
    );
  }
}

class CustomTextFormFieldWithController extends StatelessWidget {
  final String hintText;
  final String labelText;
  final String? Function(String? value) validate;
  final void Function(String? newValue) save;
  final bool isEnd;
  final bool isNumKeyboardType;
  final int maxlines;
  final TextEditingController controller;
  const CustomTextFormFieldWithController({
    required this.hintText,
    required this.labelText,
    required this.validate,
    required this.save,
    required this.isEnd,
    required this.isNumKeyboardType,
    required this.controller,
    this.maxlines = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(fontSize: 14),
      maxLines: maxlines,
      textInputAction: isEnd ? TextInputAction.done : TextInputAction.next,
      keyboardType:
          isNumKeyboardType ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        errorMaxLines: 10,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        label: Text(labelText),
        isDense: true,
      ),
      validator: validate,
      onSaved: save,
    );
  }
}
