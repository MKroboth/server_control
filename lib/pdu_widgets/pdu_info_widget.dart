import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_control/pdu_widgets/pdu_control.dart';
import 'package:server_control/pdu_widgets/pdu_info_widgets/pdu_electrical_current_info_widget.dart';
import 'package:server_control/pdu_widgets/pdu_info_widgets/pdu_humidity_info_widget.dart';
import 'package:server_control/pdu_widgets/pdu_info_widgets/pdu_temperature_info_widget.dart';
import 'package:server_control/pdu_widgets/pdu_outlet_control_widget.dart';

import '../tools/force_reload.dart';

@immutable
class PDUInfoWidget extends StatefulWidget {
  const PDUInfoWidget({Key? key}) : super(key: key);

  @override
  _PDUInfoWidgetState createState() => _PDUInfoWidgetState();
}

class _PDUInfoWidgetState extends State<PDUInfoWidget> {
  Widget _wrapWithRefreshIndicator(Widget child) => RefreshIndicator(
        onRefresh: () {
          context.read<ForceReload>().value = true;
          return Future.value();
        },
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    final PDUInfo? pduInfo = context.watch<PDUInfo?>();
    return (pduInfo != null)
        ? _wrapWithRefreshIndicator(
            ListView(
              children: ListTile.divideTiles(context: context, tiles: <Widget>[
                PDUTemperatureInfoWidget(pduInfo: pduInfo),
                PDUElectricalCurrentInfoWidget(pduInfo: pduInfo),
                PDUHumidityInfoWidget(pduInfo: pduInfo),
                ...PDUOutletControlWidget.allOutlets(pduInfo: pduInfo)
              ]).toList(),
            ),
          )
        : _wrapWithRefreshIndicator(Text("Loading pdu info..."));
  }
}
