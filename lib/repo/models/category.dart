import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum CategoryType {
  food,
  transport,
  shopping,
  entertainment,
  bills,
  other,
}

extension CategoryIcon on CategoryType {
  String get name {
    switch (this) {
      case CategoryType.food:
        return 'Food';
      case CategoryType.transport:
        return "Transport";
      case CategoryType.shopping:
        return 'Shopping';
      case CategoryType.entertainment:
        return 'Entertainment';
      case CategoryType.bills:
        return "Bills";
      case CategoryType.other:
        return 'Others';
    }
  }

  IconData get icon {
    switch (this) {
      case CategoryType.food:
        return Icons.fastfood;
      case CategoryType.transport:
        return Icons.bus_alert;
      case CategoryType.shopping:
        return Icons.shopping_cart;
      case CategoryType.entertainment:
        return Icons.movie;
      case CategoryType.bills:
        return Icons.receipt;
      case CategoryType.other:
        return Icons.category;
    }
  }
}
