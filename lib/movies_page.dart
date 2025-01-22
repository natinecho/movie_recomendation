import 'package:flutter/material.dart';
import 'movie_detail.dart';
import 'TMDB_API.dart';

class MoviesPage extends StatefulWidget {
  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TMDBService tmdbService = TMDBService();
  List<dynamic> movies = [];
  List<dynamic> genres = [];
  String selectedGenre = 'All';
  int page = 1;
  bool isLoading = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchMoviesAndGenres();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(
        child: ListView(
          children: [
            Column(
              children:[ Text('Filter by Genre',
                  style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
          ],),
            ...genres.map((genre) {
              return ListTile(
                title: Text(genre['name']),
                onTap: () {
                  setState(() {
                    selectedGenre = genre['id'].toString();
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent && !isLoading) {
            fetchMoreMovies();
          }
          return false;
        },
        child: Column(
          children: [
            // Search Bar and Filter Icon in the body
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
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
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () {
                       _scaffoldKey.currentState?.openEndDrawer();
                    },
                  ),
                ],
              ),
            ),

            // Movie grid
            Expanded(
              child: GridView.builder(
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

            // Pagination button
            if (isLoading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
