import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DateFormatUtils {
  static String parseDate(DateTime date) {
    return "${DateFormat.Md().format(date)}\n${date.year}";
  }

  static String parseTime(DateTime time) {
    return DateFormat.jm().format(time);
  }
}

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      await launchUrl(Uri.parse(googleUrl));
    } else {
      throw 'Could not open the map.';
    }
  }
}
