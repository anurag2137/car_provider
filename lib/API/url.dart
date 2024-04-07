class URLS {
  static const _baseURL = "http://192.168.0.152:8000";

  static String accessToken = '';
  static String refreshToken = '';
  static int userid = 0;
  static String userName='';

  static const likeUrl = "$_baseURL/api/cars/1/like/";
  static const carsList = "$_baseURL/api/cars/";
  static const tokenView = "$_baseURL/api/login/";
}
