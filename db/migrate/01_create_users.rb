class CreateUsers < ActiveRecord::Migration[5.2]
    def change
        create_table :users do |t|
        t.string :name
        t.string :password
        t.integer :age
        t.integer :weight
        t.integer :calorie_goal
        end
    end
end
