import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'model/app_state_model.dart';
import 'app.dart';

void main() {
  // This app is designed only to work vertically, so we limit
  // orientations to portrait up and down.
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  return runApp(
    ChangeNotifierProvider<AppStateModel>(
        create: (context) => AppStateModel()..loadAll(),
        child: EventStoreApp(),
  ),
  );
}

