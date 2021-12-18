import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/Model/cast_list.dart';
import 'package:flutter_api/Model/movie.dart';
import 'package:flutter_api/Model/movie_detail.dart';
import 'package:flutter_api/Model/screen_shot.dart';
import 'package:flutter_api/bloc/MovieDetailsBloc/movie_details_bloc.dart';
import 'package:flutter_api/bloc/MovieDetailsBloc/movie_details_event_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  final movieDetailBloc = MovieDetailsBloc();
  @override
  void initState() {
    movieDetailBloc.eventSink.add(GetMoviesDetails(widget.movie.id));
    super.initState();
  }

  @override
  void dispose() {
    movieDetailBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: _buildMovieDetailBody(context, size),
    );
  }

  Widget _buildMovieDetailBody(BuildContext context, Size size) {
    const String imagePath = 'https://image.tmdb.org/t/p/original';
    return StreamBuilder(
        stream: movieDetailBloc.movieDetailsStream,
        builder: (context, AsyncSnapshot<MovieDetail> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            var movieDetails = snapshot.data;

            return Stack(
              children: [
                ClipPath(
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: '$imagePath/${movieDetails!.backdropPath}',
                      height: size.height * 0.45,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage('assets/images/img_not_found.jpg'),
                          ),
                        ),
                      ),
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30)),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: GestureDetector(
                        onTap: () async {
                          final youtubeUrl =
                              'https://www.youtube.com/watch?v=${movieDetails.trailerId}';

                          if (await canLaunch(youtubeUrl)) {
                            await launch(youtubeUrl);
                          }
                        },
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.play_circle_outline,
                                color: Colors.yellow,
                                size: 65,
                              ),
                              Text(
                                movieDetails.title.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'muli',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'OVERVIEW',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Container(
                            height: size.height * 0.05,
                            child: Text(
                              movieDetails.overview,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontFamily: 'muli'),
                            ),
                          ),
                          SizedBox(height: size.height * 0.005),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'RELEASE DATE',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'muli',
                                        ),
                                  ),
                                  Text(movieDetails.releaseDate,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              color: Colors.yellow[800],
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'muli',
                                              fontSize: 12))
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'RUN TIME',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'muli',
                                        ),
                                  ),
                                  Text('${movieDetails.runtime} mins',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              color: Colors.yellow[800],
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'muli',
                                              fontSize: 12))
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BUDGET',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'muli',
                                        ),
                                  ),
                                  Text(movieDetails.budget,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2!
                                          .copyWith(
                                              color: Colors.yellow[800],
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'muli',
                                              fontSize: 12))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text('SCREENSHOTS',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'muli',
                                      fontSize: 12)),
                          Container(
                            height: 155,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  movieDetails.movieImage!.backdrops.length,
                              separatorBuilder: (context, index) =>
                                  const VerticalDivider(
                                color: Colors.transparent,
                                width: 5,
                              ),
                              itemBuilder: (context, index) {
                                Screenshot image =
                                    movieDetails.movieImage!.backdrops[index];
                                return Container(
                                  child: Card(
                                    elevation: 3,
                                    borderOnForeground: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        imageUrl:
                                            '$imagePath/${image.imagePath}',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text('CASTS',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'muli',
                                      fontSize: 12)),
                          Container(
                            height: size.height * 0.15,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: movieDetails.castList!.length,
                              separatorBuilder: (context, index) =>
                                  const VerticalDivider(
                                color: Colors.transparent,
                                width: 5,
                              ),
                              itemBuilder: (context, index) {
                                Cast cast = movieDetails.castList![index];
                                return Container(
                                  child: Column(
                                    children: [
                                      Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        elevation: 3,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                '$imagePath/${cast.profilePath}',
                                            imageBuilder:
                                                (context, imageBuilder) {
                                              return Container(
                                                  width: 80,
                                                  height: 80,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                                  .all(
                                                              Radius.circular(
                                                                  100)),
                                                      image: DecorationImage(
                                                          image: imageBuilder,
                                                          fit: BoxFit.cover)));
                                            },
                                            placeholder: (context, url) =>
                                                Container(
                                              width: 80,
                                              height: 80,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                              width: 80,
                                              height: 80,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(100)),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/img_not_found.jpg'))),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            cast.name.toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 8,
                                                fontFamily: 'muli',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Center(
                                          child: Text(
                                            cast.character.toUpperCase(),
                                            style: const TextStyle(
                                                color: Colors.black45,
                                                fontSize: 8,
                                                fontFamily: 'muli',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            );
          } else {
            return Container(
              child: const Text('Something went wrong!!!'),
            );
          }
        });
  }
}
