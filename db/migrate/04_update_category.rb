class UpdateCategory < ActiveRecord::Migration[5.2]
    def change
        rename_column :workouts, :type, :category
    end
end
