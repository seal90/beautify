
import 'dart:convert';

import 'package:flutter/material.dart';

class BeautifyBase64Widget extends StatefulWidget {

  const BeautifyBase64Widget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BeautifyBase64WidgetState();
  }

}

class _BeautifyBase64WidgetState extends State<BeautifyBase64Widget> {

  final _sourceTextFieldController = TextEditingController();

  final _base64TextFieldController = TextEditingController();
  
  String errInfo = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: errInfo.isEmpty ? null : SelectableText(errInfo, style: const TextStyle(color: Colors.red),),
        ),
        Flexible(
          child: buildTranslate(),
        ),

      ],
    );
  }

  Widget buildTranslate() {
    return Row(
      children: [
        Flexible(
          // flex,: 300,
          child: TextField(
            controller: _sourceTextFieldController,
            maxLines: 1000,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onChanged: (value){

            },
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                color: Colors.lightBlue,
                child: const Text(">>>"),
                onPressed: (){
                  errInfo = "";
                  try {
                    var sourceText = _sourceTextFieldController.text.trim();
                    var base64Encoded = const Base64Encoder().convert(
                        utf8.encode(sourceText));
                    _base64TextFieldController.text = base64Encoded;
                  } catch (e) {
                    errInfo = e.toString();
                  }
                  setState(() {
                    errInfo;
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                color: Colors.lightBlue,
                child: const Text("<<<"),
                onPressed: (){
                  errInfo = "";
                  try {
                    var base64Text = _base64TextFieldController.text.trim();
                    var sourceText = utf8.decoder.convert(
                        const Base64Decoder().convert(base64Text));
                    _sourceTextFieldController.text = sourceText;
                  } catch (e) {
                    errInfo = e.toString();
                  }
                  setState(() {
                    errInfo;
                  });
                },
              ),
            ],
          ),
        ),
        Flexible(
          // width: 300,
          child: TextField(
            controller: _base64TextFieldController,
            maxLines: 1000,
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            onChanged: (value){

            },
          ),
        ),
      ],
    );
  }
}