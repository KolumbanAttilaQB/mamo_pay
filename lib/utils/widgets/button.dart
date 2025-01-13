
import 'package:flutter/material.dart';

class MyButtons {


  largeButton({required String text,required VoidCallback onTap, required Color btnColor, required Color txtColor}) {
    return SizedBox(
      height: 56,
      child: MaterialButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0)),onPressed: onTap, color: btnColor, child: Text(text, style: TextStyle(fontSize: 14, color: txtColor),) ),
    );

  }

}