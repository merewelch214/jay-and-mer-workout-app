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
        @user = User.find_by(name: user_input)
        password_input = PROMPT.ask "Password"
        if @user.password == password_input
            puts "Congrats, you're logged in!"
            main_menu
        else
            puts "Incorrect password, please try again."
            login
        end
      end

      #if person does not exist we can throw an error 
      #puts "That username doesn't exist, please try again"


      def create_account
        user_input = PROMPT.ask "Type in a Username"
        @user = User.create(name: user_input)
        password_input = PROMPT.ask "Password"
        @user.password = password_input
        puts "account created?"
        main_menu
        end

    def main_menu

        PROMPT.select ("Please select one of the following options:")  do |menu|
        menu.choice "Add Existing Workout", -> { all_workouts } #WORKS!
        menu.choice "Add New Workout", -> { new_workouts }
        menu.choice "See Your Workouts", -> { see_my_workouts }            
        menu.choice "Update Workout Log", -> { update_log}
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
            table = TTY::Table.new header: ["Category", "Desc", "Difficulty", "Cal. Burned", "Duration"]
            @user.workouts.each do |workout|
                table << [workout.category, workout.description, workout.difficulty, workout.calories_burned, workout.duration]
            end
            multirenderer = TTY::Table::Renderer::ASCII.new(table, multiline: true)
            table.orientation = :horizontal
            puts multirenderer.render
            puts "You're doing amazing!!!"
            main_menu
        end

        def update_log
            table = TTY::Table.new header: ["ID", "Category", "Desc", "Difficulty", "Cal. Burned", "Duration"]
            @user.workouts.each do |workout|
                table << [workout.id, workout.category, workout.description, workout.difficulty, workout.calories_burned, workout.duration]
            end
            multirenderer = TTY::Table::Renderer::ASCII.new(table, multiline: true)
            table.orientation = :horizontal
            puts multirenderer.render

        id_input = PROMPT.ask "Which workout ID would you like to update?"
        diff_input = PROMPT.select('Update difficulty from 1-5?', [1, 2, 3, 4, 5])
        cals_burned_input = PROMPT.ask('Update calories burned')
        time_input = PROMPT.ask('Update workout time')

        selected_workout = @user.workouts.find_by(id: id_input)
        selected_workout.update(difficulty: diff_input, calories_burned: cals_burned_input, duration: time_input) 
        end

end
