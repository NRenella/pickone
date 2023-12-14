class Movie{
  final String name;
  final String image;
  final String overview;
  final double rating;
  final int id;

  Movie({
    required this.name,
    required this.image,
    required this.overview,
    required this.rating,
    required this.id
  });

  factory Movie.fromJson(dynamic json){
    return Movie(
      name: json['title'] as String,
      image: 'https://image.tmdb.org/t/p/w300${json['poster_path'] as String}',
      overview: json['overview'] as String,
      rating: json['vote_average'] as double,
      id: json['id'] as int
    );
  }
  static List<Movie> moviesFromSnapshot(List snapshot){
    return snapshot.map((data) {
      return Movie.fromJson(data);
    }).toList();
  }

  @override
  String toString(){
    return 'Movie {name: $name}, image: {$image},';
  }
}