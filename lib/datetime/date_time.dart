// return todays date as yyyymmdd e.g
String todaysDateYYYYMMDD() {
  //today

  var dateTimeObject = DateTime.now();

  //year in the format yyyy
  String year = dateTimeObject.year.toString();

  //month in format mm

  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }

  //day in the format dd

  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  //final format

  String yyyymmdd = year + month + day;

  return yyyymmdd;
}

//convert string yyyymmdd to Date object
DateTime createDateTimeObject(String yyymmdd) {
  int yyyy = int.parse(yyymmdd.substring(0, 4));
  int mm = int.parse(yyymmdd.substring(4, 6));
  int dd = int.parse(yyymmdd.substring(6, 8));

  DateTime dateTimeObject = DateTime(yyyy, mm, dd);

  return dateTimeObject;
}

//convert DateTime object to string  yyyymmdd

String convertDateTimeToYYYYMMDD(DateTime dateTime) {
  String year = dateTime.year.toString();

  String month = dateTime.month.toString();

  if (month.length == 1) {
    month = '0$month';
  }

  String day = dateTime.day.toString();

  if (day.length == 1) {
    day = '0$day';
  }

  //final
  String yyyymmdd = year + month + day;

  return yyyymmdd;
}
