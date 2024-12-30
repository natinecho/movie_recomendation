import 'dart:convert';
import 'package:http/http.dart' as http;

// class TMDBService {
//   final String apiKey = "500f8710dfe90e56d66d96eb867fab60";  // Replace with your actual TMDB API key
//   final String baseUrl = "https://api.themoviedb.org/3";

//   Future<List<dynamic>> fetchMovies(String category, int page) async {
//     final url = Uri.parse('$baseUrl/movie/$category?api_key=$apiKey&page=$page');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['results']; // List of movies
//     } else {
//       throw Exception('Failed to fetch movies');
//     }
//   }

//   Future<List<dynamic>> fetchGenres() async {
//     final url = Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['genres']; // List of genres
//     } else {
//       throw Exception('Failed to fetch genres');
//     }
//   }

//   Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
//     final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body); // Movie details
//     } else {
//       throw Exception('Failed to fetch movie details');
//     }
//   }

//   Future<List<dynamic>> fetchSimilarMovie(int movieId) async {
//     final url = Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey');
//     final response = await http.get(url);

//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['results']; // List of similar movies
//     } else {
//       throw Exception('Failed to fetch similar movies');
//     }
//   }
// }

class TMDBService {
  final String apiKey = "500f8710dfe90e56d66d96eb867fab60";  // Replace with your actual TMDB API key
  final String baseUrl = "https://api.themoviedb.org/3";

  Future<List<dynamic>> fetchMovies(String category, int page) async {
    final url = Uri.parse('$baseUrl/movie/$category?api_key=$apiKey&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results']; // List of movies
    } else {
      throw Exception('Failed to fetch movies');
    }
  }

  Future<List<dynamic>> fetchGenres() async {
    final url = Uri.parse('$baseUrl/genre/movie/list?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['genres']; // List of genres
    } else {
      throw Exception('Failed to fetch genres');
    }
  }

  Future<List<dynamic>> searchMovies(String query, int page) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query&page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results']; // List of movies matching the search
    } else {
      throw Exception('Failed to search for movies');
    }
  }

  Future<Map<String, dynamic>> fetchMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Movie details
    } else {
      throw Exception('Failed to fetch movie details');
    }
  }

  Future<List<dynamic>> fetchSimilarMovie(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/similar?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results']; // List of similar movies
    } else {
      throw Exception('Failed to fetch similar movies');
    }
  }
}
