import 'package:flutter/material.dart';

class CocktailRecipeBlock extends StatefulWidget {
  const CocktailRecipeBlock({Key? key, required this.block}) : super(key: key);
  final List<String?> block;

  @override
  State<CocktailRecipeBlock> createState() => _CocktailRecipeBlockState();
}

class _CocktailRecipeBlockState extends State<CocktailRecipeBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.55),
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.add),
              const SizedBox(width: 5),
              Text(widget.block[0] ?? ""),
            ],
          ),
          Text(widget.block[1] ?? "")
        ],
      ),
    );
  }
}
