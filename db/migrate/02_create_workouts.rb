class CreateWorkouts < ActiveRecord::Migration[5.2]
    def change
        create_table :workouts do |t|
        t.string :type
        t.string :description
        t.integer :difficulty
        t.integer :calories_burned
        t.integer :duration
        end
    end
end
