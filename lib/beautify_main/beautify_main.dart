

import 'package:beautify/beautify_base64/beautify_base64.dart';
import 'package:beautify/beautify_json/beautify_tab_json.dart';
import 'package:beautify/beautify_storage/beautify_storage.dart';
import 'package:beautify/beautify_time/beautify_time.dart';
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
        AdaptiveScaffoldDestination(title: 'JSON', icon: Icons.brightness_1_outlined),
        AdaptiveScaffoldDestination(title: 'Time', icon: Icons.access_time),
        AdaptiveScaffoldDestination(title: 'Storage', icon: Icons.storage_outlined),
        AdaptiveScaffoldDestination(title: 'Base64', icon: Icons.backpack_outlined),
        AdaptiveScaffoldDestination(title: 'Setting', icon: Icons.settings),
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

    return const Text("setting");
  }

}

