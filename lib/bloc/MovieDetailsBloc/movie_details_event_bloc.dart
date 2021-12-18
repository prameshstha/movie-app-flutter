abstract class MovieDetailsEvent {}

class GetMoviesDetails extends MovieDetailsEvent {
  final int movieId;

  GetMoviesDetails(this.movieId);
}
