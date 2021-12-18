import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_api/Model/movie.dart';
import 'package:flutter_api/Model/person.dart';
import 'package:flutter_api/Screens/category_screen.dart';
import 'package:flutter_api/Screens/movie_details_screen.dart';
import 'package:flutter_api/bloc/Person_bloc/person_bloc.dart';
import 'package:flutter_api/bloc/Person_bloc/person_bloc_event.dart';
import 'package:flutter_api/bloc/bloc_movie/movie_bloc.dart';

import 'package:flutter_api/Service/api_service.dart';
import 'package:flutter_api/bloc/bloc_movie/movie_bloc_event.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final movieBloc = MovieBloc();
  final personBloc = PersonBloc();

  final String apiKey = 'b105fd2105b38ae32e9df54f88014765';
  final String imagePath = 'https://image.tmdb.org/t/p/original';
  final readAccessToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMTA1ZmQyMTA1YjM4YWUzMmU5ZGY1NGY4ODAxNDc2NSIsInN1YiI6IjYxYTg2MThiMjQ5NWFiMDAyYTBlY2EzOCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.HdZm11qeZu8FmLO9gA2xtzGn8LLDb6aGQzMvHKl8Mxs';
  ApiService _apiService = ApiService();
  @override
  void initState() {
    movieBloc.eventSink.add(GetMovies(0));
    personBloc.eventSink.add(GetPerson());
    super.initState();
  }

  @override
  void dispose() {
    movieBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(
          Icons.menu,
          color: Colors.black45,
        ),
        title: Text(
          'Movies-db'.toUpperCase(),
          style: Theme.of(context).textTheme.caption!.copyWith(
              color: Colors.black45,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'muli'),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 15),
            child: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
          )
        ],
      ),
      body: _buildBody(context, size),
    );
  }

  Widget _buildBody(BuildContext context, Size size) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: movieBloc.movieStream,
                  builder: (context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator()
                          // child: Platform.isAndroid?CircularProgressIndicator():CupertinoActivityIndicator(),
                          );
                    } else if (snapshot.hasData) {
                      var movies = snapshot.data;

                      return Column(
                        children: [
                          CarouselSlider.builder(
                            itemCount: movies!.length,
                            itemBuilder: (BuildContext context, int index, _) {
                              Movie movie = movies[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MovieDetailsScreen(
                                                  movie: movie)));
                                },
                                child: Stack(
                                  alignment: Alignment.bottomLeft,
                                  children: [
                                    ClipRRect(
                                      child: CachedNetworkImage(
                                          imageUrl:
                                              '$imagePath/${movie.backdropPath}',
                                          height: size.height * 0.3,
                                          width: size.width,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/img_not_found.jpg'),
                                                  ),
                                                ),
                                              )),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 15,
                                        left: 15,
                                      ),
                                      child: Text(
                                        movie.title.toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            fontFamily: 'muli'),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                            options: CarouselOptions(
                                enableInfiniteScroll: true,
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 3),
                                autoPlayAnimationDuration:
                                    const Duration(microseconds: 500),
                                pauseAutoPlayOnTouch: true,
                                viewportFraction: 0.8,
                                enlargeCenterPage: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                const BuildWidgetCategory(),
                                Text(
                                  'Trending persons on this week'.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45,
                                      fontFamily: 'muli'),
                                ),
                                SizedBox(
                                  height: size.height * 0.0001,
                                ),
                                Column(
                                  children: [
                                    StreamBuilder(
                                        stream: personBloc.personStream,
                                        builder: (context,
                                            AsyncSnapshot<List> snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.hasData) {
                                            var personList = snapshot.data;
                                            return Container(
                                              height: 110,
                                              child: ListView.separated(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: personList!.length,
                                                separatorBuilder:
                                                    (context, index) =>
                                                        const VerticalDivider(
                                                  color: Colors.transparent,
                                                  width: 5,
                                                ),
                                                itemBuilder: (context, index) {
                                                  Person persons =
                                                      personList[index];
                                                  return Container(
                                                    child: Column(
                                                      children: [
                                                        Card(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          100)),
                                                          elevation: 3,
                                                          child: ClipRRect(
                                                              child:
                                                                  CachedNetworkImage(
                                                            imageUrl:
                                                                '$imagePath/${persons.profilePath}',
                                                            imageBuilder: (context,
                                                                imageProvider) {
                                                              return Container(
                                                                width: 80,
                                                                height: 80,
                                                                decoration:
                                                                    BoxDecoration(
                                                                        borderRadius:
                                                                            const BorderRadius.all(Radius.circular(
                                                                                100)),
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              imageProvider,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        )),
                                                              );
                                                            },
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Container(
                                                              width: 80,
                                                              height: 80,
                                                              child:
                                                                  const Center(
                                                                child:
                                                                    CircularProgressIndicator(),
                                                              ),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Container(
                                                              width: 80,
                                                              height: 80,
                                                              decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              100)),
                                                                  image: DecorationImage(
                                                                      image: AssetImage(
                                                                          'assets/images/img_not_found.jpg'),
                                                                      fit: BoxFit
                                                                          .cover)),
                                                            ),
                                                          )),
                                                        ),
                                                        Container(
                                                          child: Center(
                                                            child: Text(
                                                              persons.name
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                fontSize: 8,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'muli',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Center(
                                                            child: Text(
                                                              persons
                                                                  .knowForDepartment
                                                                  .toUpperCase(),
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                fontSize: 8,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily:
                                                                    'muli',
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              child: const Text(
                                                  'Something went wrong!!!'),
                                            );
                                          }
                                        })
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return Container(
                        child: const Text('Something went wrong!!!'),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
