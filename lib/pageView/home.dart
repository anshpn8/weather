import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utils/constValue.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../utils/data_model/citySearchModel.dart';
import '../utils/data_model/newsarticle.dart';
import '../utils/data_model/weatherboards.dart';
import '../utils/services/newsService.dart';
import '../utils/services/service.dart';
import '../utils/services/weatherService.dart';
import '../widgets/weatherUI.dart';
import 'loacationspage.dart';

class MyHomePage extends StatefulWidget {
    const MyHomePage({super.key, required this.title});
    final String title;

    @override
    State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    final int _virtualStart = 500000;

    final PageController _pageController =
        PageController(initialPage: 500000);

    final NewsService newsService = NewsService();
    final RefreshController refreshController = RefreshController();
    List<NewsArticle> newsArticles = [];
    bool loading = true;

    int _currentIndex = 0;
    @override
    void initState() {
        super.initState();
        Future.microtask(() {
                fetchNews();
        });
    }

    Future<void> fetchNews() async {
        setState(() {
                loading = true;
            });
        try {
            final newsArticleFetch = await newsService.fetchLatestNews();
            loading = false;
            setState(() {
                    loading = false;
                    newsArticles = newsArticleFetch;
                    if (ConstValue.debug) {
                        print(newsArticles[0].uContent);
                    }
                });
        }
        catch (error) {
            if (ConstValue.debug) print("Error fetching news: $error");
        }
    }

    Future<void> refreshWeather(RefreshController rc) async {

      final weatherProvider = context.read<WeatherProvider>();
      await weatherProvider.fetchWeatherDataForCities();

      rc.refreshCompleted();
    }

    void _animateToPage(int page, double velocity) {
      int duration = (400 - velocity.abs()).clamp(150, 600).toInt();

      // Use context.read to get the current list for iteration
      final choosenCity = context.read<CityProvider>().choosenCity;
      // for (final city in choosenCity) {
      //   print(city.name);
      // }

      _pageController.animateToPage(
        page,
        duration: Duration(milliseconds: duration),
        curve: Curves.easeOut,
      );
    }

    @override
    Widget build(BuildContext context) {
      final choosenCity = context.watch<CityProvider>().choosenCity;

      // WATCH the WeatherProvider for the *actual* data we render
      final weatherProvider = context.watch<WeatherProvider>();
      final weatherDataList = weatherProvider.weatherDataList;
      final isLoadingWeather = weatherProvider.isLoading;

      if (_currentIndex >= choosenCity.length) {
        _currentIndex = 0;
      }

      if (isLoadingWeather) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }


