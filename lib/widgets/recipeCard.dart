import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String thumbnailUrl;
  final String isAlcoholic;
  final String category;
  final VoidCallback onTap;
  final String? videoUrl;

  const RecipeCard({
    Key? key,
    required this.title,
    required this.thumbnailUrl,
    required this.isAlcoholic,
    required this.category,
    required this.onTap,
    this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            alignment: Alignment.bottomCenter,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.multiply,
            ),
            image: NetworkImage(thumbnailUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        if (isAlcoholic == "Alcoholic")
                          const Icon(
                            Icons.local_fire_department_rounded,
                            color: Colors.redAccent,
                            size: 20,
                          )
                        else
                          const Icon(
                            Icons.no_drinks_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        const SizedBox(width: 5),
                        Text(
                          isAlcoholic,
                          style: TextStyle(
                              color: isAlcoholic == "Alcoholic"
                                  ? Colors.redAccent
                                  : Colors.white),
                        ),
                        const SizedBox(width: 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (videoUrl != null)
              Align(
                alignment: Alignment.topLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.video_collection_rounded,
                            color: Colors.white,
                            size: 25,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
