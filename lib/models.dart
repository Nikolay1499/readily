class Responses{
  List<TextAnnotations> responses;

  Responses({this.responses});

  factory Responses.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['responses'] as List;
    List<TextAnnotations> responses = list.map((i) => TextAnnotations.fromJson(i)).toList();


    return Responses(responses: responses);
  }
}

class TextAnnotations{// add others
  List<Description> textAnnotations;

  TextAnnotations({this.textAnnotations});

  factory TextAnnotations.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['textAnnotations'] as List;
    List<Description> textAnnotations = list.map((i) => Description.fromJson(i)).toList();


    return TextAnnotations(
        textAnnotations: textAnnotations
    );
  }
}

class Description{
  String description;

  Description({this.description});

  factory Description.fromJson(Map<String, dynamic> parsedJson){
    return Description(
        description : parsedJson['description'],
    );
  }

}