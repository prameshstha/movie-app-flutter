import 'package:dio/dio.dart';
import 'package:flutter_api/Model/cast_list.dart';
import 'package:flutter_api/Model/genre.dart';
import 'package:flutter_api/Model/movie.dart';
import 'package:flutter_api/Model/movie_detail.dart';
import 'package:flutter_api/Model/movie_image.dart';
import 'package:flutter_api/Model/person.dart';
import 'package:flutter_api/constant.dart';

class ApiService {
  final Dio _dio = Dio();

  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = ServiceApi().apiKey;

  Future<List<Movie>> getNowPlayingMovie() async {
    final url = '$baseUrl/movie/now_playing?api_key=$apiKey';
    // print('Api call: $url');
    try {
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;

      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Movie>> getMovieByGenre(int genreId) async {
    final url = '$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId';
    // print('Api call: $url');
    try {
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;

      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();

      return movieList;
    } catch (error, stacktrace) {
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Genre>> getGenre() async {
    final url = '$baseUrl/genre/movie/list?api_key=$apiKey';
    // print('Api call: $url');
    try {
      final response = await _dio.get(url);
      var genre = response.data['genres'] as List;
      List<Genre> genreList = genre.map((m) => Genre.fromJson(m)).toList();

      return genreList;
    } catch (error, stacktrace) {
      print(error);
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Person>> getTrendingPerson() async {
    final url = '$baseUrl/person/popular?api_key=$apiKey';
    // print('Api call: $url');
    try {
      final response = await _dio.get(url);
      var personData = response.data['results'] as List;

      List<Person> personList =
          personData.map((m) => Person.fromJson(m)).toList();

      return personList;
    } catch (error, stacktrace) {
      print(error);
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieDetail> getMovieDetails(int movieId) async {
    final url = '$baseUrl/movie/$movieId?api_key=$apiKey';
    // print('Api call: $url');
    try {
      final response = await _dio.get(url);

      MovieDetail movieDetail = MovieDetail.fromJson(response.data);
      movieDetail.trailerId = await getYoutubeId(movieId);
      movieDetail.movieImage = await getMovieImage(movieId);
      movieDetail.castList = await getCastList(movieId);

      return movieDetail;
    } catch (error, stacktrace) {
      print(error);
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<String> getYoutubeId(int movieId) async {
    final url = '$baseUrl/movie/$movieId/videos?api_key=$apiKey';
    // print('Api call: $url');
    try {
      final response = await _dio.get(url);
      List list = response.data['results'];
      var youtubeId = list.isNotEmpty
          ? response.data['results'][0]['key']
          : ''; // documentary movie diego has no youtube link to need to check this.

      return youtubeId;
    } catch (error, stacktrace) {
      print(error);
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<MovieImage> getMovieImage(int movieId) async {
    final url = '$baseUrl/movie/$movieId/images?api_key=$apiKey';
    // print('Api call: $url');
    try {
      final response = await _dio.get(url);

      return MovieImage.fromJson(response.data);
    } catch (error, stacktrace) {
      print(error);
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }

  Future<List<Cast>> getCastList(int movieId) async {
    final url = '$baseUrl/movie/$movieId/credits?api_key=$apiKey';
    // print('Api call: $url');
    try {
      final response = await _dio.get(url);
      var list = response.data['cast'] as List;

      List<Cast> castList = list
          .map((m) => Cast(
              name: m['name'],
              profilePath: m['profile_path'],
              character: m['character']))
          .toList();

      return castList;
    } catch (error, stacktrace) {
      print(error);
      throw Exception('Exception occured: $error with stacktrace: $stacktrace');
    }
  }
}
