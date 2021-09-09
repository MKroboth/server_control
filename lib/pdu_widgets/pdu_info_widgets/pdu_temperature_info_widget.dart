import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:server_control/pdu_widgets/pdu_control.dart';

class PDUTemperatureInfoWidget extends StatelessWidget {
  final PDUInfo pduInfo;

  const PDUTemperatureInfoWidget({Key? key, required this.pduInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(Icons.thermostat_sharp),
        title: Row(
          children: [
            Text("Temperature"),
            Spacer(),
            Text(pduInfo.temperature.toCelsiusString()),
          ],
        ),
      );
}
