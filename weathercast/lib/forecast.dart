import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

import 'location.dart';
import 'weather.dart';

Future<Weather> forecast() async {
  const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
  const token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjY4NjllZTViNmVhYzgzNTkwYjFiOGUxMjQ5ZmYwMmQzM2NkYTEyNzc2YTViOTM3YzVjMjZlYTgxZjUzNjc0NWUxMWFjZDgxZjhjNTQwY2I4In0.eyJhdWQiOiIyIiwianRpIjoiNjg2OWVlNWI2ZWFjODM1OTBiMWI4ZTEyNDlmZjAyZDMzY2RhMTI3NzZhNWI5MzdjNWMyNmVhODFmNTM2NzQ1ZTExYWNkODFmOGM1NDBjYjgiLCJpYXQiOjE2Njg5MzM1MTYsIm5iZiI6MTY2ODkzMzUxNiwiZXhwIjoxNzAwNDY5NTE2LCJzdWIiOiIyMjcwIiwic2NvcGVzIjpbXX0.kl7Z40VNO397IL2gjefuKEShFE86yMltCFhyY7OrmstwaBmB-d_afiJmsDvsnRCG9ro1R2DbVQbGVP1_O1cQvDtfhovun8lYZFYzR8R049Lm1nWkTtS12au_pWP-yvJu2MLsCoRtB-NDDhsMlOHhNoX1FyRcqndt9wqNM0Ezq9BrnhCl3vX9hpH6NJi5qjl65b2TbLCoZ85UJHiNgFWWwe4vlmWJcdoYueNcfj_eBeT7DFjoWAOBUa2_kQRFABNcFuWnD8vlrzTmOdTa9-nN6Zax0z4fz7Sl-lIYcc7QIvlDitCr8g9znVBfa8ncGmu6lpu19L9tiQmLChTLdH8CbmNSZ1o20tHTMaW2jWx39WzcY2kFKq2mxANkz6KpUEfIDPVA-bnMmg18bBg-uM1qGNWer-XzkbLXtb2bNenZe-VOGMz_zAcRI0K_NKMk_SFJN6j73ay4XLG-J7p-cMLK0lQFwzpWE3inIkRfjXIB08komS77DxgwDPgKy4ZvWXvCawtmutONmJ7uGcFQ6MK56n_8xEdGryGRdJzek5aztr8qJ37Ftw59Si8k5Eh8nxq-K71Yswss6k-yi6u-z4zOiyyLImhC6XKISJ7of4glSwY1TJH9xmhlT1qTOlgn5NUkbYz37iojVbNEr9eUWBHn4D1PrXXiDha8fT-swVwQcwo';

  try {
    Position location = await getCurrentLocation();
    http.Response response = await http.get(
      Uri.parse('$url?lat=${location.latitude}&lon=${location.longitude}&fields=tc,cond'), 
      headers: {
      'accept': 'application/json',
      'authorization': 'Bearer $token',
  }
);
      if(response.statusCode == 200) {
        var result = jsonDecode(response.body)['WeatherForecasts'][0]['forecasts'][0]['data'];
        Placemark address = (await placemarkFromCoordinates(location.latitude, location.longitude)).first;
        return Weather(
          address: '${address.subLocality}\n${address.administrativeArea}',
          temperature: result['tc'],
          cond: result['cond'],
        );
      } else {
        return Future.error(response.statusCode);
      }
  } catch (e) {
    return Future.error(e);
}
}