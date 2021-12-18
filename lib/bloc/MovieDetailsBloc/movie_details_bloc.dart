import 'dart:async';

import 'package:flutter_api/Model/movie_detail.dart';
import 'package:flutter_api/Service/api_service.dart';
import 'package:flutter_api/bloc/MovieDetailsBloc/movie_details_event_bloc.dart';

class MovieDetailsBloc {
  final service = ApiService();
  final _stateStreamController = StreamController<MovieDetail>();

  StreamSink<MovieDetail> get _movieDetailsSink => _stateStreamController.sink;
  Stream<MovieDetail> get movieDetailsStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<MovieDetailsEvent>();
  StreamSink<MovieDetailsEvent> get eventSink =>
      _eventStreamController.sink; //input
  Stream<MovieDetailsEvent> get _eventStream =>
      _eventStreamController.stream; //output

  MovieDetailsBloc() {
    // Whenever there is a new event, we want to map it to a new state
    _eventStreamController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(MovieDetailsEvent event) async {
    if (event is GetMoviesDetails) {
      var movieId = event.movieId;

      try {
        var movie = await service.getMovieDetails(movieId);
        if (movie != null) {
          _movieDetailsSink.add(movie);
        } else {
          _movieDetailsSink.addError('Null');
        }
      } on Exception catch (e) {
        print(e);
        _movieDetailsSink.addError('Something went wrong');
      }
    }
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