        return Scaffold(
            backgroundColor: Color.fromARGB(194, 251, 216, 171),
            body: Stack(
                children: [
                    Stack(
                        children: [
                            Column(
                                children: [
                                    Expanded(
                                        child: Image.asset("assets/image/backPixel.png", // Replace with your image path
                                            fit: BoxFit.cover,
                                            alignment: Alignment.topCenter,
                                        ),
                                    ),
                                ],
                            ),
                        ],
                    ),

                    Stack(
                        children: [
                            GestureDetector(
                                onPanEnd: (details) {
                                    double velocity = details.velocity.pixelsPerSecond.dx;
                                    int currentIndex = _pageController.page!.round();

                                    if (velocity < -200) {
                                        _animateToPage(currentIndex + 1, velocity);
                                    } else if (velocity > 200) {

                                        _animateToPage(currentIndex - 1, velocity);
                                    }
                                },
                                child: Consumer<WeatherProvider>(
                                    builder: (context, weatherProvider, child) {
                                        if (weatherProvider.isLoading) {
                                            return Center(child: CircularProgressIndicator());
                                        }

                                        if (weatherProvider.weatherDataList.isEmpty) {
                                            return Center(child: Column(
                                              spacing: 20,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text('No weather data found. Add a city!'),
                                                ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.blue,
                                                      elevation: 5,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10),
                                                        side: BorderSide(color: Colors.blueAccent),
                                                      ),
                                                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                                    ),
                                                    onPressed: () {
                                                      showSearch(
                                                        context: context,
                                                        delegate: CustomSearchDelegate(),
                                                      );
                                                    },
                                                    child: Icon(Icons.add, color: Colors.white, size: 40,))
                                              ],
                                            ));
                                        }
                                        return PageView.builder(
                                            controller: _pageController,
                                            itemCount: 1000000,
                                            onPageChanged: (index) {
                                                setState(() {

                                                        int relativeIndex = (index - _virtualStart) % weatherDataList.length;
                                                        if (relativeIndex < 0) relativeIndex += weatherDataList.length;

                                                        if (relativeIndex < 0) relativeIndex += weatherDataList.length;
                                                        _currentIndex = relativeIndex;
                                                    });
                                            },
                                            itemBuilder: (context, index) {
                                                if (weatherDataList.isEmpty) return const SizedBox();

                                                int relativeIndex = (index - _virtualStart) % weatherDataList.length;
                                                if (relativeIndex < 0) relativeIndex += weatherDataList.length;

                                                if (relativeIndex < 0) relativeIndex += weatherDataList.length;

                                                return WeatherUI(
                                                    newsArticles: newsArticles,
                                                    refreshWeather: refreshWeather,
                                                    weatherData: weatherDataList[relativeIndex],
                                                );
                                            },
                                        );

                                    }
                                )
                            ),
                        ],
                    ),
                ],
            ),
            bottomNavigationBar: BottomAppBar(
              height: 60,
                elevation: 0,
                color: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationPage()))
                      ,
                      icon: const Icon(Icons.list_rounded, size: 25),
                    ),

                    Row(
                      children: List.generate(
                        weatherDataList.length,
                            (i) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: i == _currentIndex
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        showSearch(
                          context: context,
                          delegate: CustomSearchDelegate(),
                        );
                        // example
                      },
                      icon: const Icon(Icons.search_rounded, size: 25),
                    ),
                  ],
                ),
            ),
        );
    }
}

class CustomSearchDelegate extends SearchDelegate {
    List<CitySearchModel> apiResults = [];
    WeatherService weatherService = WeatherService();

    bool isLoading = false;
    bool hasSearched = false;

    CustomSearchDelegate();

    @override
    List<Widget> buildActions(BuildContext context) =>
    [IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear))];

    @override
    Widget buildLeading(BuildContext context) =>
    IconButton(onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios));

    @override
    Widget buildSuggestions(BuildContext context) {
        if (query.isEmpty) {
            return const Center(child: Text("Type to search cities"));
        }

        return FutureBuilder<List<CitySearchModel>>(
            future: weatherService.searchCities(query),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                    return const Center(child: Text("Error loading cities"));
                }

                final results = snapshot.data ?? [];

                if (results.isEmpty) {
                    return const Center(child: Text("No results"));
                }
                apiResults = results;
                List<CityUseData> cityList = apiResults.map((city) => CityUseData(name: city.name, region: city.region, country: city.country, lat: city.lat, lon: city.lon)).toList();
                return _buildList(cityList);
            },
        );
    }

    @override
    Widget buildResults(BuildContext context) {
        // final cityProvider = context.watch<CityProvider>();

        return FutureBuilder<List<CitySearchModel>>(
            future: weatherService.searchCities(query),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                }

                final results = snapshot.data ?? [];
                apiResults = results;
                List<CityUseData> cityList = apiResults.map((city) => CityUseData(name: city.name, region: city.region, country: city.country, lat: city.lat, lon: city.lon)).toList();
                if (results.isEmpty) {
                    return const Center(child: Text("No results"));
                }
                return _buildList(cityList);
            },
        );
    }

    Widget _buildList(List<CityUseData> list) {
        return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              final city = list[index];
              return GestureDetector(
                onTap: () {
                        context.read<CityProvider>().addCity(city);
                        context.read<CityProvider>().setIndex(index);
                        // context.read<WeatherProvider>().fetchWeatherDataForCities();
                        
                        AppsFlyerService().logEvent("CityAdded", {
                          "Description": "${city.name} added."
                        });
                        close(context, city);
                      },
                  child: Container(
                padding: EdgeInsets.all(15),
                margin: EdgeInsets.symmetric(vertical: 2.5,horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(
                            85, 85, 85, 0.5058823529411764),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ]
                ),
                child: Text("${city.name}, ${city.region}, ${city.country}"),
              ));
            },
        );
    }
}

