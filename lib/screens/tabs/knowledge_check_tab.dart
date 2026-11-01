import 'package:flutter/material.dart';
import '../../services/sports_rules_service.dart';
import '../../theme/app_theme.dart';

class KnowledgeCheckTab extends StatefulWidget {
  const KnowledgeCheckTab({super.key});

  @override
  State<KnowledgeCheckTab> createState() => _KnowledgeCheckTabState();
}

class _KnowledgeCheckTabState extends State<KnowledgeCheckTab> {
  final _service = SportsRulesService();
  String _selectedSport = 'Football';
  int _currentQuestionIndex = 0;
  int _selectedOption = -1;
  bool _answered = false;
  int _correctCount = 0;
  bool _testFinished = false;

  void _restartTest() {
    setState(() {
      _currentQuestionIndex = 0;
      _selectedOption = -1;
      _answered = false;
      _correctCount = 0;
      _testFinished = false;
    });
  }

  void _selectSport(String sport) {
    setState(() {
      _selectedSport = sport;
      _restartTest();
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = _service.questionsBySport[_selectedSport] ?? [];

    if (_testFinished) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.screenPadding),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.accentYellow.withAlpha(35),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.military_tech_rounded,
                        size: 48,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Quiz Completed!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Correct answers: $_correctCount of ${questions.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Review topics in the Handbook tab to strengthen your rules knowledge.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: AppTheme.buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                          ),
                        ),
                        onPressed: _restartTest,
                        child: const Text(
                          'Retake Quiz',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    final currentQ = questions.isNotEmpty && _currentQuestionIndex < questions.length
        ? questions[_currentQuestionIndex]
        : null;

    if (currentQ == null) {
      return Scaffold(
        backgroundColor: AppTheme.background,
        body: const Center(
          child: Text('No questions available.', style: TextStyle(color: AppTheme.textSecondary)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Knowledge Check',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Untimed quizzes on team sports rules',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),

              // Sport selector
              Row(
                children: ['Football', 'Basketball', 'Volleyball', 'Tennis'].map((sp) {
                  final isSelected = sp == _selectedSport;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: InkWell(
                        onTap: () => _selectSport(sp),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primary : AppTheme.surfaceSecondary,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppTheme.primary : AppTheme.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              sp,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : AppTheme.textMain,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Progress Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${questions.length}',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textMain),
                  ),
                  Text(
                    'Correct: $_correctCount',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / questions.length,
                  minHeight: 8,
                  backgroundColor: AppTheme.surfaceSecondary,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentYellow),
                ),
              ),
              const SizedBox(height: 16),

              // Question Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceCard,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  border: Border.all(color: AppTheme.border),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentQ.question,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...currentQ.options.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final optText = entry.value;
                      final isSelected = _selectedOption == idx;
                      final isCorrect = idx == currentQ.correctIndex;

                      Color borderColor = AppTheme.border;
                      Color bg = AppTheme.surfaceSecondary;
                      Widget? statusIcon;

                      if (_answered) {
                        if (isCorrect) {
                          borderColor = AppTheme.primary;
                          bg = AppTheme.primary.withAlpha(20);
                          statusIcon = const Icon(Icons.check_circle_rounded, color: AppTheme.primary, size: 20);
                        } else if (isSelected) {
                          borderColor = Colors.red;
                          bg = Colors.red.withAlpha(15);
                          statusIcon = const Icon(Icons.cancel_rounded, color: Colors.red, size: 20);
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: InkWell(
                          onTap: _answered
                              ? null
                              : () {
                                  setState(() {
                                    _selectedOption = idx;
                                    _answered = true;
                                    if (isCorrect) {
                                      _correctCount++;
                                    }
                                  });
                                },
                          borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                              border: Border.all(color: borderColor, width: isSelected || (_answered && isCorrect) ? 1.5 : 1.0),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    optText,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: AppTheme.textMain,
                                    ),
                                  ),
                                ),
                                ?statusIcon,
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    if (_answered) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _selectedOption == currentQ.correctIndex
                              ? AppTheme.primary.withAlpha(15)
                              : AppTheme.surfaceSecondary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _selectedOption == currentQ.correctIndex
                                ? AppTheme.primary.withAlpha(40)
                                : AppTheme.border,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _selectedOption == currentQ.correctIndex
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.info_outline_rounded,
                                  size: 16,
                                  color: _selectedOption == currentQ.correctIndex
                                      ? AppTheme.primary
                                      : AppTheme.textMain,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _selectedOption == currentQ.correctIndex
                                      ? 'Correct!'
                                      : 'Explanation:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedOption == currentQ.correctIndex
                                        ? AppTheme.primary
                                        : AppTheme.textMain,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentQ.explanation,
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: AppTheme.buttonHeight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
                            ),
                          ),
                          onPressed: () {
                            if (_currentQuestionIndex < questions.length - 1) {
                              setState(() {
                                _currentQuestionIndex++;
                                _selectedOption = -1;
                                _answered = false;
                              });
                            } else {
                              _service.updateBestScore(_selectedSport, _correctCount);
                              setState(() {
                                _testFinished = true;
                              });
                            }
                          },
                          child: Text(
                            _currentQuestionIndex < questions.length - 1 ? 'Next Question' : 'Complete Quiz',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
