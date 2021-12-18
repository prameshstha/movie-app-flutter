import 'package:flutter_api/Model/cast_list.dart';
import 'package:flutter_api/Model/movie_image.dart';

class MovieDetail {
  final String id;
  final String title;
  final String backdropPath;
  final String budget;
  final String homePage;
  final String originalTitle;
  final String overview;
  final String releaseDate;
  final String runtime;
  final String voteAverage;
  final String voteCount;

  String? trailerId;

  MovieImage? movieImage;

  List<Cast>? castList;

  MovieDetail(
      {required this.id,
      required this.title,
      required this.backdropPath,
      required this.budget,
      required this.homePage,
      required this.originalTitle,
      required this.overview,
      required this.releaseDate,
      required this.runtime,
      required this.voteAverage,
      required this.voteCount});

  factory MovieDetail.fromJson(dynamic json) {
    if (json == null) {
      return MovieDetail(
          id: json['id'].toString(),
          title: json['title'],
          backdropPath: json['backdrop_path'],
          budget: json['budget'].toString(),
          homePage: json['home_page'],
          originalTitle: json['original_title'],
          overview: json['overview'],
          releaseDate: json['release_date'],
          runtime: json['runtime'].toString(),
          voteAverage: json['vote_average'].toString(),
          voteCount: json['vote_count'].toString());
    }

    return MovieDetail(
        id: json['id'].toString(),
        title: json['title'],
        backdropPath: json['backdrop_path'],
        budget: json['budget'].toString(),
        homePage: json['home_page'],
        originalTitle: json['original_title'],
        overview: json['overview'],
        releaseDate: json['release_date'],
        runtime: json['runtime'].toString(),
        voteAverage: json['vote_average'].toString(),
        voteCount: json['vote_count'].toString());
  }
}
