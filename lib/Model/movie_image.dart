import 'package:flutter_api/Model/screen_shot.dart';

class MovieImage {
  final List<Screenshot> backdrops;
  final List<Screenshot> posters;

  const MovieImage({required this.backdrops, required this.posters});

  factory MovieImage.fromJson(Map<String, dynamic> result) {
    if (result == null) {
      return MovieImage(
        backdrops: (result['backdrops'] as List)
            .map((b) => Screenshot.fromJson(b))
            .toList(),
        posters: (result['posters'] as List)
            .map((b) => Screenshot.fromJson(b))
            .toList(),
      );
    }

    return MovieImage(
      backdrops: (result['backdrops'] as List)
          .map((b) => Screenshot.fromJson(b))
          .toList(),
      posters: (result['posters'] as List)
          .map((b) => Screenshot.fromJson(b))
          .toList(),
    );
  }

  @override
  List<Object> get props => [backdrops, posters];
}
