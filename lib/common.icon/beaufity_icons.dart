

import 'dart:convert';

import 'package:flutter/material.dart';

import 'icomoon_icons.dart';

Image build_image() {
  String imageBase64 = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAMAAAAoLQ9TAAAABlBMVEUAAA...'; // 这里填写 Base64 编码的图片数据
  var icon = Icon(
    Icomoon.microsoftexcel,
    size: 60,
    color: Colors.white,
  );
  return Image.memory(base64Decode(imageBase64), width:20, height:20,);

}
