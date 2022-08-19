import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:recipe_app/API/recipeApi.dart';
import 'package:recipe_app/models/recipe.dart';
import 'package:recipe_app/screens/cocktailDetailPage.dart';
import 'package:recipe_app/widgets/customAppBar.dart';
import 'package:recipe_app/widgets/recipeCard.dart';
import 'dart:developer' as dev;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Recipe>? _recipes;
  bool _isLoading = true;
  int _page = 97;
  bool _hasNextPage = true;
  bool _isFirstLoadRunning = false;
  bool _isLoadMoreRunning = false;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _controller = new ScrollController()..addListener(_loadMore);
  }

  _fetchData() async {
    _recipes = await RecipeApi.getRecipe(_page);
    setState(() {
      _isLoading = false;
    });
  }

  void _loadMore() async {
    if (_hasNextPage == true &&
        _isFirstLoadRunning == false &&
        _isLoadMoreRunning == false &&
        _controller.position.extentAfter < 300) {
      setState(() {
        _isLoadMoreRunning = true; // Display a progress indicator at the bottom
      });
      _page += 1; // Increase _page by 1
      try {
        var fetchedPosts = await RecipeApi.getRecipe(_page);
        // final List fetchedPosts = json.decode(res.body);
        // if (fetchedPosts.length > 0) {
        if (fetchedPosts != null) {
          setState(() {
            _recipes?.addAll(fetchedPosts);
          });
        } else if (_page < 122) {
          _page += 1;
        } else {
          // This means there is no more data
          // and therefore, we will not send another GET request
          setState(() {
            _hasNextPage = false;
          });
        }
      } catch (err) {
        dev.debugger();
        print('Something went wrong!');
      }

      setState(() {
        _isLoadMoreRunning = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Cocktail Recipes',
        icon: Icons.wine_bar_rounded,
        iconColor: Colors.red,
      ),
      body: _isLoading && (_recipes == null || _recipes!.isEmpty)
          ? const Center(child: CircularProgressIndicator(color: Colors.yellow))
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _controller,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 4 / 5,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: _recipes?.length,
                    itemBuilder: (BuildContext ctx, index) {
                      return RecipeCard(
                        title: _recipes![index].name,
                        thumbnailUrl: _recipes![index].images,
                        isAlcoholic: _recipes![index].isAlcoholic,
                        category: _recipes![index].category,
                        videoUrl: _recipes![index].videoUrl,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CocktailDetailPage(
                              title: _recipes![index].name,
                              image: _recipes![index].images,
                              instructions: _recipes![index].instructions,
                              category: _recipes![index].category,
                              isAlcoholic: _recipes![index].isAlcoholic,
                              glassType: _recipes![index].glassType,
                              recipe: _recipes![index].ingredients,
                              videoUrl: _recipes![index].videoUrl,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (_isLoadMoreRunning == true)
                  const Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 40),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // When nothing else to load
                if (_hasNextPage == false)
                  Container(
                    padding: const EdgeInsets.only(top: 30, bottom: 40),
                    color: Colors.amber,
                    child: const Center(
                      child: Text('You have fetched all of the content'),
                    ),
                  ),
              ],
            ),
    );
  }
}
