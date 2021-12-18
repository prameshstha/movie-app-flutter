import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_api/Model/genre.dart';
import 'package:flutter_api/Model/movie.dart';
import 'package:flutter_api/Screens/movie_details_screen.dart';
import 'package:flutter_api/bloc/bloc_movie/movie_bloc_event.dart';
import 'package:flutter_api/bloc/genre_bloc.dart';
import 'package:flutter_api/bloc/bloc_movie/movie_bloc.dart';

class BuildWidgetCategory extends StatefulWidget {
  final int selectedGenre;
  const BuildWidgetCategory({Key? key, this.selectedGenre = 28})
      : super(key: key);

  @override
  _BuildWidgetCategoryState createState() => _BuildWidgetCategoryState();
}

class _BuildWidgetCategoryState extends State<BuildWidgetCategory> {
  int selectedGenre = 0;
  final genreBloc = GenreBloc();
  final movieBloc = MovieBloc();
  final String imagePath = 'https://image.tmdb.org/t/p/original';

  @override
  void initState() {
    super.initState();
    selectedGenre = widget.selectedGenre;
    genreBloc.eventSink.add(GenreControlAction.fetch);
    movieBloc.eventSink.add(GetMovies(selectedGenre));
  }

  @override
  void dispose() {
    genreBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: _buildGenre(context, size),
    );
  }

  Widget _buildGenre(BuildContext context, Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StreamBuilder(
            stream: genreBloc.genreStream,
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Container(child: Text('${snapshot.error}'));
              } else {
                return Container(
                  height: size.height * 0.05,
                  child: ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (
                      BuildContext context,
                      int index,
                    ) =>
                        VerticalDivider(
                      color: Colors.transparent,
                      width: size.width * 0.01,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Genre genre = snapshot.data![index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                // Genre genre = snapshot.data![index];
                                selectedGenre = genre.id;
                                movieBloc.eventSink
                                    .add(GetMovies(selectedGenre));
                                // movieBloc.getMovieGenre(selectedGenre).listen;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black45),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(25),
                                ),
                                color: (genre.id == selectedGenre
                                    ? Colors.black45
                                    : Colors.white),
                              ),
                              child: Text(
                                genre.name.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: (genre.id == selectedGenre
                                        ? Colors.white
                                        : Colors.black45),
                                    fontFamily: 'muli'),
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              }
            }),
        SizedBox(
          height: size.height * 0.00,
        ),
        Container(
          child: Text(
            'Now playing'.toUpperCase(),
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black45,
                fontFamily: 'muli'),
          ),
        ),
        SizedBox(
          height: size.height * 0.005,
        ),
        StreamBuilder(
            stream: movieBloc.movieStream,
            builder: (context, AsyncSnapshot<List> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData) {
                var moviesByGenre = snapshot.data;
                return Container(
                  height: size.height * .30,
                  child: ListView.separated(
                    itemCount: moviesByGenre!.length,
                    separatorBuilder: (context, index) => VerticalDivider(
                      color: Colors.transparent,
                      width: size.width * 0.015,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Movie movie = moviesByGenre[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            child: CachedNetworkImage(
                                imageUrl: '$imagePath/${movie.backdropPath}',
                                imageBuilder: (context, imageProvider) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MovieDetailsScreen(
                                                      movie: movie)));
                                    },
                                    child: Container(
                                        width: size.width * 0.45,
                                        height: size.height * 0.25,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ))),
                                  );
                                },
                                placeholder: (context, url) => Container(
                                      width: size.width * 0.45,
                                      height: size.height * 0.25,
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/img_not_found.jpg')),
                                      ),
                                    )),
                          ),
                          SizedBox(
                            height: size.height * 0.005,
                          ),
                          Container(
                            width: 180,
                            child: Text(
                              movie.title.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black45,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'muli',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 14,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 14,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 14,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 14,
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 14,
                                ),
                                Text(
                                  movie.voteAverage,
                                  style: const TextStyle(color: Colors.black45),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                );
              } else {
                return Container(
                  child: const Text('Something went wrong!!!'),
                );
              }
            }),
      ],
    );
  }
}
