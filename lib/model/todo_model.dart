import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Model
class Todo {
  String id;
  String title;
  bool isCompleted;
  bool isFavourite;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.isFavourite = false,
  });
}