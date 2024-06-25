import 'package:flutter/material.dart';
import 'package:workout/data/hive_database.dart';
import 'package:workout/datetime/date_time.dart';
import 'package:workout/models/exercise.dart';

import '../models/workout.dart';

class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();
  /* 

  WORKOUT DATA STRUCTURE

  THIS  OVER ALL LIST CONTAINS THE DIFFERENT WORKOUTS
  EACH WORKOUT HAS A NAME  , AND LIST  OF EXERCISE

  */

  List<Workout> workoutList = [
    //default workout
    Workout(
      name: "Upper Body",
      exercise: [
        Exercise(name: "Bicep Curls", weight: "10", reps: "10", sets: "3"),
      ],
    ),
    Workout(
      name: "Lower Body",
      exercise: [
        Exercise(name: "Squats", weight: "10", reps: "10", sets: "3"),
      ],
    ),
  ];

  //if there are workouts already in database , then get that workout list
  void initalizeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    }
    //otherwise use  default workout
    else {
      db.saveToDatabase(workoutList);
    }

    //load heat map
    loadHeatMap();
  }

  //get the list  of workout
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  //get length of a given workout
  int numberofExerciseInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercise.length;
  }

  //add a workout

  void addWorkout(String name) {
    workoutList.add(Workout(name: name, exercise: []));
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //add  an exercise to  a workout

  void addExercise(String workoutName, String exerciseName, String weight,
      String reps, String sets) {
    //find the relevant workout
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercise.add(
        Exercise(name: exerciseName, weight: weight, reps: reps, sets: sets));
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
  }

  //check off exercise

  void checkoffExercise(String workoutName, String exerciseName) {
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);
    //load heat map
    loadHeatMap();

  }

  //return relevant workout object ,given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout =
        workoutList.firstWhere((workout) => workout.name == workoutName);
    return relevantWorkout;
  }

  //return relevant exercise object , given a workout name + exercise name

  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    //then  find the relevant exeercise in that work out
    Exercise relevantExercise = relevantWorkout.exercise
        .firstWhere((exercise) => exercise.name == exerciseName);
    return relevantExercise;
  }

  //get start date
  String getStartDate() {
    return db.getStartDate();
  }

  //heat map
  Map<DateTime, int> heatMapDataSet = {};

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(getStartDate());

    //count the number of the day load

    int daysInbetween = DateTime.now().difference(startDate).inDays;

    //go from start date  to today , and add each completion status to dataset

    for (int i = 0; i < daysInbetween + 1; i++) {
      String yyyymmdd =
          convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

      //completion status = 0 or 1

      int completionStatus = db.getCompletionStatus(yyyymmdd);

      //year
      int year = startDate.add(Duration(days: i)).year;

      //month
      int month = startDate.add(Duration(days: i)).month;
      //day
      int day = startDate.add(Duration(days: i)).day;
      

      final percentForEachDay = <DateTime , int>{
            DateTime(year, month ,day) : completionStatus
      };
      heatMapDataSet.addEntries(percentForEachDay.entries);
    }
  }
}
