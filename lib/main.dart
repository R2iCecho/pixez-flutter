import 'package:bloc/bloc.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pixez/bloc/bloc.dart';
import 'package:pixez/generated/l10n.dart';
import 'package:pixez/network/api_client.dart';
import 'package:pixez/network/oauth_client.dart';
import 'package:pixez/page/splash/splash_page.dart';
import 'package:pixez/store/account_store.dart';
import 'package:pixez/store/mute_store.dart';
import 'package:pixez/store/save_store.dart';
import 'package:pixez/store/tag_history_store.dart';
import 'package:pixez/store/user_setting.dart';

final UserSetting userSetting = UserSetting();
final SaveStore saveStore = SaveStore();
final MuteStore muteStore = MuteStore();
final AccountStore accountStore = AccountStore();
final TagHistoryStore tagHistoryStore = TagHistoryStore();
class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }
}

main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    accountStore.fetch();
    super.initState();
    userSetting.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<IllustPersistBloc>(
          create: (context) => IllustPersistBloc(),
        ),
        BlocProvider<MuteBloc>(
          create: (context) => MuteBloc()..add(FetchMuteEvent()),
        ),
      ],
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider<ApiClient>(
            create: (BuildContext context) => ApiClient(),
          ),
          RepositoryProvider<OAuthClient>(
            create: (BuildContext context) => OAuthClient(),
          ),
        ],
        child: MaterialApp(
          navigatorObservers: [BotToastNavigatorObserver()],
          home: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
              child: SplashPage()),
          title: 'PixEz',
          builder: BotToastInit(),
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.cyan[500],
            accentColor: Colors.cyan[400],
            indicatorColor: Colors.cyan[500],
          ),
          darkTheme: ThemeData(
              brightness: Brightness.dark,
              accentColor: Colors.cyan[500],
              ),
          supportedLocales: I18n.delegate.supportedLocales,
          localizationsDelegates: [
            I18n.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
        ),
      ),
    );
  }
}
