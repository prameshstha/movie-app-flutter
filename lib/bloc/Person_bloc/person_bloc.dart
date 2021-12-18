import 'dart:async';

import 'package:flutter_api/Model/person.dart';
import 'package:flutter_api/Service/api_service.dart';
import 'package:flutter_api/bloc/Person_bloc/person_bloc_event.dart';

class PersonBloc {
  final service = ApiService();
  final _stateStreamController = StreamController<List<Person>>();

  StreamSink<List<Person>> get _personSink => _stateStreamController.sink;
  Stream<List<Person>> get personStream => _stateStreamController.stream;

  final _eventStreamController = StreamController<PersonEvent>();
  StreamSink<PersonEvent> get eventSink => _eventStreamController.sink; //input
  Stream<PersonEvent> get _eventStream =>
      _eventStreamController.stream; //output

  PersonBloc() {
    // Whenever there is a new event, we want to map it to a new state
    _eventStreamController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(PersonEvent event) async {
    if (event is GetPerson) {
      try {
        var person = await service.getTrendingPerson();
        if (person != null) {
          _personSink.add(person);
        } else {
          _personSink.addError('Null');
        }
      } on Exception catch (e) {
        print(e);
        _personSink.addError('Something went wrong');
      }
    }
  }

  void dispose() {
    _stateStreamController.close();
    _eventStreamController.close();
  }
}
