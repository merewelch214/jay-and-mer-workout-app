class CreateLogs < ActiveRecord::Migration[5.2]
    def change
        create_table :logs do |t|
        t.integer :user_id
        t.integer :workout_id
        t.datetime :date
        t.string :mood
        end
    end
end
