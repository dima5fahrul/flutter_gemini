// To parse this JSON data, do
//
//     final geminiModel = geminiModelFromJson(jsonString);

import 'dart:convert';

GeminiModel geminiModelFromJson(String str) =>
    GeminiModel.fromJson(json.decode(str));

String geminiModelToJson(GeminiModel data) => json.encode(data.toJson());

class GeminiModel {
  List<Candidate> candidates;
  PromptFeedback promptFeedback;

  GeminiModel({
    required this.candidates,
    required this.promptFeedback,
  });

  factory GeminiModel.fromJson(Map<String, dynamic> json) => GeminiModel(
        candidates: List<Candidate>.from(
            json["candidates"].map((x) => Candidate.fromJson(x))),
        promptFeedback: PromptFeedback.fromJson(json["promptFeedback"]),
      );

  Map<String, dynamic> toJson() => {
        "candidates": List<dynamic>.from(candidates.map((x) => x.toJson())),
        "promptFeedback": promptFeedback.toJson(),
      };
}

class Candidate {
  Content content;
  String finishReason;
  int index;
  List<SafetyRating> safetyRatings;

  Candidate({
    required this.content,
    required this.finishReason,
    required this.index,
    required this.safetyRatings,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) => Candidate(
        content: Content.fromJson(json["content"]),
        finishReason: json["finishReason"],
        index: json["index"],
        safetyRatings: List<SafetyRating>.from(
            json["safetyRatings"].map((x) => SafetyRating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "content": content.toJson(),
        "finishReason": finishReason,
        "index": index,
        "safetyRatings":
            List<dynamic>.from(safetyRatings.map((x) => x.toJson())),
      };
}

class Content {
  List<Part> parts;
  String role;

  Content({
    required this.parts,
    required this.role,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        parts: List<Part>.from(json["parts"].map((x) => Part.fromJson(x))),
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "parts": List<dynamic>.from(parts.map((x) => x.toJson())),
        "role": role,
      };
}

class Part {
  String text;

  Part({
    required this.text,
  });

  factory Part.fromJson(Map<String, dynamic> json) => Part(
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
      };
}

class SafetyRating {
  String category;
  String probability;

  SafetyRating({
    required this.category,
    required this.probability,
  });

  factory SafetyRating.fromJson(Map<String, dynamic> json) => SafetyRating(
        category: json["category"],
        probability: json["probability"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "probability": probability,
      };
}

class PromptFeedback {
  List<SafetyRating> safetyRatings;

  PromptFeedback({
    required this.safetyRatings,
  });

  factory PromptFeedback.fromJson(Map<String, dynamic> json) => PromptFeedback(
        safetyRatings: List<SafetyRating>.from(
            json["safetyRatings"].map((x) => SafetyRating.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "safetyRatings":
            List<dynamic>.from(safetyRatings.map((x) => x.toJson())),
      };
}
