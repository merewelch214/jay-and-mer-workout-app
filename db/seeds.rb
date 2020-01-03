User.destroy_all

10.times do
    User.create(name: Faker::Name.name, password: "1234", age: Faker::Number.number(digits:2), weight: Faker::Number.number(digits: 3), calorie_goal: Faker::Number.number(digits: 4))
end

Workout.create(category: "Cardio", description: "Run 30 seconds, walk 1 minute", difficulty: 2, calories_burned: 150, duration: 30)
Workout.create(category: "Cardio", description: "Run 1 minute, walk 30 seconds", difficulty: 3, calories_burned: 220, duration: 45)
Workout.create(category: "Cardio", description: "Cycling hill intervals", difficulty: 5, calories_burned: 300, duration: 60)
Workout.create(category: "Cardio", description: "Tabata plyometrics", difficulty: 5, calories_burned: 300, duration: 60)
Workout.create(category: "Cardio", description: "Neighborhood walk", difficulty: 1, calories_burned: 50, duration: 35)
Workout.create(category: "Meditation", description: "Hot vinyasa yoga flow", difficulty: 4, calories_burned: 150, duration: 45)
Workout.create(category: "Meditation", description: "Rest and relaxation yoga", difficulty: 2, calories_burned: 75, duration: 45)
Workout.create(category: "Meditation", description: "Best stretch ever", difficulty: 4, calories_burned: 150, duration: 30)
Workout.create(category: "Meditation", description: "Yin yoga for regeneration", difficulty: 4, calories_burned: 150, duration: 120)
Workout.create(category: "Meditation", description: "Bikram yoga", difficulty: 4, calories_burned: 150, duration: 45)
Workout.create(category: "Weight training", description: "Full body weight circuit", difficulty: 3, calories_burned: 180, duration: 45)
Workout.create(category: "Weight training", description: "Crossfit", difficulty: 5, calories_burned: 600, duration: 60)
Workout.create(category: "Weight training", description: "Explosive dynamic training", difficulty: 5, calories_burned: 250, duration: 20)
Workout.create(category: "Weight training", description: "Muscular isolation, lower body lift", difficulty: 5, calories_burned: 250, duration: 35)
Workout.create(category: "Weight training", description: "Olympic lifting", difficulty: 5, calories_burned: 250, duration: 40)


