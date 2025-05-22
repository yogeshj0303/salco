import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';

class ProjectService {
  static const String baseUrl = 'https://salco.acttconnect.com/api';

  Future<List<Project>> getProjects() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/projects'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          final List<dynamic> projectsJson = data['data'];
          return projectsJson.map((json) => Project.fromJson(json)).toList();
        }
      }
      throw Exception('Failed to load projects');
    } catch (e) {
      throw Exception('Error fetching projects: $e');
    }
  }

  Future<Project> getProjectDetails(int projectId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/projects/$projectId'));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == true) {
          return Project.fromJson(data['data']);
        }
      }
      throw Exception('Failed to load project details');
    } catch (e) {
      throw Exception('Error fetching project details: $e');
    }
  }
} 