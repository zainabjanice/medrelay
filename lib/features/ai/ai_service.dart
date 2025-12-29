import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static final AIService _instance = AIService._internal();
  factory AIService() => _instance;
  AIService._internal();

  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const String _apiKey =
      'YOUR_ANTHROPIC_API_KEY'; // Replace with your key
  static const String _model = 'claude-sonnet-4-20250514';

  /// Analyze patient symptoms and recommend specialists
  Future<SpecialistRecommendation> analyzeSymptoms({
    required List<String> symptoms,
    required String patientAge,
    required String patientGender,
    required String medicalHistory,
    required String vitalSigns,
  }) async {
    try {
      final prompt =
          '''
You are a medical AI assistant analyzing patient symptoms to recommend appropriate specialists.

Patient Information:
- Age: $patientAge
- Gender: $patientGender
- Symptoms: ${symptoms.join(', ')}
- Medical History: $medicalHistory
- Vital Signs: $vitalSigns

Please analyze this information and provide:
1. Top 3 specialist recommendations with confidence scores (0-100)
2. Urgency level (low/medium/high/emergency)
3. Suggested diagnostic tests
4. Brief reasoning for each recommendation
5. Warning signs to watch for

Respond ONLY with valid JSON in this exact format:
{
  "specialists": [
    {
      "specialty": "Cardiologist",
      "confidence": 85,
      "reasoning": "Brief explanation"
    }
  ],
  "urgency": "medium",
  "suggestedTests": ["Test 1", "Test 2"],
  "warningSigns": ["Sign 1", "Sign 2"],
  "summary": "Brief summary"
}
''';

      final response = await _callClaudeAPI(prompt);
      return SpecialistRecommendation.fromJson(json.decode(response));
    } catch (e) {
      throw Exception('Failed to analyze symptoms: $e');
    }
  }

  /// Generate medical report summary
  Future<String> generateReportSummary({
    required String patientName,
    required String diagnosis,
    required String treatment,
    required String medications,
  }) async {
    try {
      final prompt =
          '''
Generate a concise medical report summary for:

Patient: $patientName
Diagnosis: $diagnosis
Treatment: $treatment
Medications: $medications

Create a professional summary in 2-3 paragraphs suitable for referral to another doctor.
''';

      return await _callClaudeAPI(prompt);
    } catch (e) {
      throw Exception('Failed to generate report: $e');
    }
  }

  /// Suggest differential diagnoses
  Future<List<String>> suggestDifferentialDiagnoses({
    required List<String> symptoms,
    required String patientInfo,
  }) async {
    try {
      final prompt =
          '''
Based on these symptoms: ${symptoms.join(', ')}
Patient info: $patientInfo

List 5 possible differential diagnoses in order of likelihood.
Respond with only a JSON array of diagnosis names.
''';

      final response = await _callClaudeAPI(prompt);
      final List<dynamic> diagnoses = json.decode(response);
      return diagnoses.map((d) => d.toString()).toList();
    } catch (e) {
      throw Exception('Failed to suggest diagnoses: $e');
    }
  }

  /// Analyze medical document
  Future<DocumentAnalysis> analyzeDocument({
    required String documentText,
    required String documentType,
  }) async {
    try {
      final prompt =
          '''
Analyze this $documentType medical document:

$documentText

Extract and provide:
1. Key findings
2. Abnormal values
3. Recommendations
4. Follow-up actions needed

Respond with JSON in this format:
{
  "keyFindings": ["finding1", "finding2"],
  "abnormalValues": ["value1", "value2"],
  "recommendations": ["rec1", "rec2"],
  "followUpActions": ["action1", "action2"],
  "summary": "Brief summary"
}
''';

      final response = await _callClaudeAPI(prompt);
      return DocumentAnalysis.fromJson(json.decode(response));
    } catch (e) {
      throw Exception('Failed to analyze document: $e');
    }
  }

  /// Call Claude API
  Future<String> _callClaudeAPI(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'x-api-key': _apiKey,
          'anthropic-version': '2023-06-01',
        },
        body: json.encode({
          'model': _model,
          'max_tokens': 1024,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['content'][0]['text'];
      } else {
        throw Exception('API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to call Claude API: $e');
    }
  }
}

// Models for AI responses

class SpecialistRecommendation {
  final List<SpecialistSuggestion> specialists;
  final String urgency;
  final List<String> suggestedTests;
  final List<String> warningSigns;
  final String summary;

  SpecialistRecommendation({
    required this.specialists,
    required this.urgency,
    required this.suggestedTests,
    required this.warningSigns,
    required this.summary,
  });

  factory SpecialistRecommendation.fromJson(Map<String, dynamic> json) {
    return SpecialistRecommendation(
      specialists: (json['specialists'] as List)
          .map((s) => SpecialistSuggestion.fromJson(s))
          .toList(),
      urgency: json['urgency'] ?? 'medium',
      suggestedTests: List<String>.from(json['suggestedTests'] ?? []),
      warningSigns: List<String>.from(json['warningSigns'] ?? []),
      summary: json['summary'] ?? '',
    );
  }
}

class SpecialistSuggestion {
  final String specialty;
  final int confidence;
  final String reasoning;

  SpecialistSuggestion({
    required this.specialty,
    required this.confidence,
    required this.reasoning,
  });

  factory SpecialistSuggestion.fromJson(Map<String, dynamic> json) {
    return SpecialistSuggestion(
      specialty: json['specialty'] ?? '',
      confidence: json['confidence'] ?? 0,
      reasoning: json['reasoning'] ?? '',
    );
  }
}

class DocumentAnalysis {
  final List<String> keyFindings;
  final List<String> abnormalValues;
  final List<String> recommendations;
  final List<String> followUpActions;
  final String summary;

  DocumentAnalysis({
    required this.keyFindings,
    required this.abnormalValues,
    required this.recommendations,
    required this.followUpActions,
    required this.summary,
  });

  factory DocumentAnalysis.fromJson(Map<String, dynamic> json) {
    return DocumentAnalysis(
      keyFindings: List<String>.from(json['keyFindings'] ?? []),
      abnormalValues: List<String>.from(json['abnormalValues'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      followUpActions: List<String>.from(json['followUpActions'] ?? []),
      summary: json['summary'] ?? '',
    );
  }
}
