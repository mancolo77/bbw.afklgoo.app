import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RuleTopic {
  final String id;
  final String sport; // Футбол, Баскетбол, Волейбол, Теннис
  final String title;
  final String category; // 'Цель игры', 'Состав участников', 'Площадка', 'Подсчёт очков', 'Термины'
  final String content;
  final String terms; // ключевые термины для поиска

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
    // Футбол
    RuleTopic(
      id: 'fb_1',
      sport: 'Футбол',
      title: 'Цель игры и основные правила',
      category: 'Цель игры',
      content: 'Цель футбола — забить мяч в ворота соперника установленным числом касаний ногами или головой большее число раз, чем соперник за 90 минут матча (два тайма по 45 минут). Полевым игрокам запрещено касаться мяча руками.',
      terms: 'гол, тайм, свисток, мяч',
    ),
    RuleTopic(
      id: 'fb_2',
      sport: 'Футбол',
      title: 'Состав участников и замены',
      category: 'Состав участников',
      content: 'Матч проводят две команды по 11 игроков (10 полевых и 1 вратарь). По регламенту разрешено до 5 замен в течение 3 слотов. Вратарь — единственный игрок, имеющий право играть руками в своей штрафной площади.',
      terms: 'вратарь, голкипер, замена, состав',
    ),
    RuleTopic(
      id: 'fb_3',
      sport: 'Футбол',
      title: 'Размеры футбольного поля и разметка',
      category: 'Площадка',
      content: 'Стандартная длина поля составляет 100-110 метров, ширина 64-75 метров. Поле разделено центральной линией с кругом радиусом 9.15 м. У каждых ворот размечена вратарская и штрафная площадь (16.5 м от линии ворот).',
      terms: 'газон, разметка, штрафная, 11 метров',
    ),
    RuleTopic(
      id: 'fb_4',
      sport: 'Футбол',
      title: 'Подсчёт очков и определение победителя',
      category: 'Подсчёт очков',
      content: 'За каждый забитый гол команда получает 1 очко на табло. В регулярном чемпионате за победу начисляется 3 очка, за ничью — 1 очко. В матчах плей-офф при ничьей назначаются два экстра-тайма по 15 минут и серия пенальти.',
      terms: 'очки, пенальти, овертайм, победа',
    ),
    RuleTopic(
      id: 'fb_5',
      sport: 'Футбол',
      title: 'Ключевые футбольные термины: офсайд, фол, VAR',
      category: 'Термины',
      content: 'Положение вне игры (офсайд) фиксируется, если в момент паса атакующий находится ближе к линии ворот соперника, чем мяч и предпоследний обороняющийся. VAR — система видеопомощи арбитрам.',
      terms: 'офсайд, фол, горчичник, красная карточка, var',
    ),

    // Баскетбол
    RuleTopic(
      id: 'bb_1',
      sport: 'Баскетбол',
      title: 'Цель игры и структура матча',
      category: 'Цель игры',
      content: 'Цель — забросить мяч руками в подвешенную корзину соперника и помешать другой команде овладеть мячом. Матч состоит из 4 четвертей по 10 минут (FIBA) или по 12 минут (NBA).',
      terms: 'корзина, кольцо, четверть, сирена',
    ),
    RuleTopic(
      id: 'bb_2',
      sport: 'Баскетбол',
      title: 'Состав участников на площадке',
      category: 'Состав участников',
      content: 'Одновременно на площадке от команды находятся 5 игроков: разыгрывающий защитник, атакующий защитник, лёгкий форвард, тяжёлый форвард и центровой. Количество замен не ограничено.',
      terms: 'разыгрывающий, форвард, центровой, скамейка',
    ),
    RuleTopic(
      id: 'bb_3',
      sport: 'Баскетбол',
      title: 'Баскетбольная площадка и высота кольца',
      category: 'Площадка',
      content: 'Размер площадки 28х15 метров. Кольцо закреплено на высоте 3.05 метра на щите 1.8х1.05 м. Дуга трехочковой линии находится на расстоянии 6.75 м от центра кольца в турнирах FIBA.',
      terms: 'щит, дуга, трехсекундная зона, штрафная линия',
    ),
    RuleTopic(
      id: 'bb_4',
      sport: 'Баскетбол',
      title: 'Система начисления очков в баскетболе',
      category: 'Подсчёт очков',
      content: '1 очко дается за точный штрафной бросок, 2 очка — за бросок изнутри трехочковой дуги, 3 очка — за бросок из-за пределов дуги 6.75 м. Ничьих в баскетболе не бывает, назначаются 5-минутные овертаймы.',
      terms: 'трехочковый, данк, лей-ап, штрафной',
    ),
    RuleTopic(
      id: 'bb_5',
      sport: 'Баскетбол',
      title: 'Термины: пробежка, фол, фол в нападении, блок-шот',
      category: 'Термины',
      content: 'Пробежка — нелегальное перемещение ног при владении мячом без ведения. На атаку дается 24 секунды, на вывод мяча со своей половины — 8 секунд. Игрок удаляется за 5 персональных фолов.',
      terms: 'пробежка, двойное ведение, 24 секунды, фол',
    ),

    // Волейбол
    RuleTopic(
      id: 'vb_1',
      sport: 'Волейбол',
      title: 'Цель игры и базовый принцип',
      category: 'Цель игры',
      content: 'Цель игры — направить мяч через сетку так, чтобы он коснулся площадки соперника, либо заставить соперника совершить ошибку. Команде разрешено максимум 3 касания до перевода мяча через сетку.',
      terms: 'сетка, блок, подача, касания',
    ),
    RuleTopic(
      id: 'vb_2',
      sport: 'Волейбол',
      title: 'Состав команды и роль Либеро',
      category: 'Состав участников',
      content: 'На площадке играют 6 человек от команды. Игроки совершают переходы по часовой стрелке при выигранной подаче. Либеро — специальный защитный игрок в контрастной форме, не атакующий выше края сетки.',
      terms: 'либеро, связующий, доигровщик, диагональный',
    ),
    RuleTopic(
      id: 'vb_3',
      sport: 'Волейбол',
      title: 'Размеры волейбольной площадки и сетки',
      category: 'Площадка',
      content: 'Площадка 18х9 метров разделена сеткой пополам (два квадрата 9х9 м). Высота сетки: 2.43 м для мужчин и 2.24 м для женщин. Линия атаки отстоит от сетки на 3 метра.',
      terms: 'сетка, антенны, линия атаки, 3 метра',
    ),
    RuleTopic(
      id: 'vb_4',
      sport: 'Волейбол',
      title: 'Партии и подсчёт очков в волейболе',
      category: 'Подсчёт очков',
      content: 'Матч длится до 3 выигранных партий (из 5 сетов). Партии с 1 по 4 играются до 25 очков с разницей не менее 2 очков. Решающая пятая партия (тай-брейк) играется до 15 очков.',
      terms: 'сет, партия, тай-брейк, баланс',
    ),
    RuleTopic(
      id: 'vb_5',
      sport: 'Волейбол',
      title: 'Термины: эйс, пайп, блок, скидка',
      category: 'Термины',
      content: 'Эйс — очко, выигранное непосредственно с подачи без касания игроками соперника. Пайп — быстрая атака из 6-й зоны с задней линии. Блок — попытка преградить путь мячу над сеткой.',
      terms: 'эйс, пайп, блок, скидка, прием',
    ),

    // Теннис
    RuleTopic(
      id: 'tn_1',
      sport: 'Теннис',
      title: 'Цель игры и формат розыгрыша',
      category: 'Цель игры',
      content: 'Цель теннисиста — ударом ракетки перебить мяч через сетку на сторону противника так, чтобы тот не смог вернуть мяч до второго отскока от поверхности корта.',
      terms: 'ракетка, корт, гейм, сет, отскок',
    ),
    RuleTopic(
      id: 'tn_2',
      sport: 'Теннис',
      title: 'Одиночный и парный разряды',
      category: 'Состав участников',
      content: 'В одиночном разряде играют один на один, в парном — двое на двое. Подача чередуется каждый гейм, игроки меняются сторонами корта после каждого нечетного гейма партии.',
      terms: 'одиночный, пара, подающий, принимающий',
    ),
    RuleTopic(
      id: 'tn_3',
      sport: 'Теннис',
      title: 'Корт и типы покрытий',
      category: 'Площадка',
      content: 'Длина корта 23.77 м, ширина одиночного 8.23 м, парного 10.97 м. Сетка высотой 0.914 м в центре. Покрытия: хард (быстрый отскок), грунт (медленный, скользящий) и натуральная трава.',
      terms: 'хард, грунт, трава, задняя линия',
    ),
    RuleTopic(
      id: 'tn_4',
      sport: 'Теннис',
      title: 'Уникальная система счёта: 15, 30, 40, Больше',
      category: 'Подсчёт очков',
      content: 'В гейме очки считаются: 0, 15, 30, 40, гейм. При счёте 40:40 объявляется «ровно», для выигрыша гейма нужно набрать два очка подряд («больше», затем гейм). Сет выигрывает первый набравший 6 геймов.',
      terms: 'ровно, больше, брейк-поинт, матч-бол',
    ),
    RuleTopic(
      id: 'tn_5',
      sport: 'Теннис',
      title: 'Термины: брейк, тай-брейк, смэш, дроп-шот',
      category: 'Термины',
      content: 'Брейк — выигрыш гейма на чужой подаче. Тай-брейк играется при счёте 6:6 в сете до 7 очков с перевесом в 2. Смэш — мощный удар над головой по высокой свече соперника.',
      terms: 'брейк, тай-брейк, смэш, дроп-шот, свеча',
    ),
  ];

  final Map<String, List<RuleQuestion>> questionsBySport = const {
    'Футбол': [
      RuleQuestion(
        id: 'q_fb_1',
        sport: 'Футбол',
        question: 'Сколько полевых игроков и вратарей начинает матч в одной команде?',
        options: ['10 полевых и 1 вратарь', '11 полевых и 1 вратарь', '9 полевых и 1 вратарь', '10 полевых и 2 вратаря'],
        correctIndex: 0,
        explanation: 'Футбольная команда состоит ровно из 11 игроков: 10 полевых и 1 голкипер.',
      ),
      RuleQuestion(
        id: 'q_fb_2',
        sport: 'Футбол',
        question: 'На каком расстоянии от линии ворот находится точка пенальти?',
        options: ['9.15 м', '11 метров', '16.5 метров', '12 шагов (7 м)'],
        correctIndex: 1,
        explanation: 'Одиннадцатиметровый штрафной удар (пенальти) пробивается ровно с отметки 11 метров.',
      ),
      RuleQuestion(
        id: 'q_fb_3',
        sport: 'Футбол',
        question: 'Что фиксирует арбитр, если атакующий в момент паса ближе к воротам, чем мяч и предпоследний защитник?',
        options: ['Фол последней надежды', 'Угловой удар', 'Офсайд (положение вне игры)', 'Свободный удар за затяжку'],
        correctIndex: 2,
        explanation: 'Это классическое определение офсайда по правилам IFAB/ФИФА.',
      ),
      RuleQuestion(
        id: 'q_fb_4',
        sport: 'Футбол',
        question: 'Сколько очков получает команда за ничью в круговом чемпионате?',
        options: ['0 очков', '1 очко', '2 очка', '3 очка'],
        correctIndex: 1,
        explanation: 'За победу присуждается 3 очка, за ничью — 1 очко, за поражение — 0.',
      ),
      RuleQuestion(
        id: 'q_fb_5',
        sport: 'Футбол',
        question: 'Какое максимальное количество замен разрешено в основных турнирах?',
        options: ['3 замены', '5 замен в 3 слота', '6 замен без ограничений', 'Замены не ограничены'],
        correctIndex: 1,
        explanation: 'По современным правилам разрешено 5 замен, используемых максимум за 3 остановки игры.',
      ),
    ],
    'Баскетбол': [
      RuleQuestion(
        id: 'q_bb_1',
        sport: 'Баскетбол',
        question: 'На какой стандартной высоте установлено баскетбольное кольцо?',
        options: ['2.75 м', '3.00 м', '3.05 м', '3.20 м'],
        correctIndex: 2,
        explanation: 'Официальная высота кольца от паркета составляет ровно 3 метра 5 сантиметров (10 футов).',
      ),
      RuleQuestion(
        id: 'q_bb_2',
        sport: 'Баскетбол',
        question: 'Сколько времени дается атакующей команде на бросок по кольцу?',
        options: ['14 секунд', '24 секунды', '30 секунд', '40 секунд'],
        correctIndex: 1,
        explanation: 'По правилам FIBA и NBA на атаку отводится 24 секунды.',
      ),
      RuleQuestion(
        id: 'q_bb_3',
        sport: 'Баскетбол',
        question: 'Сколько очков начисляется за точный штрафной бросок?',
        options: ['1 очко', '2 очка', '3 очка', 'В зависимости от четверти'],
        correctIndex: 0,
        explanation: 'Точный бросок с линии штрафных приносит команде ровно 1 очко.',
      ),
      RuleQuestion(
        id: 'q_bb_4',
        sport: 'Баскетбол',
        question: 'Сколько игроков одной команды одновременно находится на паркете?',
        options: ['4 игрока', '5 игроков', '6 игроков', '7 игроков'],
        correctIndex: 1,
        explanation: 'В баскетболе играют 5 на 5.',
      ),
      RuleQuestion(
        id: 'q_bb_5',
        sport: 'Баскетбол',
        question: 'После скольких персональных фолов игрок покидает площадку по правилам FIBA?',
        options: ['После 4', 'После 5 фолов', 'После 6 фолов', 'После 7 фолов'],
        correctIndex: 1,
        explanation: 'В турнирах под эгидой FIBA игрок дисквалифицируется после получения 5-го персонального фола.',
      ),
    ],
    'Волейбол': [
      RuleQuestion(
        id: 'q_vb_1',
        sport: 'Волейбол',
        question: 'Сколько касаний мяча разрешено сделать команде до его перевода на сторону соперника?',
        options: ['1 касание', '2 касания', 'Не более 3 касаний', '4 касания'],
        correctIndex: 2,
        explanation: 'Команда имеет право максимум на 3 касания (блок первым касанием не считается).',
      ),
      RuleQuestion(
        id: 'q_vb_2',
        sport: 'Волейбол',
        question: 'До скольких очков играются первые 4 партии в классическом волейболе?',
        options: ['До 15 очков', 'До 21 очка', 'До 25 очков (с перевесом 2)', 'До 30 очков'],
        correctIndex: 2,
        explanation: 'Партии 1-4 играются до 25 очков при обязательном преимуществе минимум в 2 очка.',
      ),
      RuleQuestion(
        id: 'q_vb_3',
        sport: 'Волейбол',
        question: 'Какова роль игрока «Либеро» в волейболе?',
        options: ['Только подавать эйсы', 'Специализированный защитник задней линии', 'Главный блокирующий над сеткой', 'Капитан без права замены'],
        correctIndex: 1,
        explanation: 'Либеро носит форму другого цвета и выполняет ключевые функции приема и защиты на задней линии.',
      ),
      RuleQuestion(
        id: 'q_vb_4',
        sport: 'Волейбол',
        question: 'В каком направлении совершают переход игроки при выигрыше подачи?',
        options: ['Против часовой стрелки', 'По часовой стрелке', 'В произвольном порядке', 'Только передняя линия'],
        correctIndex: 1,
        explanation: 'Смена зон происходит строго по часовой стрелке.',
      ),
      RuleQuestion(
        id: 'q_vb_5',
        sport: 'Волейбол',
        question: 'Как называется очко, выигранное прямой подачей без возможности приема соперником?',
        options: ['Эйс', 'Пайп', 'Спайк', 'Диг'],
        correctIndex: 0,
        explanation: 'Подача навылет, приводящая к немедленному очку, называется эйсом (Ace).',
      ),
    ],
    'Теннис': [
      RuleQuestion(
        id: 'q_tn_1',
        sport: 'Теннис',
        question: 'Каков порядок начисления очков внутри одного теннисного гейма?',
        options: ['1, 2, 3, 4', '15, 30, 40, гейм', '10, 20, 30, гейм', '5, 10, 15, 20'],
        correctIndex: 1,
        explanation: 'Традиционная система подсчёта: 15, 30, 40, гейм (при 40:40 — «ровно»).',
      ),
      RuleQuestion(
        id: 'q_tn_2',
        sport: 'Теннис',
        question: 'При каком счёте в сете назначается решающий тай-брейк?',
        options: ['При счёте 5:5', 'При счёте 6:6', 'При счёте 7:7', 'При любом равенстве'],
        correctIndex: 1,
        explanation: 'При равном счёте 6:6 по геймам играется тай-брейк до 7 очков с перевесом в 2 очка.',
      ),
      RuleQuestion(
        id: 'q_tn_3',
        sport: 'Теннис',
        question: 'Как называется выигрыш гейма на подаче соперника?',
        options: ['Эйс', 'Брейк', 'Холдинг', 'Сетбол'],
        correctIndex: 1,
        explanation: 'Победа в гейме, когда подавал соперник, называется брейком (Break).',
      ),
      RuleQuestion(
        id: 'q_tn_4',
        sport: 'Теннис',
        question: 'Какое покрытие корта считается самым медленным с высоким отскоком мяча?',
        options: ['Трава', 'Хард', 'Грунт (Clay)', 'Ковёр'],
        correctIndex: 2,
        explanation: 'Грунтовое покрытие гасит поступательную скорость мяча и создает высокий отскок.',
      ),
      RuleQuestion(
        id: 'q_tn_5',
        sport: 'Теннис',
        question: 'Сколько попыток подачи дается игроку в каждом розыгрыше?',
        options: ['1 попытка', '2 попытки (первая и вторая подача)', '3 попытки', 'Не ограничено'],
        correctIndex: 1,
        explanation: 'При первой ошибке (аут или сетка) игрок имеет право на вторую подачу.',
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

