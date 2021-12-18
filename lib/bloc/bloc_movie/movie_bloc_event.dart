abstract class MovieEvent {}

class GetMovies extends MovieEvent {
  final int genreId;

  GetMovies(this.genreId);
}
