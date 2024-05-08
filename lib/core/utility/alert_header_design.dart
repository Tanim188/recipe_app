import 'package:flutter/material.dart';
import 'package:receipe_app/core/utility/text_sizes.dart';

import '../theme/app_colors.dart';

Widget getDesignedHeader(String title, {bool isCenter = true}) {
  return Container(
    padding: const EdgeInsetsDirectional.all(12.0),
    alignment: isCenter
        ? AlignmentDirectional.center
        : AlignmentDirectional.centerStart,
    // height: 7.0.h,
    width: 75.0,

    decoration: const BoxDecoration(
      color: AppColor.primaryColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(0.0),
        topRight: Radius.circular(0.0),
      ),
    ),
    child: Text(
      title,
      style: CustomTextStyle.getBoldTextStyle(
        textColor: Colors.white,
        textSize: AppTextSize.small,
      ),
    ),
    // child: Text(
    //   title,
    //
    //   style: const TextStyle(
    //     color: Colors.white,
    //     fontWeight: FontWeight.w400,
    //   ),
    // ),
  );
}

Widget getDesignedHeaderWithInfoIcon(String title, {bool isCenter = true}) {
  return Container(
    padding: const EdgeInsetsDirectional.all(12.0),
    alignment: isCenter
        ? AlignmentDirectional.center
        : AlignmentDirectional.centerStart,
    // height: 7.0.h,
    width: 75.0,

    decoration: const BoxDecoration(
      color: AppColor.primaryColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(0.0),
        topRight: Radius.circular(0.0),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.info,
          color: Colors.white,
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: CustomTextStyle.getBoldTextStyle(
            textColor: Colors.white,
            textSize: AppTextSize.small,
          ),
        ),
      ],
    ),
  );
}
