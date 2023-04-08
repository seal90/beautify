import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_diff/json_diff.dart';



class BeautifyJsonDiffWidget extends StatefulWidget {

  var leftJSONStr = "";

  var rightJSONStr = "";

  BeautifyJsonDiffWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BeautifyJsonDiffWidgetState();
  }

}

class _BeautifyJsonDiffWidgetState extends State<BeautifyJsonDiffWidget> {

  final TextEditingController _leftTextEditingController = TextEditingController();
  final TextEditingController _rightTextEditingController = TextEditingController();
  final TextEditingController _addedTextEditingController = TextEditingController();
  final TextEditingController _removedTextEditingController = TextEditingController();
  final TextEditingController _changedTextEditingController = TextEditingController();
  final TextEditingController _movedTextEditingController = TextEditingController();



  @override
  void initState() {
    super.initState();

    _leftTextEditingController.text = widget.leftJSONStr;
    _rightTextEditingController.text = widget.rightJSONStr;
  }

  @override
  void dispose() {
    super.dispose();
    widget.leftJSONStr = _leftTextEditingController.text;
    widget.rightJSONStr = _rightTextEditingController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: compareWidget(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.compare),
        onPressed: () {
          compareJSON();
        },),
    );
  }

  void compareJSON() {
    _addedTextEditingController.text = "";
    _removedTextEditingController.text = "";
    _changedTextEditingController.text = "";
    _movedTextEditingController.text = "";

    var letJSON = _leftTextEditingController.value.text;
    var rightJSON = _rightTextEditingController.value.text;
    if(letJSON.isEmpty || rightJSON.isEmpty) {
      return;
    }
    var leftObj = jsonDecode(letJSON);
    var rightObj = jsonDecode(rightJSON);

    final differ = JsonDiffer.fromJson(leftObj, rightObj);
    DiffNode diff = differ.diff();

    JsonEncoder encoder = const JsonEncoder.withIndent('  ');

    var allAdded = findAllAdded(diff);
    if(null != allAdded) {
      String addedStr = encoder.convert(allAdded);
      _addedTextEditingController.text = addedStr;
    }

    var allRemoved = findAllRemoved(diff);
    if(null != allRemoved) {
      String removedStr = encoder.convert(allRemoved);
      _removedTextEditingController.text = removedStr;
    }

    var allChanged = findAllChanged(diff);
    if(null != allChanged) {
      String changedStr = encoder.convert(allChanged);
      _changedTextEditingController.text = changedStr;
    }

    var allMoved = findAllMoved(diff);
    if(null != allMoved) {
      String movedStr = encoder.convert(allMoved);
      _movedTextEditingController.text = movedStr;
    }
  }
  Map<Object, Object?>? findAllAdded(DiffNode diff) {
    final thisNode = <Object, Object?>{};
    diff.added.forEach((k, v) {
      if(k is int){
        thisNode[k.toString()] = v;
      } else {
        thisNode[k] = v;
      }
    });
    diff.node.forEach((k, v) {
      final down = findAllAdded(v);
      if (down == null) {
        return;
      }
      thisNode[k] = down;
    });

    if (thisNode.isEmpty) {
      return null;
    }
    return thisNode;
  }

  Map<Object, Object?>? findAllRemoved(DiffNode diff) {
    final thisNode = <Object, Object?>{};
    diff.removed.forEach((k, v) {
      if(k is int){
        thisNode[k.toString()] = v;
      } else {
        thisNode[k] = v;
      }
    });
    diff.node.forEach((k, v) {
      final down = findAllRemoved(v);
      if (down == null) {
        return;
      }
      thisNode[k] = down;
    });

    if (thisNode.isEmpty) {
      return null;
    }
    return thisNode;
  }

  Map<Object, Object?>? findAllChanged(DiffNode diff) {
    final thisNode = <Object, Object?>{};
    diff.changed.forEach((k, v) {
      if(k is int){
        thisNode[k.toString()] = v;
      } else {
        thisNode[k] = v;
      }
    });
    diff.node.forEach((k, v) {
      final down = findAllChanged(v);
      if (down == null) {
        return;
      }
      thisNode[k] = down;
    });

    if (thisNode.isEmpty) {
      return null;
    }
    return thisNode;
  }

  Map<Object, Object?>? findAllMoved(DiffNode diff) {
    final thisNode = <Object, Object?>{};
    diff.moved.forEach((k, v) {
        thisNode[k.toString()] = v;
    });
    diff.node.forEach((k, v) {
      final down = findAllMoved(v);
      if (down == null) {
        return;
      }
      thisNode[k] = down;
    });

    if (thisNode.isEmpty) {
      return null;
    }
    return thisNode;
  }

  Widget compareWidget() {
    return Column(
      children: [
        Expanded(flex: 40, child: Row(children: [
          Expanded(child:
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _leftTextEditingController,
                keyboardType: TextInputType.multiline,
                minLines: 10000,
                maxLines: 10000,
                autofocus: true,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  label: Text('Origin JSON'),
                  hintText: 'Origin JSON',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (text){
                },
            ),),
          ),
          Expanded(child:
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: TextField(
                controller: _rightTextEditingController,
                keyboardType: TextInputType.multiline,
                minLines: 10000,
                maxLines: 10000,
                autofocus: true,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  label: Text('New JSON'),
                  hintText: 'New JSON',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (text){
                },
              ),),
          ),
        ],),),
        Expanded(flex: 60, child: Row(children: [
          Expanded(child:
            Container(
            margin: const EdgeInsets.only(top: 5),
              child: TextField(
                readOnly: true,
                controller: _addedTextEditingController,
                keyboardType: TextInputType.multiline,
                minLines: 10000,
                maxLines: 10000,
                autofocus: true,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  label: Text('Added'),
                  hintText: 'Added',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (text){
                },
          ),),),
          Expanded(child:
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: TextField(
                readOnly: true,
                controller: _removedTextEditingController,
                keyboardType: TextInputType.multiline,
                minLines: 10000,
                maxLines: 10000,
                autofocus: true,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  label: Text('Removed'),
                  hintText: 'Removed',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (text){
                },
          ),),),
          Expanded(child:
            Container(
              margin: const EdgeInsets.only(top: 5),
              child: TextField(
                readOnly: true,
                controller: _changedTextEditingController,
                keyboardType: TextInputType.multiline,
                minLines: 10000,
                maxLines: 10000,
                autofocus: true,
                cursorColor: Colors.blue,
                decoration: const InputDecoration(
                  label: Text('Changed'),
                  hintText: 'Changed',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (text){
                },
          ),),),
          Expanded(child:
            Container(
            margin: const EdgeInsets.only(top: 5),
            child: TextField(
              readOnly: true,
              controller: _movedTextEditingController,
              keyboardType: TextInputType.multiline,
              minLines: 10000,
              maxLines: 10000,
              autofocus: true,
              cursorColor: Colors.blue,
              decoration: const InputDecoration(
                label: Text('Moved'),
                hintText: 'Moved',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onChanged: (text){
              },
          ),),),

        ],),),
      ],
    );
  }
}
