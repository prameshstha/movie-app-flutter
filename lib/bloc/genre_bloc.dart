import 'dart:async';

import 'package:flutter_api/Model/genre.dart';
import 'package:flutter_api/Service/api_service.dart';

enum GenreControlAction { fetch, delete }

class GenreBloc {
  final service = ApiService();
  final _stateStreamController = StreamController<List<Genre>>();
  StreamSink<List<Genre>> get _genreSink => _stateStreamController.sink;
  Stream<List<Genre>> get genreStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<GenreControlAction>();
  StreamSink<GenreControlAction> get eventSink =>
      _eventStreamController.sink; //input
  Stream<GenreControlAction> get _eventStream =>
      _eventStreamController.stream; //output

  GenreBloc() {
    _eventStream.listen((event) async {
      if (event == GenreControlAction.fetch) {
        try {
          var genre = await service.getGenre();
          if (genre != null) {
            _genreSink.add(genre);
          } else {
            _genreSink.addError('Null');
          }
        } on Exception catch (e) {
          print(e);
          _genreSink.addError('Something went wrong');
        }
      }
    });
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
