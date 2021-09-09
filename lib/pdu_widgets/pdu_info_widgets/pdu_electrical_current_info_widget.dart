import 'package:flutter/material.dart';
import 'package:server_control/pdu_widgets/pdu_control.dart';
import 'package:server_control/tools/drop_last_if.dart';

class PDUElectricalCurrentInfoWidget extends StatelessWidget {
  final PDUInfo pduInfo;

  const PDUElectricalCurrentInfoWidget({Key? key, required this.pduInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(Icons.bolt),
        title: Row(
          children: [
            Text("Current"),
            Spacer(),
            Text(
                "${pduInfo.electricCurrent.toStringAsFixed(4).dropLastWhile((e) => e == '0')} A"),
          ],
        ),
      );
}
