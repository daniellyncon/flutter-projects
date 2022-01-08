
class GiphyApi {
  static String getTrendingUrl() {
    return 'https://api.giphy.com/v1/gifs/trending?api_key=XLggEunfi5flPLMgswstg4oam4Cx53sN&limit=20&rating=g';
  }

  static String getSearchUrl(term, offset) {
    return 'https://api.giphy.com/v1/gifs/search?api_key=XLggEunfi5flPLMgswstg4oam4Cx53sN&q=$term&limit=19&offset=$offset&rating=g&lang=en';
  }
}
