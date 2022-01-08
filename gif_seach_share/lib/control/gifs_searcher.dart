import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:gif_seach_share/giphy_api/api_url.dart';

class GifSearcher {
  final String? _term;

  GifSearcher(this._term);

  Future<Map> getGifs(int offset) async {
    Uri uri;
    if (_term == null || _term!.isEmpty) {
      uri = Uri.parse(GiphyApi.getTrendingUrl());
    } else {
      uri = Uri.parse(GiphyApi.getSearchUrl(_term, offset));
    }
    var response = await http.get(uri);
    return json.decode(response.body);
  }





}