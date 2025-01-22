import 'package:flutter/material.dart';
import 'dart:math';
import 'movie_detail_page.dart';
import 'tmdb_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TMDBService tmdbService = TMDBService();
  List<dynamic> mostViewed = [];
  List<dynamic> popular = [];
  List<dynamic> recent = [];
  Map<String, dynamic>? recommendedMovie;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final mostViewedMovies = await tmdbService.fetchMovies('top_rated', 1);
      final popularMovies = await tmdbService.fetchMovies('popular', 1);
      final recentMovies = await tmdbService.fetchMovies('now_playing', 1);

      setState(() {
        mostViewed = mostViewedMovies;
        popular = popularMovies;
        recent = recentMovies;

        // Select a random recommended movie
        if (popularMovies.isNotEmpty) {
          final randomIndex = Random().nextInt(popularMovies.length);
          recommendedMovie = popularMovies[randomIndex];
        }
      });
    } catch (e) {
      print("Error fetching movies: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed from black to white
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recommendedMovie != null) ...[
              RecommendedMovieCard(movie: recommendedMovie!),
            ],
            SectionTitle(title: 'Popular'),
            MovieScroll(movies: popular),
            SectionTitle(title: 'Recent'),
            MovieScroll(movies: recent),
            SectionTitle(title: 'Most Viewed'),
            MovieScroll(movies: mostViewed),
          ],
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Changed from white to black for light theme
        ),
      ),
    );
  }
}

class MovieScroll extends StatelessWidget {
  final List<dynamic> movies;

  MovieScroll({required this.movies});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 250,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(movieId: movie['id']),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: screenWidth * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(
                      "https://image.tmdb.org/t/p/w500${movie['poster_path']}"),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Lighter shadow
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.2), Colors.transparent], // Lighter gradient
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  movie['title'] ?? 'No Title',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class RecommendedMovieCard extends StatelessWidget {
  final Map<String, dynamic> movie;

  RecommendedMovieCard({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailPage(movieId: movie['id']),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(
                "https://image.tmdb.org/t/p/w500${movie['poster_path']}"),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Lighter shadow
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.6), Colors.transparent], // Lighter gradient
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            '${movie['title'] ?? 'No Title'}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
