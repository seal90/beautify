

import 'package:flutter/material.dart';

class BeautifyStorageWidget extends StatefulWidget {
  const BeautifyStorageWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BeautifyStorageWidgetState();
  }

}

class _BeautifyStorageWidgetState extends State<BeautifyStorageWidget> {

  final _bTextController = TextEditingController();
  final _bBigTextController = TextEditingController();
  final _kbTextController = TextEditingController();
  final _mbTextController = TextEditingController();
  final _gbTextController = TextEditingController();
  final _tbTextController = TextEditingController();
  final _pbTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text("  byte(b)"),
            SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _bTextController,
                onChanged: (value){
                  _fillNewValue("b", value);
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text("  Byte(B)"),
            SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _bBigTextController,
                onChanged: (value){
                  _fillNewValue("B", value);
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text("KByte(KB)"),
            SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _kbTextController,
                onChanged: (value){
                  _fillNewValue("KB", value);
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text("MByte(MB)"),
            SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _mbTextController,
                onChanged: (value){
                  _fillNewValue("MB", value);
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text("GByte(GB)"),
            SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _gbTextController,
                onChanged: (value){
                  _fillNewValue("GB", value);
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text("TByte(TB)"),
            SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _tbTextController,
                onChanged: (value){
                  _fillNewValue("TB", value);
                },
              ),
            )
          ],
        ),
        Row(
          children: [
            const Text("PByte(PB)"),
            SizedBox(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _pbTextController,
                onChanged: (value){
                  _fillNewValue("PB", value);
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  void _fillNewValue(String type, String value) {
    setState(() {
      if(value.isEmpty) {
        if('b' != type) {
          _bTextController.text = "";
        }

        if("B" != type) {
          _bBigTextController.text = "";
        }

        if("KB" != type) {
          _kbTextController.text = "";
        }

        if("MB" != type) {
          _mbTextController.text = "";
        }

        if("GB" != type) {
          _gbTextController.text = "";
        }

        if("TB" != type) {
          _tbTextController.text = "";
        }

        if("PB" != type) {
          _pbTextController.text = "";
        }
        return;
      }

      double doubleValue = 0;
      try {
        doubleValue = double.parse(value);
      } catch(e) {
        return;
      }
      if('b' != type) {
        var byteValue = _toByte(type, doubleValue);
        _bTextController.text = byteValue.toString();
      }

      if("B" != type) {
        var byteBigValue = _toByteBig(type, doubleValue);
        _bBigTextController.text = byteBigValue.toString();
      }

      if("KB" != type) {
        var kByteBigValue = _toKByte(type, doubleValue);
        _kbTextController.text = kByteBigValue.toString();
      }

      if("MB" != type) {
        var mByteBigValue = _toMByte(type, doubleValue);
        _mbTextController.text = mByteBigValue.toString();
      }

      if("GB" != type) {
        var gByteBigValue = _toGByte(type, doubleValue);
        _gbTextController.text = gByteBigValue.toString();
      }

      if("TB" != type) {
        var tByteBigValue = _toTByte(type, doubleValue);
        _tbTextController.text = tByteBigValue.toString();
      }

      if("PB" != type) {
        var pByteBigValue = _toPByte(type, doubleValue);
        _pbTextController.text = pByteBigValue.toString();
      }
    });

  }

  double _toByte(String type, double value) {
    switch(type) {
      case 'b' : return value;
      case 'B' : return value * 8;
      case 'KB' : return value * 8 * 1024;
      case 'MB' : return value * 8 * 1024 * 1024;
      case 'GB' : return value * 8 * 1024 * 1024 * 1024;
      case 'TB' : return value * 8 * 1024 * 1024 * 1024 * 1024;
      case 'PB' : return value * 8 * 1024 * 1024 * 1024 * 1024 * 1024;
    }
    return 0;
  }

  double _toByteBig(String type, double value) {
    switch(type) {
      case 'b' : return value / 8;
      case 'B' : return value;
      case 'KB' : return value * 1024;
      case 'MB' : return value * 1024 * 1024;
      case 'GB' : return value * 1024 * 1024 * 1024;
      case 'TB' : return value * 1024 * 1024 * 1024 * 1024;
      case 'PB' : return value * 1024 * 1024 * 1024 * 1024 * 1024;
    }
    return 0;
  }

  double _toKByte(String type, double value) {
    switch(type) {
      case 'b' : return value / 8 / 1024;
      case 'B' : return value / 1024;
      case 'KB' : return value;
      case 'MB' : return value * 1024;
      case 'GB' : return value * 1024 * 1024;
      case 'TB' : return value * 1024 * 1024 * 1024;
      case 'PB' : return value * 1024 * 1024 * 1024 * 1024;
    }
    return 0;
  }

  double _toMByte(String type, double value) {
    switch(type) {
      case 'b' : return value / 8 / 1024 / 1024;
      case 'B' : return value / 1024 / 1024;
      case 'KB' : return value / 1024;
      case 'MB' : return value;
      case 'GB' : return value * 1024;
      case 'TB' : return value * 1024 * 1024;
      case 'PB' : return value * 1024 * 1024 * 1024;
    }
    return 0;
  }

  double _toGByte(String type, double value) {
    switch(type) {
      case 'b' : return value / 8 / 1024 / 1024 / 1024;
      case 'B' : return value / 1024 / 1024 / 1024;
      case 'KB' : return value / 1024 / 1024;
      case 'MB' : return value / 1024;
      case 'GB' : return value;
      case 'TB' : return value * 1024;
      case 'PB' : return value * 1024 * 1024;
    }
    return 0;
  }

  double _toTByte(String type, double value) {
    switch(type) {
      case 'b' : return value / 8 / 1024 / 1024 / 1024 / 1024;
      case 'B' : return value / 1024 / 1024 / 1024 / 1024;
      case 'KB' : return value / 1024 / 1024 / 1024;
      case 'MB' : return value / 1024 / 1024;
      case 'GB' : return value / 1024;
      case 'TB' : return value;
      case 'PB' : return value * 1024;
    }
    return 0;
  }

  double _toPByte(String type, double value) {
    switch(type) {
      case 'b' : return value / 8 / 1024 / 1024 / 1024 / 1024 / 1024;
      case 'B' : return value / 1024 / 1024 / 1024 / 1024 / 1024;
      case 'KB' : return value / 1024 / 1024 / 1024 / 1024;
      case 'MB' : return value / 1024 / 1024 / 1024;
      case 'GB' : return value / 1024 / 1024;
      case 'TB' : return value / 1024;
      case 'PB' : return value;
    }
    return 0;
  }
}