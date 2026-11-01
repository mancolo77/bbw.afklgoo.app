import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RuleTopic {
  final String id;
  final String sport; // Football, Basketball, Volleyball, Tennis
  final String title;
  final String category; // 'Objective', 'Players', 'Court / Pitch', 'Scoring', 'Key Terms'
  final String content;
  final String terms;

  const RuleTopic({
    required this.id,
    required this.sport,
    required this.title,
    required this.category,
    required this.content,
    required this.terms,
  });
}

class RuleQuestion {
  final String id;
  final String sport;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const RuleQuestion({
    required this.id,
    required this.sport,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class SportsRulesService with ChangeNotifier {
  static final SportsRulesService _instance = SportsRulesService._internal();
  factory SportsRulesService() => _instance;
  SportsRulesService._internal();

  final Set<String> _studiedTopicIds = {};
  final Set<String> _savedTopicIds = {};
  final Map<String, int> _bestTestScores = {}; // sport -> best score out of 5

  Set<String> get studiedTopicIds => Set.unmodifiable(_studiedTopicIds);
  Set<String> get savedTopicIds => Set.unmodifiable(_savedTopicIds);
  Map<String, int> get bestTestScores => Map.unmodifiable(_bestTestScores);

  final List<RuleTopic> topics = const [
    // Football
    RuleTopic(
      id: 'fb_1',
      sport: 'Football',
      title: 'Game Objective and Match Structure',
      category: 'Objective',
      content: 'The objective of football is to score by kicking or heading the ball into the opponent\'s goal more times than the opponent during a 90-minute match (two 45-minute halves). Outfield players cannot touch the ball with hands or arms.',
      terms: 'goal, half, referee whistle, football',
    ),
    RuleTopic(
      id: 'fb_2',
      sport: 'Football',
      title: 'Team Composition and Substitutions',
      category: 'Players',
      content: 'Each team fields 11 players (10 outfielders and 1 goalkeeper). Teams are allowed up to 5 substitutions across 3 substitution windows. The goalkeeper is the only player permitted to handle the ball inside their penalty box.',
      terms: 'goalkeeper, goalie, substitution, squad',
    ),
    RuleTopic(
      id: 'fb_3',
      sport: 'Football',
      title: 'Pitch Dimensions and Boundary Lines',
      category: 'Court / Pitch',
      content: 'Standard pitch length ranges between 100-110 meters, and width between 64-75 meters. The field is divided by a halfway line with a center circle radius of 9.15 meters. The penalty area extends 16.5 meters out from each goal line.',
      terms: 'pitch, turf, penalty box, 11 meters',
    ),
    RuleTopic(
      id: 'fb_4',
      sport: 'Football',
      title: 'Scoring and Tournament Standings',
      category: 'Scoring',
      content: 'Each goal scored awards 1 point on the match scoreboard. In league competitions, a win yields 3 points, a draw awards 1 point, and a loss gives 0. Knockout matches tied at full time go to two 15-minute extra-time periods and penalty shootouts.',
      terms: 'points, penalty shootout, extra time, victory',
    ),
    RuleTopic(
      id: 'fb_5',
      sport: 'Football',
      title: 'Key Terms: Offside, Fouls, VAR',
      category: 'Key Terms',
      content: 'An attacking player is in an offside position if they are nearer to the opponent\'s goal line than both the ball and the second-last opponent when the ball is played to them. VAR (Video Assistant Referee) assists the match referee in reviewable game incidents.',
      terms: 'offside, foul, yellow card, red card, var',
    ),

    // Basketball
    RuleTopic(
      id: 'bb_1',
      sport: 'Basketball',
      title: 'Objective and Quarter Structure',
      category: 'Objective',
      content: 'The objective is to throw the basketball into the opponent\'s elevated basket while defending one\'s own. Games consist of 4 quarters of 10 minutes (FIBA) or 12 minutes (NBA). Overtime periods of 5 minutes decide ties.',
      terms: 'basket, hoop, quarter, shot clock, buzzer',
    ),
    RuleTopic(
      id: 'bb_2',
      sport: 'Basketball',
      title: 'On-Court Positions and Lineup',
      category: 'Players',
      content: 'Teams field 5 active players on the court: point guard, shooting guard, small forward, power forward, and center. Teams have unlimited substitutions when the game clock is stopped.',
      terms: 'point guard, shooting guard, forward, center, bench',
    ),
    RuleTopic(
      id: 'bb_3',
      sport: 'Basketball',
      title: 'Court Dimensions and Hoop Height',
      category: 'Court / Pitch',
      content: 'Standard court dimensions are 28x15 meters. The rim is fixed at exactly 3.05 meters (10 feet) above the floor on a backboard measuring 1.8x1.05 meters. The 3-point line arc is 6.75 meters from the basket in FIBA.',
      terms: 'backboard, arc, key, free-throw line',
    ),
    RuleTopic(
      id: 'bb_4',
      sport: 'Basketball',
      title: 'Scoring Rules: Free Throws and 3-Pointers',
      category: 'Scoring',
      content: 'Free throws earn 1 point each, field goals scored inside the 3-point arc award 2 points, and shots beyond the arc yield 3 points. Ties do not exist in basketball; 5-minute overtime periods are played until a winner emerges.',
      terms: 'three-pointer, dunk, layup, free throw',
    ),
    RuleTopic(
      id: 'bb_5',
      sport: 'Basketball',
      title: 'Key Terms: Traveling, Shot Clock, Fouls',
      category: 'Key Terms',
      content: 'Traveling is the illegal movement of one or both feet beyond limits without dribbling. The attacking team has 24 seconds to attempt a shot, and 8 seconds to advance the ball past midcourt. A player fouls out after 5 personal fouls (FIBA).',
      terms: 'traveling, double dribble, 24 seconds, foul out',
    ),

    // Volleyball
    RuleTopic(
      id: 'vb_1',
      sport: 'Volleyball',
      title: 'Game Objective and 3-Touch Rule',
      category: 'Objective',
      content: 'The goal is to hit the ball over the net and land it in the opponent\'s court, or force an opponent error. Teams are allowed a maximum of 3 consecutive contacts before sending the ball across the net.',
      terms: 'net, block, serve, rally, contacts',
    ),
    RuleTopic(
      id: 'vb_2',
      sport: 'Volleyball',
      title: 'Team Lineup and the Libero Position',
      category: 'Players',
      content: 'Teams play with 6 players on the court, rotating clockwise whenever they win back the service. The Libero is a defensive specialist wearing a contrasting jersey who plays back-row defense without attacking above the net.',
      terms: 'libero, setter, outside hitter, opposite',
    ),
    RuleTopic(
      id: 'vb_3',
      sport: 'Volleyball',
      title: 'Court Dimensions and Net Heights',
      category: 'Court / Pitch',
      content: 'The court measures 18x9 meters divided into two 9x9 meter squares. The net is 2.43 meters high for men and 2.24 meters for women. The 3-meter attack line separates the front row from back-row players.',
      terms: 'net, antennas, attack line, 3 meters',
    ),
    RuleTopic(
      id: 'vb_4',
      sport: 'Volleyball',
      title: 'Set Format and 25-Point Rally Scoring',
      category: 'Scoring',
      content: 'Matches are played best-of-5 sets. Sets 1 through 4 are played to 25 points with a mandatory 2-point lead. If a fifth deciding set is needed (tie-break), it is played to 15 points with a 2-point margin.',
      terms: 'set, match point, tiebreak, deuce',
    ),
    RuleTopic(
      id: 'vb_5',
      sport: 'Volleyball',
      title: 'Key Terms: Ace, Pipe, Block, Spike',
      category: 'Key Terms',
      content: 'An Ace is a direct serve that lands untouched in bounds. A Pipe is a quick attack from zone 6 behind the 3-meter line. A Block is the action of deflecting the ball near the net above the opponent\'s attack.',
      terms: 'ace, pipe, block, spike, dig',
    ),

    // Tennis
    RuleTopic(
      id: 'tn_1',
      sport: 'Tennis',
      title: 'Objective and Ball Rally Mechanics',
      category: 'Objective',
      content: 'The objective is to hit the ball with a racket over the net into the opponent\'s court in such a way that the opponent cannot return it legally before the second bounce.',
      terms: 'racket, court, game, set, bounce',
    ),
    RuleTopic(
      id: 'tn_2',
      sport: 'Tennis',
      title: 'Singles and Doubles Format',
      category: 'Players',
      content: 'Singles is played 1-on-1, while doubles is played 2-on-2 with wider tramlines in play. Players alternate serving each game and switch sides of the court on every odd total game in a set.',
      terms: 'singles, doubles, server, receiver',
    ),
    RuleTopic(
      id: 'tn_3',
      sport: 'Tennis',
      title: 'Court Surfaces and Net Specifications',
      category: 'Court / Pitch',
      content: 'A regulation court is 23.77 meters long, 8.23 meters wide for singles, and 10.97 meters for doubles. Center net height is 0.914 meters. Major surfaces include Hard courts, Clay (slow, sliding), and Grass (fast, low bounce).',
      terms: 'hard, clay, grass, baseline',
    ),
    RuleTopic(
      id: 'tn_4',
      sport: 'Tennis',
      title: 'Scoring System: 15, 30, 40 and Deuce',
      category: 'Scoring',
      content: 'Points in a game progress: 0 (Love), 15, 30, 40, and Game. At 40-40, the score is Deuce; a player must win two consecutive points (Advantage, then Game) to claim the game. The first to 6 games wins the set.',
      terms: 'deuce, advantage, break point, match point',
    ),
    RuleTopic(
      id: 'tn_5',
      sport: 'Tennis',
      title: 'Key Terms: Break, Tiebreak, Smash, Drop Shot',
      category: 'Key Terms',
      content: 'A Break is winning a game on the opponent\'s serve. A Tiebreak is played at 6-6 in games up to 7 points with a 2-point cushion. An overhead Smash is a powerful downward shot against a high lob.',
      terms: 'break, tiebreak, smash, drop shot, lob',
    ),
  ];

  final Map<String, List<RuleQuestion>> questionsBySport = const {
    'Football': [
      RuleQuestion(
        id: 'q_fb_1',
        sport: 'Football',
        question: 'How many players start on the pitch for one team in a football match?',
        options: ['10 outfielders and 1 goalkeeper', '11 outfielders and 1 goalkeeper', '9 outfielders and 1 goalkeeper', '10 outfielders and 2 goalkeepers'],
        correctIndex: 0,
        explanation: 'A regulation football squad consists of exactly 11 players: 10 outfielders and 1 goalkeeper.',
      ),
      RuleQuestion(
        id: 'q_fb_2',
        sport: 'Football',
        question: 'At what distance from the goal line is the penalty spot located?',
        options: ['9.15 meters', '11 meters', '16.5 meters', '12 steps (7 m)'],
        correctIndex: 1,
        explanation: 'The penalty kick is taken from the penalty spot, located 11 meters (12 yards) from the goal line.',
      ),
      RuleQuestion(
        id: 'q_fb_3',
        sport: 'Football',
        question: 'What infraction is called if an attacker is closer to the goal than the ball and the second-last defender when passed to?',
        options: ['Last-man foul', 'Corner kick', 'Offside', 'Indirect free kick for delay'],
        correctIndex: 2,
        explanation: 'This is the standard definition of offside in IFAB / FIFA football rules.',
      ),
      RuleQuestion(
        id: 'q_fb_4',
        sport: 'Football',
        question: 'How many points does a team earn for a draw in a league table?',
        options: ['0 points', '1 point', '2 points', '3 points'],
        correctIndex: 1,
        explanation: 'Under the standard 3-point system, a win awards 3 points, a draw awards 1 point, and a loss awards 0.',
      ),
      RuleQuestion(
        id: 'q_fb_5',
        sport: 'Football',
        question: 'What is the maximum number of substitutions allowed in major official competitions?',
        options: ['3 substitutions', '5 substitutions across 3 windows', '6 substitutions with no limits', 'Unlimited substitutions'],
        correctIndex: 1,
        explanation: 'Modern football regulations permit up to 5 substitutions utilized across a maximum of 3 in-game stoppages.',
      ),
    ],
    'Basketball': [
      RuleQuestion(
        id: 'q_bb_1',
        sport: 'Basketball',
        question: 'What is the official regulation height of a basketball rim?',
        options: ['2.75 m', '3.00 m', '3.05 m', '3.20 m'],
        correctIndex: 2,
        explanation: 'The regulation hoop height is exactly 3.05 meters (10 feet) above the hardwood floor.',
      ),
      RuleQuestion(
        id: 'q_bb_2',
        sport: 'Basketball',
        question: 'How much time does the offensive team have on the shot clock to attempt a field goal?',
        options: ['14 seconds', '24 seconds', '30 seconds', '40 seconds'],
        correctIndex: 1,
        explanation: 'Under FIBA and NBA regulations, the offensive team has 24 seconds to attempt a shot that contacts the rim.',
      ),
      RuleQuestion(
        id: 'q_bb_3',
        sport: 'Basketball',
        question: 'How many points are awarded for a successful free throw?',
        options: ['1 point', '2 points', '3 points', 'Varies by quarter'],
        correctIndex: 0,
        explanation: 'Each successful free throw awarded from the foul line scores exactly 1 point.',
      ),
      RuleQuestion(
        id: 'q_bb_4',
        sport: 'Basketball',
        question: 'How many players per team are active on the court during play?',
        options: ['4 players', '5 players', '6 players', '7 players'],
        correctIndex: 1,
        explanation: 'Standard basketball is played 5-on-5 on the court.',
      ),
      RuleQuestion(
        id: 'q_bb_5',
        sport: 'Basketball',
        question: 'How many personal fouls disqualify a player under FIBA rules?',
        options: ['4 fouls', '5 personal fouls', '6 personal fouls', '7 personal fouls'],
        correctIndex: 1,
        explanation: 'In FIBA tournaments, a player fouls out after committing their 5th personal foul.',
      ),
    ],
    'Volleyball': [
      RuleQuestion(
        id: 'q_vb_1',
        sport: 'Volleyball',
        question: 'How many ball contacts is a team allowed before returning the ball over the net?',
        options: ['1 contact', '2 contacts', 'No more than 3 contacts', '4 contacts'],
        correctIndex: 2,
        explanation: 'A team has a maximum of 3 touches to return the ball (a block touch does not count as one of the 3).',
      ),
      RuleQuestion(
        id: 'q_vb_2',
        sport: 'Volleyball',
        question: 'How many points are needed to win sets 1 through 4 in regulation volleyball?',
        options: ['15 points', '21 points', '25 points (with 2-point lead)', '30 points'],
        correctIndex: 2,
        explanation: 'Sets 1-4 are played to 25 points with a required minimum advantage of 2 points.',
      ),
      RuleQuestion(
        id: 'q_vb_3',
        sport: 'Volleyball',
        question: 'What is the primary role of the Libero player in volleyball?',
        options: ['Serve aces only', 'Specialized back-row defensive player', 'Lead middle blocker above the net', 'Captain unable to be substituted'],
        correctIndex: 1,
        explanation: 'The Libero wears a contrasting jersey and specializes in back-row defense and reception.',
      ),
      RuleQuestion(
        id: 'q_vb_4',
        sport: 'Volleyball',
        question: 'In which direction do players rotate when winning the right to serve?',
        options: ['Counter-clockwise', 'Clockwise', 'Arbitrary order', 'Front row only'],
        correctIndex: 1,
        explanation: 'Player rotation follows a strict clockwise order through the 6 court positions.',
      ),
      RuleQuestion(
        id: 'q_vb_5',
        sport: 'Volleyball',
        question: 'What is an unreturned direct serve that lands in bounds for a point called?',
        options: ['Ace', 'Pipe', 'Spike', 'Dig'],
        correctIndex: 0,
        explanation: 'A serve that hits the floor in bounds without being touched by the opponent is an Ace.',
      ),
    ],
    'Tennis': [
      RuleQuestion(
        id: 'q_tn_1',
        sport: 'Tennis',
        question: 'What is the correct scoring progression within an individual tennis game?',
        options: ['1, 2, 3, 4', '15, 30, 40, Game', '10, 20, 30, Game', '5, 10, 15, 20'],
        correctIndex: 1,
        explanation: 'The traditional sequence is 15, 30, 40, and Game (at 40-40, the score is Deuce).',
      ),
      RuleQuestion(
        id: 'q_tn_2',
        sport: 'Tennis',
        question: 'At what game score in a set is a deciding tiebreak played?',
        options: ['At 5-5', 'At 6-6', 'At 7-7', 'At any tied score'],
        correctIndex: 1,
        explanation: 'When game scores reach 6-6, a tiebreak is played to 7 points with a 2-point margin.',
      ),
      RuleQuestion(
        id: 'q_tn_3',
        sport: 'Tennis',
        question: 'What is winning a game while the opponent is serving called?',
        options: ['Ace', 'Break', 'Holding', 'Set point'],
        correctIndex: 1,
        explanation: 'Winning a game as the returning receiver is called a Break of serve.',
      ),
      RuleQuestion(
        id: 'q_tn_4',
        sport: 'Tennis',
        question: 'Which tennis court surface produces the slowest pace and highest bounce?',
        options: ['Grass', 'Hard court', 'Clay', 'Carpet'],
        correctIndex: 2,
        explanation: 'Red clay absorbs ball speed and produces higher topspin kicks than other surfaces.',
      ),
      RuleQuestion(
        id: 'q_tn_5',
        sport: 'Tennis',
        question: 'How many serve attempts does a player have per point?',
        options: ['1 attempt', '2 attempts (first and second serve)', '3 attempts', 'Unlimited'],
        correctIndex: 1,
        explanation: 'If the first serve is a fault (net or out), the server has a second attempt.',
      ),
    ],
  };

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _studiedTopicIds.clear();
      _savedTopicIds.clear();
      _bestTestScores.clear();

      final studied = prefs.getStringList('rules_studied_topics');
      if (studied != null) _studiedTopicIds.addAll(studied);

      final saved = prefs.getStringList('rules_saved_topics');
      if (saved != null) _savedTopicIds.addAll(saved);

      final rawScores = prefs.getString('rules_best_scores');
      if (rawScores != null && rawScores.isNotEmpty) {
        final Map<String, dynamic> map = json.decode(rawScores);
        map.forEach((k, v) => _bestTestScores[k] = v as int);
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('rules_studied_topics', _studiedTopicIds.toList());
      await prefs.setStringList('rules_saved_topics', _savedTopicIds.toList());
      await prefs.setString('rules_best_scores', json.encode(_bestTestScores));
    } catch (_) {}
  }

  void toggleStudied(String id) {
    if (_studiedTopicIds.contains(id)) {
      _studiedTopicIds.remove(id);
    } else {
      _studiedTopicIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void toggleSaved(String id) {
    if (_savedTopicIds.contains(id)) {
      _savedTopicIds.remove(id);
    } else {
      _savedTopicIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void updateBestScore(String sport, int score) {
    final cur = _bestTestScores[sport] ?? 0;
    if (score > cur) {
      _bestTestScores[sport] = score;
      _save();
      notifyListeners();
    }
  }

  void resetProgress() {
    _studiedTopicIds.clear();
    _savedTopicIds.clear();
    _bestTestScores.clear();
    _save();
    notifyListeners();
  }
}
