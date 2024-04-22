import 'package:my_travel/models/activity.model.dart';
import 'package:my_travel/models/place_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_KEY_API = "AIzaSyC5DSqt4kRA2To_r-cbWUQMbUycYZZp1Ro";

Uri _queryAutocompleteBuilder(String query) {
  return Uri.parse(
      'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$query&key=$GOOGLE_KEY_API');
}

Uri _queryPlaceDetailsBuilder(String placeId) {
  return Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?fields=name%2Crating%2Cformatted_address,geometry&place_id=$placeId&key=$GOOGLE_KEY_API');
}

Future<List<Place>> getAutocompleteSuggestions(String query) async {
  try {
    var response = await http.get(_queryAutocompleteBuilder(query));
    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      return (body['predictions'] as List)
          .map(
            (suggestion) => Place(
                description: suggestion['description'],
                placeId: suggestion['place_id']),
          )
          .toList();
    } else {
      return [];
    }
  } catch (e) {
    rethrow;
  }
}

Future<LocationActivity> getPlaceDetailsApi(String placeId) async {
  try {
    var response = await http.get(_queryPlaceDetailsBuilder(placeId));
    if (response.statusCode == 200) {
      var body = json.decode(response.body)['result'];
      return LocationActivity(
        address: body['formatted_address'],
        longitude: body['geometry']['location']['lng'],
        latitude: body['geometry']['location']['lat'],
      );
    } else {
      throw 'Erreur !';
    }
  } catch (e) {
    rethrow;
  }
}
