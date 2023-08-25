

import 'package:beautify/beautify_base64/beautify_base64.dart';
import 'package:beautify/beautify_interconvert_json_excel/beautify_interconvert_json_excel.dart';
import 'package:beautify/beautify_json/beautify_tab_json.dart';
import 'package:beautify/beautify_json_diff/beautify_json_diff.dart';
import 'package:beautify/beautify_barcode/beautify_barcode.dart';
import 'package:beautify/beautify_storage/beautify_storage.dart';
import 'package:beautify/beautify_time/beautify_time.dart';
import 'package:beautify/common.icon/icomoon_icons.dart';
import 'package:beautify/third_party/adaptive_scaffold.dart';
import 'package:flutter/material.dart';

class BeautifyMainWidget extends StatefulWidget {

  const BeautifyMainWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BeautifyMainWidgetState();
  }

}

class _BeautifyMainWidgetState extends State<BeautifyMainWidget> with TickerProviderStateMixin {

  TabController? _tabController;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: const Text('Beautify Data'),
      currentIndex: _pageIndex,
      destinations: const [
        AdaptiveScaffoldDestination(title: 'JSON', icon: Icomoon.json),
        AdaptiveScaffoldDestination(title: 'Time', icon: Icons.access_time),
        AdaptiveScaffoldDestination(title: 'Storage', icon: Icomoon.database),
        AdaptiveScaffoldDestination(title: 'Base64', icon: Icons.backpack_outlined),
        AdaptiveScaffoldDestination(title: 'Excel', icon: Icomoon.microsoftexcel),
        AdaptiveScaffoldDestination(title: 'JSON Diff', icon: Icons.compare),
        AdaptiveScaffoldDestination(title: 'Barcode', icon: Icons.barcode_reader),
      ],
      body: _pageAtIndex(_pageIndex),
      onNavigationIndexChange: (newIndex) {
        setState(() {
          _pageIndex = newIndex;
        });
      },
      // floatingActionButton:
      // _hasFloatingActionButton ? _buildFab(context) : null,
    );
  }

  final _beautifyJsonWidget = BeautifyTabJsonWidget();
  final _beautifyTimeWidget = const BeautifyTimeWidget();
  final _beautifyStorageWidget = const BeautifyStorageWidget();
  final _beautifyJsonDiffWidget = BeautifyJsonDiffWidget();
  final _beautifyBarcodeWidget = BeautifyBarcodeWidget();

  Widget _pageAtIndex(int index) {
    if (index == 0) {
      return _beautifyJsonWidget;
    }

    if (index == 1) {
      return _beautifyTimeWidget;
    }

    if (index == 2) {
      return _beautifyStorageWidget;
    }

    if(index == 3) {
      return const BeautifyBase64Widget();
    }

    if(index == 4) {
      return BeautifyJsonExcel();
    }

    if(index == 5) {
      return _beautifyJsonDiffWidget;
    }

    if(index == 6) {
      return _beautifyBarcodeWidget;
    }
    return const Text("setting");
  }

}

