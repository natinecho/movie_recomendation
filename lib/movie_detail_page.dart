// import 'package:flutter/material.dart';
// import 'tmdb_service.dart';

// class MovieDetailPage extends StatefulWidget {
//   final int movieId;

//   MovieDetailPage({required this.movieId});

//   @override
//   _MovieDetailPageState createState() => _MovieDetailPageState();
// }

// class _MovieDetailPageState extends State<MovieDetailPage> {
//   final TMDBService tmdbService = TMDBService();
//   Map<String, dynamic>? movieDetails;
//   List<dynamic> relatedMovies = [];
//   Map<int, String> genres = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchMovieDetails();
//     fetchGenres();
//   }

//   Future<void> fetchMovieDetails() async {
//     try {
//       final details = await tmdbService.fetchMovieDetails(widget.movieId);
//       final related = await tmdbService.fetchSimilarMovie(widget.movieId);

//       setState(() {
//         movieDetails = details;
//         relatedMovies = related;
//       });
//     } catch (e) {
//       print("Error fetching movie details: $e");
//     }
//   }

//   Future<void> fetchGenres() async {
//     try {
//       final genreList = await tmdbService.fetchGenres();
//       setState(() {
//         genres = {for (var genre in genreList) genre['id']: genre['name']};
//       });
//     } catch (e) {
//       print("Error fetching genres: $e");
//     }
//   }

//   String getGenreNames(List<dynamic>? genreIds) {
//     if (genres.isEmpty || genreIds == null) return "Unknown genres";
//     return genreIds
//         .map((id) => genres[int.parse(id.toString())] ?? "Unknown")
//         .join(", ");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 78, 73, 73)),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: movieDetails == null
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       Image.network(
//                         "https://image.tmdb.org/t/p/w500${movieDetails?['poster_path'] ?? ''}",
//                         width: double.infinity,
//                         height: 300,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Container(
//                             width: double.infinity,
//                             height: 300,
//                             color: Colors.grey[300],
//                             child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           movieDetails?['title'] ?? 'No title available',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           "Genres",
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         SizedBox(height: 10),
//                         Wrap(
//                           spacing: 8,
//                           runSpacing: 8,
//                           children: movieDetails?['genres']?.map<Widget>((genre) {
//                                 return Container(
//                                   padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: Text(
//                                     genre['name'],
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 );
//                               }).toList() ??
//                               [Text("Unknown genres")],
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           "Overview",
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           movieDetails?['overview'] ?? 'No overview available',
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           "Popularity",
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "${movieDetails?['popularity'] ?? 'N/A'}",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           "Rating",
//                           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                         ),
//                         SizedBox(height: 5),
//                         Text(
//                           "${movieDetails?['vote_average'] ?? 'N/A'} (${movieDetails?['vote_count'] ?? 0} votes)",
//                           style: TextStyle(fontSize: 16),
//                         ),
//                         SizedBox(height: 30),
//                         Text('Related Movies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                         SizedBox(height: 10),
//                         Container(
//                           height: 200,
//                           child: relatedMovies.isEmpty
//                               ? Center(child: Text('No related movies available'))
//                               : ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: relatedMovies.length,
//                                   itemBuilder: (context, index) {
//                                     final movie = relatedMovies[index];
//                                     return GestureDetector(
//                                       onTap: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) =>
//                                                 MovieDetailPage(movieId: movie['id']),
//                                           ),
//                                         );
//                                       },
//                                       child: Container(
//                                         margin: EdgeInsets.all(5),
//                                         width: 140,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(10),
//                                           image: DecorationImage(
//                                             image: NetworkImage(
//                                                 "https://image.tmdb.org/t/p/w500${movie['poster_path']}"),
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'tmdb_service.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  MovieDetailPage({required this.movieId});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final TMDBService tmdbService = TMDBService();
  Map<String, dynamic>? movieDetails;
  List<dynamic> relatedMovies = [];
  Map<int, String> genres = {};

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchGenres();
  }

  Future<void> fetchMovieDetails() async {
    try {
      final details = await tmdbService.fetchMovieDetails(widget.movieId);
      final related = await tmdbService.fetchSimilarMovie(widget.movieId);

      setState(() {
        movieDetails = details;
        relatedMovies = related;
      });
    } catch (e) {
      print("Error fetching movie details: $e");
    }
  }

  Future<void> fetchGenres() async {
    try {
      final genreList = await tmdbService.fetchGenres();
      setState(() {
        genres = {for (var genre in genreList) genre['id']: genre['name']};
      });
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
          icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 78, 73, 73)),
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
                            child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
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
                        // Rating and Release Date Row
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.yellow, size: 20),
                            SizedBox(width: 5),
                            Text(
                              "${movieDetails?['vote_average'] ?? 'N/A'} (${movieDetails?['vote_count'] ?? 0} votes)",
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(width: 20),
                            Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                            SizedBox(width: 5),
                            Text(
                              movieDetails?['release_date'] ?? 'Release date not available',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Genres",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: movieDetails?['genres']?.map<Widget>((genre) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    genre['name'],
                                    style: TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList() ?? [Text("Unknown genres")],
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Overview",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 5),
                        Text(
                          movieDetails?['overview'] ?? 'No overview available',
                          style: TextStyle(fontSize: 16),
                        ),
            
                        SizedBox(height: 30),
                        Text('Related Movies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 10),
                        Container(
                          height: 200,
                          child: relatedMovies.isEmpty
                              ? Center(child: Text('No related movies available'))
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
                                                MovieDetailPage(movieId: movie['id']),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        width: 140,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
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
