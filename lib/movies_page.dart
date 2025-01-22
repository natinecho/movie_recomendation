import 'package:flutter/material.dart';
import 'movie_detail_page.dart';
import 'tmdb_service.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final TMDBService tmdbService = TMDBService();
  List<dynamic> movies = [];
  List<dynamic> genres = [];
  String selectedGenre = 'All';
  int page = 1;
  bool isLoading = false;
  String searchQuery = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMoviesAndGenres();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchMoviesAndGenres() async {
    try {
      final movieData = await tmdbService.fetchMovies('popular', page);
      final genreData = await tmdbService.fetchGenres();

      setState(() {
        movies = movieData;
        genres = [{'id': 'All', 'name': 'All'}, ...genreData];
      });
    } catch (e) {
      print("Error fetching movies and genres: $e");
    }
  }

  Future<void> fetchMoreMovies() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final movieData = await tmdbService.fetchMovies('popular', page + 1);
      setState(() {
        movies.addAll(movieData);
        page++;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching more movies: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      searchQuery = query;
    });

    try {
      final movieData = await tmdbService.searchMovies(query, 1);
      setState(() {
        movies = movieData;
        page = 1; // Reset to the first page when performing a search
        isLoading = false;
      });
    } catch (e) {
      print("Error searching for movies: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<dynamic> filterMoviesByGenre() {
    if (selectedGenre == 'All') {
      return movies;
    }
    return movies
        .where((movie) =>
            movie['genre_ids'] != null &&
            movie['genre_ids'].contains(int.parse(selectedGenre)))
        .toList();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoading) {
      fetchMoreMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Bar with Styling
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by Title',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.blue),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onChanged: (value) {
                  searchMovies(value);
                },
              ),
            ),
          ),

          // Genres as horizontal scrollable buttons
          Container(
            padding: EdgeInsets.all(10),
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: genres.length,
              itemBuilder: (context, index) {
                final genre = genres[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGenre = genre['id'].toString();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      color: selectedGenre == genre['id'].toString()
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      genre['name'],
                      style: TextStyle(
                        color: selectedGenre == genre['id'].toString()
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Movie grid
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              itemCount: filterMoviesByGenre().length,
              itemBuilder: (context, index) {
                final movie = filterMoviesByGenre()[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailPage(movieId: movie['id']),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://image.tmdb.org/t/p/w500${movie['poster_path']}"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),

          // Loading indicator
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
