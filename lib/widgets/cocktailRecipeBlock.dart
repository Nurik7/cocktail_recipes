import 'package:flutter/material.dart';

class CocktailRecipeBlock extends StatefulWidget {
  const CocktailRecipeBlock({Key? key, required this.block}) : super(key: key);
  final List<String?> block;

  @override
  State<CocktailRecipeBlock> createState() => _CocktailRecipeBlockState();
}

class _CocktailRecipeBlockState extends State<CocktailRecipeBlock> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashColor: _isSelected ? Colors.redAccent : Colors.lightGreenAccent,
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white70,
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(235, 236, 244, 1),
                spreadRadius: 2,
                blurRadius: 2)
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  _isSelected ? Icons.check_rounded : Icons.add_rounded,
                  color: _isSelected ? Colors.green : Colors.black,
                ),
                const SizedBox(width: 5),
                Text(widget.block[0] ?? ""),
              ],
            ),
            Text(widget.block[1] ?? "")
          ],
        ),
      ),
    );
  }
}
