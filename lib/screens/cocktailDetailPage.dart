import 'package:flutter/material.dart';
import 'package:recipe_app/widgets/cocktailRecipeBlock.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:developer';
import 'package:flutter/services.dart';

class CocktailDetailPage extends StatefulWidget {
  const CocktailDetailPage({
    Key? key,
    required this.title,
    required this.image,
    required this.instructions,
    required this.category,
    required this.isAlcoholic,
    required this.glassType,
    required this.recipe,
    this.videoUrl,
  }) : super(key: key);
  final String title;
  final String image;
  final String instructions;
  final String category;
  final String isAlcoholic;
  final String glassType;
  final List<List<String?>> recipe;
  final String? videoUrl;

  @override
  State<CocktailDetailPage> createState() => _CocktailDetailPageState();
}

class _CocktailDetailPageState extends State<CocktailDetailPage> {
  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  final List<String> _ids = [
    'nPt8bK2gbaU',
    'gQDByCdjUXw',
    'iLnmTe5Q2Qw',
    '_WoCV4c6XOE',
    'KmzdUe0RSJo',
    '6jZDSSZZxjQ',
    'p2lYr3vM_1w',
    '7QUtEmBT_-w',
    '34_PXCzGw1M',
  ];

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoUrl ?? "",
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        progressColors: const ProgressBarColors(
            backgroundColor: Colors.white,
            playedColor: Colors.red,
            handleColor: Colors.red),
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) => Scaffold(
        floatingActionButton: widget.videoUrl != null
            ? FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              )
            : null,
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                leadingWidth: 90,
                leading: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black,
                        ),
                        Text(
                          "Back",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
                expandedHeight: MediaQuery.of(context).size.height / 2 + 100,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  titlePadding: EdgeInsets.zero,
                  title: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    double top = constraints.biggest.height;
                    return AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: top == 80 ? 17 : 7, horizontal: 12),
                        width: double.infinity,
                        color: Colors.white.withOpacity(0.55),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.title,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                            top !=
                                    MediaQuery.of(context).size.height / 2 +
                                        100 +
                                        MediaQuery.of(context).padding.top
                                ? Container()
                                : Column(
                                    children: [
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                widget.isAlcoholic ==
                                                        "Alcoholic"
                                                    ? Icons
                                                        .local_fire_department_rounded
                                                    : Icons.no_drinks_outlined,
                                                color: Colors.black,
                                                size: 10,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                widget.isAlcoholic,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 7),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.wine_bar_rounded,
                                                color: Colors.black,
                                                size: 10,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                widget.glassType,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 7),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.filter_list,
                                                color: Colors.black,
                                                size: 10,
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                widget.category,
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    );
                  }),
                  background: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.multiply,
                    color: Colors.black.withOpacity(0.35),
                  ),
                ),
                floating: true,
                snap: true,
                pinned: true,
              )
            ];
          },
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
            children: [
              Text(widget.instructions),
              const Text("Ingredients"),
              ...widget.recipe
                  .map((block) => CocktailRecipeBlock(block: block))
                  .toList(),
              if (widget.videoUrl != null) ...[
                const SizedBox(height: 10),
                player
              ]
            ],
          ),
        ),
      ),
    );
  }
}
