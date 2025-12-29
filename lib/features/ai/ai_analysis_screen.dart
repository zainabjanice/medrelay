import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/theme/app_colors.dart';

class AIAnalysisScreen extends StatefulWidget {
  const AIAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<AIAnalysisScreen> createState() => _AIAnalysisScreenState();
}

class _AIAnalysisScreenState extends State<AIAnalysisScreen> {
  final _symptomsController = TextEditingController();
  final _historyController = TextEditingController();
  final _vitalsController = TextEditingController();

  bool _isAnalyzing = false;
  bool _hasResults = false;

  // Sample AI results
  Map<String, dynamic>? _aiResults;

  @override
  void dispose() {
    _symptomsController.dispose();
    _historyController.dispose();
    _vitalsController.dispose();
    super.dispose();
  }

  Future<void> _analyzePatient() async {
    if (_symptomsController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter patient symptoms',
        backgroundColor: AppColors.error,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _hasResults = false;
    });

    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 3));

    setState(() {
      _isAnalyzing = false;
      _hasResults = true;
      _aiResults = {
        'diagnoses': [
          {
            'name': 'Hypertension',
            'confidence': 85,
            'description': 'High blood pressure requiring monitoring',
          },
          {
            'name': 'Cardiovascular Risk',
            'confidence': 72,
            'description': 'Elevated risk factors detected',
          },
          {
            'name': 'Anxiety Disorder',
            'confidence': 65,
            'description': 'Stress-related symptoms present',
          },
        ],
        'recommendedSpecialist': 'Cardiologist',
        'urgency': 'medium',
        'suggestedTests': [
          'ECG (Electrocardiogram)',
          'Blood Pressure Monitoring',
          'Lipid Profile Test',
          'Complete Blood Count',
        ],
        'treatments': [
          'Lifestyle modifications',
          'Blood pressure medication review',
          'Stress management techniques',
          'Regular exercise routine',
        ],
        'warnings': [
          'Monitor blood pressure daily',
          'Avoid high-sodium foods',
          'Schedule follow-up in 2 weeks',
        ],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        title: const Text('AI Medical Analysis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Get.snackbar(
                'History',
                'Previous analyses coming soon',
                backgroundColor: AppColors.info,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.lightGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI-Powered Analysis',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Get intelligent medical insights',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Input Section
            if (!_hasResults) ...[
              _buildSectionTitle('Patient Information', isDark),
              const SizedBox(height: 12),

              TextField(
                controller: _symptomsController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Symptoms',
                  hintText: 'e.g., Chest pain, shortness of breath, fatigue...',
                  prefixIcon: const Icon(Icons.sick),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightBlue,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _historyController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Medical History',
                  hintText: 'e.g., Hypertension, diabetes...',
                  prefixIcon: const Icon(Icons.history_edu),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightBlue,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _vitalsController,
                decoration: InputDecoration(
                  labelText: 'Vital Signs',
                  hintText: 'e.g., BP: 140/90, HR: 85, Temp: 37.2°C',
                  prefixIcon: const Icon(Icons.monitor_heart),
                  filled: true,
                  fillColor: isDark
                      ? AppColors.darkSurface
                      : AppColors.lightBlue,
                ),
              ),

              const SizedBox(height: 24),

              // Analyze Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isAnalyzing ? null : _analyzePatient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                  ),
                  child: _isAnalyzing
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Analyzing...'),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.psychology),
                            SizedBox(width: 8),
                            Text(
                              'Analyze with AI',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                ),
              ),
            ],

            // Results Section
            if (_hasResults && _aiResults != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Analysis Results', isDark),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _hasResults = false;
                        _aiResults = null;
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('New Analysis'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Urgency Badge
              _buildUrgencyBadge(_aiResults!['urgency']),

              const SizedBox(height: 16),

              // Possible Diagnoses
              _buildResultCard(
                title: 'Possible Diagnoses',
                icon: Icons.medical_services,
                color: AppColors.primary,
                child: Column(
                  children: (_aiResults!['diagnoses'] as List).map((diagnosis) {
                    return _buildDiagnosisItem(
                      diagnosis['name'],
                      diagnosis['confidence'],
                      diagnosis['description'],
                    );
                  }).toList(),
                ),
                isDark: isDark,
              ),

              const SizedBox(height: 16),

              // Recommended Specialist
              _buildResultCard(
                title: 'Recommended Specialist',
                icon: Icons.person_search,
                color: AppColors.secondary,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.local_hospital,
                      color: AppColors.secondary,
                    ),
                  ),
                  title: Text(
                    _aiResults!['recommendedSpecialist'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Get.toNamed('/transfers');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                    child: const Text('Transfer'),
                  ),
                ),
                isDark: isDark,
              ),

              const SizedBox(height: 16),

              // Suggested Tests
              _buildResultCard(
                title: 'Suggested Tests',
                icon: Icons.science,
                color: AppColors.info,
                child: Column(
                  children: (_aiResults!['suggestedTests'] as List).map((test) {
                    return _buildListItem(test, Icons.check_circle_outline);
                  }).toList(),
                ),
                isDark: isDark,
              ),

              const SizedBox(height: 16),

              // Treatment Recommendations
              _buildResultCard(
                title: 'Treatment Recommendations',
                icon: Icons.healing,
                color: AppColors.success,
                child: Column(
                  children: (_aiResults!['treatments'] as List).map((
                    treatment,
                  ) {
                    return _buildListItem(treatment, Icons.medical_information);
                  }).toList(),
                ),
                isDark: isDark,
              ),

              const SizedBox(height: 16),

              // Warning Signs
              _buildResultCard(
                title: 'Important Notes',
                icon: Icons.warning,
                color: AppColors.warning,
                child: Column(
                  children: (_aiResults!['warnings'] as List).map((warning) {
                    return _buildListItem(
                      warning,
                      Icons.info,
                      AppColors.warning,
                    );
                  }).toList(),
                ),
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildUrgencyBadge(String urgency) {
    Color color;
    IconData icon;

    switch (urgency) {
      case 'high':
        color = AppColors.error;
        icon = Icons.priority_high;
        break;
      case 'medium':
        color = AppColors.warning;
        icon = Icons.report_problem;
        break;
      default:
        color = AppColors.success;
        icon = Icons.check_circle;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Urgency Level',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              Text(
                urgency.toUpperCase(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required IconData icon,
    required Color color,
    required Widget child,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(padding: const EdgeInsets.all(16), child: child),
        ],
      ),
    );
  }

  Widget _buildDiagnosisItem(String name, int confidence, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$confidence%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: confidence / 100,
            backgroundColor: AppColors.borderLight,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String text, IconData icon, [Color? color]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: color ?? AppColors.success),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
