require_relative '../config/environment'
require 'pry'
require 'tty-prompt'
require 'tty-table'

class CLI

    PROMPT = TTY::Prompt.new

    def start
        self.welcome_menu
    end

    def welcome_menu
        PROMPT.select "Welcome to Your Workout Log!"  do |menu|
          menu.choice "Login", -> { login }
          menu.choice "Create an Account", -> { create_account }
          menu.choice "Exit"
        end
    end

    def login
        user_input = PROMPT.ask "Username"
        if @user = User.find_by(name: user_input)
            password_input = PROMPT.ask "Password"
        else 
            puts "User doesn't exist, please try again"
            login
        end

        if @user.password == password_input
            puts "Congrats, you're logged in!"
            main_menu
        else
            puts "Incorrect password, please try again."
            login
        end
    end

    def create_account
        user_input = PROMPT.ask "Type in a Username"
        if User.find_by(name: user_input)
            "That username already exists, try again"
            welcome_menu
        else
            password_input = PROMPT.ask "Password"
            @user = User.create(name: user_input, password: password_input)
            puts "Thanks for creating an account!"
            main_menu
        end
    end

    def main_menu
        PROMPT.select ("Please select one of the following options:")  do |menu|
            menu.choice "Add Existing Workout", -> { all_workouts } #WORKS!
            menu.choice "Add New Workout", -> { new_workouts } #WORKS!
            menu.choice "See Your Workouts", -> { see_my_workouts }   #WORKS!         
            menu.choice "Update Workout Log", -> { update_log} #WORKS!
            menu.choice "Exit"
        end
    end

    def all_workouts
        table = TTY::Table.new header: ["ID", "Category", "Desc", "Difficulty", "Cal. Burned", "Duration"]
        Workout.all.each do |workout|
            table << [workout.id, workout.category, workout.description, workout.difficulty, workout.calories_burned, workout.duration]
        end
        multirenderer = TTY::Table::Renderer::ASCII.new(table, multiline: true)
        table.orientation = :horizontal
        puts multirenderer.render

        user_input = PROMPT.ask('Select the workout ID')

        new_log = Log.create(user_id: @user.id, workout_id: user_input, date: Time.now)
        puts "New workout added to your log!"
        main_menu
    end

    def new_workouts
        category_input = PROMPT.select('What workout category would you like to choose from?', ["Cardio", "Meditation", "Active Regeneration"])
        mood_input = PROMPT.ask('How did you feel after the workout?')
        desc_input = PROMPT.ask('Describe the workout')
        diff_input = PROMPT.select('Rate the difficulty of the workout. 1 for easiest and 5 for hardest', [1, 2, 3, 4, 5])
        cals_burned_input = PROMPT.ask('How many calories do you burn on this workout?')
        time_input = PROMPT.ask('How many minutes is this workout?')
    
            new_workout = Workout.create(category: category_input, description: desc_input, difficulty: diff_input, calories_burned: cals_burned_input, duration: time_input)
            Log.create(user_id: @user.id, workout_id: new_workout.id, date: Time.now, mood: mood_input)
            puts "WORK YA BODY!!!"
        main_menu
    end

    def see_my_workouts
        table = TTY::Table.new header: ["Category", "Desc", "Difficulty", "Cal. Burned", "Duration", "Mood"]

        user_own_workouts = User.joins(:logs, :workouts).where(id: @user.id).pluck("workouts.category, workouts.description, workouts.difficulty, workouts.calories_burned, workouts.duration, logs.mood")
        user_own_workouts.each do |workout|
            table << [workout[0], workout[1], workout[2], workout[3], workout[4], workout[5]]
        end
        if table.length <= 1
            puts "You do not currently have any workouts" 
            main_menu
        else 
            multirenderer = TTY::Table::Renderer::ASCII.new(table, multiline: true)
            table.orientation = :horizontal
            puts multirenderer.render
        
            puts "You're doing amazing!!!"
        end
        main_menu
    end

    def update_log
        table = TTY::Table.new header: ["ID", "Category", "Desc", "Difficulty", "Cal. Burned", "Duration", "Mood"]
        user_workout_log_table = User.joins(:logs, :workouts).where(id: @user.id).pluck("users.name, logs.id, workouts.category, workouts.description, workouts.difficulty, workouts.calories_burned, workouts.duration, logs.mood")
        user_workout_log_table.each do |workout|
            table << [workout[1], workout[2], workout[3], workout[4], workout[5], workout[6], workout[7]]
        end

        if table.length <= 1
            puts "You do not currently have any workouts to update"
            main_menu
        else

        multirenderer = TTY::Table::Renderer::ASCII.new(table, multiline: true)
        table.orientation = :horizontal
        puts multirenderer.render

        update_type = PROMPT.select("Would you like to update or delete a workout?", ["Update", "Delete"])
        
            if update_type == "Update"
                id_input = PROMPT.ask "Which workout ID would you like to update?"
                mood_input = PROMPT.ask "How did you feel after the workout?"
                user_selected_workout = @user.logs.find_by(id: id_input)
                user_selected_workout.update(mood: mood_input) 
                puts "Your mood has been updated."
                main_menu
            elsif update_type == "Delete"
                id_input = PROMPT.ask "Which workout ID would you like to delete?"
                user_selected_workout = @user.logs.find_by(id: id_input)
                user_selected_workout.destroy
                puts "Workout deleted"
                main_menu
            end
        end
    end
end
