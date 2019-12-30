User.destroy_all

10.times do
    User.create(name: Faker::Name.name, password: "1234", age: Faker::Number.number(digits:2), weight: Faker::Number.number(digits: 3), calorie_goal: Faker::Number.number(digits: 4))
end

Workout.create(category: "cardio", description: "light running intervals", difficulty: 2, calories_burned: 150, duration: 30)
Workout.create(category: "cardio", description: "medium running intervals", difficulty: 3, calories_burned: 220, duration: 45)
Workout.create(category: "cardio", description: "high intensity running intervals", difficulty: 5, calories_burned: 300, duration: 60)
Workout.create(category: "meditation", description: "hot vinyasa", difficulty: 4, calories_burned: 150, duration: 45)
Workout.create(category: "meditation", description: "rest and relaxation yoga", difficulty: 2, calories_burned: 100, duration: 45)
Workout.create(category: "active regeneration", description: "zoomba", difficulty: 3, calories_burned: 180, duration: 45)
Workout.create(category: "active regeneration", description: "crossfit", difficulty: 5, calories_burned: 250, duration: 60)


