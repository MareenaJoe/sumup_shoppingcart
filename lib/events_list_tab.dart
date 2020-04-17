import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/app_state_model.dart';
import 'event_row_item.dart';

class EventListTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    print ("EventListTab: Building EventListTab");
    return Consumer<AppStateModel>(
      builder: (context, model, child) {
        final events = model.getEvents();
        return CustomScrollView(
          semanticChildCount: events.length,
          slivers: <Widget>[
            const CupertinoSliverNavigationBar(
              largeTitle: Text('Events List'),
            ),
            SliverSafeArea(
              top: false,
              minimum: const EdgeInsets.only(top: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    if (index < events.length) {
                      return EventRowItem(
                        index: index,
                        event: events[index],
                        lastItem: index == events.length - 1,
                        colour: model.getCurrentSelectedEvent().eventID ==  events[index].eventID ? Colors.blue : Colors.white ,
                      );
                    }

                    return null;
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }
}