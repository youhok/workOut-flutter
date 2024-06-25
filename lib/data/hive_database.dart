// ignore_for_file: avoid_print

import 'package:hive/hive.dart';
import 'package:workout/datetime/date_time.dart';
import 'package:workout/models/exercise.dart';
import 'package:workout/models/workout.dart';

class HiveDatabase {
  //reference our hive box
  final _mybox = Hive.box("workout_database1");
  //check if there is already data stored , if not ,record the start date
  bool previousDataExists() {
    if (_mybox.isEmpty) {
      print("previous data does Not exist");
      _mybox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("previous data does exist");
      return true;
    }
  }

  //return start date as yyymmdd
  String getStartDate() {
    return _mybox.get("START_DATE");
  }

  //write data
  void saveToDatabase(List<Workout> workouts) {
    //convert workout object into list of string so that we can save in have
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    /*
    check if  any exercise have been done
    we will put 0 or 1 for each yyyymmdd date 
    
    */

    if (exerciseCompleted(workouts)) {
      _mybox.put("COMPLETION_STATUE${todaysDateYYYYMMDD()}", 1);
    } else {
      _mybox.put("COMPLETION_STATUE${todaysDateYYYYMMDD()}", 0);
    }

    //save into hive
    _mybox.put("WORKOUTS", workoutList);
    _mybox.put("EXCERCISE", exerciseList);
  }

  //read data , return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _mybox.get("WORKOUTS");
    final exerciseDetails = _mybox.get("EXCERCISE");

    //create workout  objects
    for (int i = 0; i < workoutNames.length; i++) {
      //each workout can have  multiple exercise
      List<Exercise> exerciseInEachWorkout = [];

      for (int j = 0; j < exerciseDetails[i].length; j++) {
        //so add each exerscise into a list

        exerciseInEachWorkout.add(Exercise(
          name: exerciseDetails[i][j][0],
          weight: exerciseDetails[i][j][1],
          reps: exerciseDetails[i][j][2],
          sets: exerciseDetails[i][j][3],
          isCompleted: exerciseDetails[i][j][4] == "true" ? true:false,
        )
        );
      }

      //create invdividual workout

      Workout workout = Workout(name: workoutNames[i], exercise: exerciseInEachWorkout);

      //add indivaidual workout  to overall list
      mySavedWorkouts.add(workout);
    }
    return mySavedWorkouts;
  }
  //check if  any exercises have been done
  bool exerciseCompleted(List<Workout> workouts) {
    //go thru each  workout
    for (var workout in workouts) {
      //go thru each exersicse in workout
      for (var exercise in workout.exercise) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  //return completion status of a given data yyymmdd
  int getCompletionStatus(String yyyymmdd){
    //return 0 or 1  , if null then return 0
    int  completionStatus = _mybox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

//converts workout  objects into a list
List<String> convertObjectToWorkoutList(List<Workout> workouts) {
  List<String> workoutList = [
    //eg. [upperbody, lowerbody]
  ];

  for (int i = 0; i < workouts.length; i++) {
    workoutList.add(
      workouts[i].name,
    );
  }
  return workoutList;
}

//converts the exercise in a workout object into a list of string
List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts) {
  List<List<List<String>>> exerciseList = [
    /* 
    
    [
      upper Body
      [[biceps ,10kg ,10reps,3sets ] , [triceps, 20kg ,10reps ,sets]];

      lower
      []

    ]
    
    */
  ];

  for (int i = 0; i < workouts.length; i++) {
    List<Exercise> exerciseInWorkout = workouts[i].exercise;
    List<List<String>> individualWorkout = [
      //Upper Body
      //[[biceps , 10kg , 10reps ,3sets ,],[tricep ,20kg ,10reps , 3sets]]
    ];

    for (int j = 0; j < exerciseInWorkout.length; j++) {
      List<String> individualExercise = [
        //[biceps , 10kg ,10reps ,3sets]
      ];
      individualExercise.addAll(
        [
          exerciseInWorkout[j].name,
          exerciseInWorkout[j].weight,
          exerciseInWorkout[j].reps,
          exerciseInWorkout[j].sets,
          exerciseInWorkout[j].isCompleted.toString(),
        ],
      );
      individualWorkout.add(individualExercise);
    }
    exerciseList.add(individualWorkout);
  }
  return exerciseList;
}
