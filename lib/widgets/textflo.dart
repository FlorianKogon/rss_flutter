import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFlo extends Text {

  TextFlo(String data, {textAlign: TextAlign.center, color: Colors.indigo, fontSize: 15.0, fontStyle: FontStyle.normal}):
      super(
        data,
        textAlign: textAlign,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontStyle: fontStyle,
        ),
      );

}