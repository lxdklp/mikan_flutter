const APP_CHANNEL = String.fromEnvironment('APP_CHANNEL', defaultValue: 'github');

class MikanFunc {
  const MikanFunc._();

  static const String season = 'SEASON';
  static const String day = 'DAY';
  static const String search = 'SEARCH';
  static const String list = 'LIST';
  static const String user = 'USER';
  static const String index = 'INDEX';
  static const String subgroup = 'SUBGROUP';
  static const String bangumi = 'BANGUMI';
  static const String bangumiMore = 'BANGUMI_MORE';
  static const String details = 'DETAILS';
  static const String subscribeBangumi = 'SUBSCRIBE_BANGUMI';
  static const String unsubscribeBangumi = 'UNSUBSCRIBE_BANGUMI';
  static const String subscribedSeason = 'SUBSCRIBED_SEASON';
  static const String refreshLoginToken = 'REFRESH_LOGIN_TOKEN';
  static const String refreshRegisterToken = 'REFRESH_REGISTER_TOKEN';
  static const String refreshForgotPasswordToken = 'REFRESH_FORGOTPASSWORD_TOKEN';
}

class MikanUrls {
  const MikanUrls._();

  static const List<String> baseUrls = ['https://mikanime.tv', 'https://mikanani.me'];

  static late String baseUrl;

  static String get dayUpdate => '$baseUrl/Home/EpisodeUpdateRows';

  static String get seasonUpdate => '$baseUrl/Home/BangumiCoverFlowByDayOfWeek';

  static String get search => '$baseUrl/Home/Search';

  static String get list => '$baseUrl/Home/Classic';

  static String get subgroup => '$baseUrl/Home/PublishGroup';

  static String get bangumi => '$baseUrl/Home/Bangumi';

  static String get bangumiMore => '$baseUrl/Home/ExpandEpisodeTable';

  static String get login => '$baseUrl/Account/Login';

  static String get register => '$baseUrl/Account/Register';

  static String get forgotPassword => '$baseUrl/Account/ForgotPassword';

  static String get subscribeBangumi => '$baseUrl/Home/SubscribeBangumi';

  static String get unsubscribeBangumi => '$baseUrl/Home/UnsubscribeBangumi';

  static String get subscribedSeason => '$baseUrl/Home/BangumiCoverFlow';

  static String get mySubscribed => '$baseUrl/Home/MyBangumi';
}

class ExtraUrl {
  const ExtraUrl._();

  static const String fontsBaseUrl = 'https://fonts.bytex.space';
  static const String fontsManifest = '$fontsBaseUrl/fonts-manifest.json';
  static const String releaseVersion = 'https://api.github.com/repos/iota9star/mikan_flutter/releases/latest';
}
