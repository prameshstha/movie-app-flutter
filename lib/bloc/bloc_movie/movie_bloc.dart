import 'dart:async';

import 'package:flutter_api/Model/movie.dart';
import 'package:flutter_api/Service/api_service.dart';
import 'package:flutter_api/bloc/bloc_movie/movie_bloc_event.dart';

enum MovieControlAction {
  fetch,
  delete,
  byGenre,
}

class MovieBloc {
  final service = ApiService();
  final _stateStreamController = StreamController<List<Movie>>();

  StreamSink<List<Movie>> get _movieSink => _stateStreamController.sink;
  Stream<List<Movie>> get movieStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<MovieEvent>();
  StreamSink<MovieEvent> get eventSink => _eventStreamController.sink; //input
  Stream<MovieEvent> get _eventStream => _eventStreamController.stream; //output

  MovieBloc() {
    // Whenever there is a new event, we want to map it to a new state
    _eventStreamController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(MovieEvent event) async {
    if (event is GetMovies) {
      var genreId = event.genreId;
      if (genreId == 0) {
        try {
          var movies = await service.getNowPlayingMovie();
          if (movies != null) {
            _movieSink.add(movies);
          } else {
            _movieSink.addError('Null');
          }
        } on Exception catch (e) {
          print(e);
          _movieSink.addError('Something went wrong');
        }
      } else {
        var moviesByGenre = await service.getMovieByGenre(genreId);
        if (moviesByGenre != null) {
          _movieSink.add(moviesByGenre);
        } else {
          _movieSink.addError('Null');
        }
      }
    }
  }

  // MovieBloc() {
  //   _eventStream.listen((event) async {
  //     if (event == MovieControlAction.fetch) {
  //       try {
  //         var movies = await service.getNowPlayingMovie();
  //         if (movies != null) {
  //           _movieSink.add(movies);
  //         } else {
  //           _movieSink.addError('Null');
  //         }
  //       } on Exception catch (e) {
  //         print(e);
  //         _movieSink.addError('Something went wrong');
  //       }
  //     } else if (event == MovieControlAction.byGenre) {
  //       var moviesByGenre = await service.getMovieByGenre(genreId);
  //       if (moviesByGenre != null) {
  //         _movieSink.add(moviesByGenre);
  //       } else {
  //         _movieSink.addError('Null');
  //       }
  //     }
  //   });
  // }
  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
