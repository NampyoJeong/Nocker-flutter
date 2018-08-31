import 'dart:convert';

import 'package:eos_node_checker/data/model/Action.dart';
import 'package:eos_node_checker/data/remote/HttpService.dart';
import 'package:rxdart/rxdart.dart';

class DetailPresenter {
  final String title;
  final service = HttpService();
  final actions = <Action>[];

  final subject = BehaviorSubject<List<Action>>();

  DetailPresenter(this.title);

  void getActions() {
    int seq = actions.isNotEmpty ? actions.last.accountSeq : 0;
    service.getActions(title, lastSeq: seq)
        .then((response) => json.decode(utf8.decode(response.bodyBytes)))
        .then((body) {
          List actions = body['actions'];
          return actions.map((act) => Action(act));
        })
        .then((list) {
          actions.addAll(list);
          actions.sort((a, b) => b.accountSeq.compareTo(a.accountSeq));
          subject.add(actions);
        })
        .catchError((error) { print(error); });
  }
}