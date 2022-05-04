

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

import "package:font_awesome_flutter/font_awesome_flutter.dart";

import "package:inventree/l10.dart";
import "package:inventree/inventree/model.dart";
import "package:inventree/inventree/notification.dart";
import "package:inventree/widget/refreshable_state.dart";


class NotificationWidget extends StatefulWidget {

  @override
  _NotificationState createState() => _NotificationState();

}


class _NotificationState extends RefreshableState<NotificationWidget> {

  _NotificationState() : super();

  List<InvenTreeNotification> notifications = [];

  @override
  AppBar? buildAppBar(BuildContext context) {
    // No app bar for the notification widget
    return null;
  }

  @override
  Future<void> request (BuildContext context) async {

    final results = await InvenTreeNotification().list();

    notifications.clear();

    for (InvenTreeModel n in results) {
      if (n is InvenTreeNotification) {
        notifications.add(n);
      }
    }
  }

  Future<void> dismissNotification(BuildContext context, InvenTreeNotification notification) async {

    await notification.dismiss();

    refresh(context);

  }

  List<Widget> renderNotifications(BuildContext context) {

    List<Widget> tiles = [];

    tiles.add(
      ListTile(
        title: Text(
          L10().notifications,
        ),
        subtitle: notifications.isEmpty ? Text(L10().notificationsEmpty) : null,
        leading: notifications.isEmpty ? FaIcon(FontAwesomeIcons.bellSlash) : FaIcon(FontAwesomeIcons.bell),
        trailing: Text("${notifications.length}"),
      )
    );

    for (var notification in notifications) {
      tiles.add(
        ListTile(
          title: Text(notification.name),
          subtitle: Text(notification.message),
          trailing: IconButton(
            icon: FaIcon(FontAwesomeIcons.bookmark),
            onPressed: () async {
              dismissNotification(context, notification);
            },
          ),
        )
      );
    }

    return tiles;

  }

  @override
  Widget getBody(BuildContext context) {
    return Center(
      child: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: renderNotifications(context),
        ).toList()
      )
    );
  }

}