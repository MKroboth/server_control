import 'package:flutter/material.dart';

class ServerStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListView(
        children: [
          Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Raine",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: 14),
                      child: Text(
                        "OK",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      );
}
