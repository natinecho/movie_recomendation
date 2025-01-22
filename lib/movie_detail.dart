import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  MovieDetailPage({required this.movieId});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  Map<String, dynamic>? movieDetails;
  List<dynamic> relatedMovies = [];
  Map<int, String> genres = {};

  final String apiKey =
      "500f8710dfe90e56d66d96eb867fab60"; // Replace with your TMDB API key
  final String baseUrl = "https://api.themoviedb.org/3";

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchGenres();
  }

  Future<void> fetchMovieDetails() async {
    try {
      final detailsResponse = await http.get(
        Uri.parse(
            "$baseUrl/movie/${widget.movieId}?api_key=$apiKey&language=en-US"),
      );
      final relatedResponse = await http.get(
        Uri.parse(
            "$baseUrl/movie/${widget.movieId}/similar?api_key=$apiKey&language=en-US"),
      );

      if (detailsResponse.statusCode == 200 &&
          relatedResponse.statusCode == 200) {
        setState(() {
          movieDetails = json.decode(detailsResponse.body);
          relatedMovies = json.decode(relatedResponse.body)['results'] ?? [];
        });
      } else {
        print("Error fetching movie details: ${detailsResponse.statusCode}");
      }
    } catch (e) {
      print("Error fetching movie details: $e");
    }
  }

  Future<void> fetchGenres() async {
    try {
      final genreResponse = await http.get(
        Uri.parse("$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US"),
      );

      if (genreResponse.statusCode == 200) {
        final genreList = json.decode(genreResponse.body)['genres'] ?? [];
        setState(() {
          genres = {for (var genre in genreList) genre['id']: genre['name']};
        });
      } else {
        print("Error fetching genres: ${genreResponse.statusCode}");
      }
    } catch (e) {
      print("Error fetching genres: $e");
    }
  }

  String getGenreNames(List<dynamic>? genreIds) {
    if (genres.isEmpty || genreIds == null) return "Unknown genres";
    return genreIds
        .map((id) => genres[int.parse(id.toString())] ?? "Unknown")
        .join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: const Color.fromARGB(255, 78, 73, 73)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: movieDetails == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Image.network(
                        "https://image.tmdb.org/t/p/w500${movieDetails?['poster_path'] ?? ''}",
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 300,
                            color: Colors.grey[300],
                            child: Icon(Icons.broken_image,
                                size: 100, color: Colors.grey),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieDetails?['title'] ?? 'No title available',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),

                        Row(children: [
                          Icon(Icons.star, color: Colors.yellow, size: 20),
                          SizedBox(width: 5),
                          Text(
                            "${movieDetails?['vote_average'] ?? 'N/A'}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ]),
                        // Rating and Release Date Row

                        SizedBox(height: 10),

                        Text(
                          "Release date",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 5),

                        Text(
                          movieDetails?['release_date'] ??
                              'Release date not available',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Overview",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          movieDetails?['overview'] ?? 'No overview available',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Genres",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              movieDetails?['genres']?.map<Widget>((genre) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        genre['name'],
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList() ??
                                  [Text("Unknown genres")],
                        ),

                        SizedBox(height: 30),
                        Text('Related Movies',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          child: relatedMovies.isEmpty
                              ? Center(
                                  child: Text('No related movies available'))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: relatedMovies.length,
                                  itemBuilder: (context, index) {
                                    final movie = relatedMovies[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieDetailPage(
                                                    movieId: movie['id']),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                "https://image.tmdb.org/t/p/w500${movie['poster_path']}"),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
