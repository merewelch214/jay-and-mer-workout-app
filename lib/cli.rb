require_relative '../config/environment'
require 'pry'
require 'tty-prompt'
require 'tty-table'
require 'tty-font'

class CLI

    PROMPT = TTY::Prompt.new

    def start
        font = TTY::Font.new(:standard)
        puts font.write("WORKOUT LOG")
        puts "-----------------------------------------------------------------------------------------"
        puts ""
        sleep(1) 
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
            PROMPT.say("User doesn't exist, please try again", color: :red)
            login
        end

        if @user.password == password_input
            PROMPT.say("Congrats, you're logged in!", color: :green)
            main_menu
        else
            PROMPT.say("Incorrect password, please try again.", color: :red)
            login
        end
    end

    def create_account
        user_input = PROMPT.ask "Create a Username:"
        if User.find_by(name: user_input)
            PROMPT.say("That username already exists, try again", color: :red)
            welcome_menu
        else
            password_input = PROMPT.ask "Password:"
            age_input = PROMPT.ask "Your age:"
            weight_input = PROMPT.ask "Current weight:"
            cal_goal_input = PROMPT.ask "Calorie burn goal:"
            @user = User.create(name: user_input, password: password_input, age: age_input, weight: weight_input, calorie_goal: cal_goal_input)
            puts ""
            PROMPT.say("Thanks for creating an account!", color: :green)
            main_menu
        end
    end

    def main_menu
        puts "----------"
        PROMPT.select ("Please select one of the following options:")  do |menu|
            menu.choice "Add Existing Workout", -> { all_workouts } #WORKS!
            menu.choice "Add New Workout", -> { new_workouts } #WORKS!
            menu.choice "See Your Workouts", -> { see_my_workouts }   #WORKS!         
            menu.choice "Update Workout Log", -> { update_log } #WORKS!
            menu.choice "Your Stats", -> { view_user_stats }
            menu.choice "Exit"
        end
    end

    def all_workouts
        puts "----------"
        table = TTY::Table.new header: ["ID", "Category", "Desc", "Difficulty", "Cal. Burned", "Duration"]
        Workout.all.each do |workout|
            table << [workout.id, workout.category, workout.description, workout.difficulty, workout.calories_burned, workout.duration]
        end
        multirenderer = TTY::Table::Renderer::ASCII.new(table, multiline: true)
        table.orientation = :horizontal
        puts multirenderer.render

        user_input = PROMPT.ask('Select the workout ID')

        new_log = Log.create(user_id: @user.id, workout_id: user_input, date: Time.now)
        puts ""
        PROMPT.say("New workout added to your log!", color: :green)
        puts ""
        main_menu
    end

    def new_workouts
        puts "----------"
        category_input = PROMPT.select('What workout category would you like to choose from?\n', ["Cardio", "Meditation", "Active Regeneration"])
        mood_input = PROMPT.ask('How did you feel after the workout?')
        desc_input = PROMPT.ask('Describe the workout')
        diff_input = PROMPT.select('Rate the difficulty of the workout. 1 for easiest and 5 for hardest', [1, 2, 3, 4, 5])
        cals_burned_input = PROMPT.ask('How many calories do you burn on this workout?')
        time_input = PROMPT.ask('How many minutes is this workout?')
    
            new_workout = Workout.create(category: category_input, description: desc_input, difficulty: diff_input, calories_burned: cals_burned_input, duration: time_input)
            Log.create(user_id: @user.id, workout_id: new_workout.id, date: Time.now, mood: mood_input)
            puts ""
            PROMPT.say("WORK YA BODY!!!", color: :yellow)
            puts ""
        main_menu
    end

    def see_my_workouts
        puts "----------"
        table = TTY::Table.new header: ["ID", "Category", "Desc", "Difficulty", "Cal. Burned", "Duration", "Mood"]
        user_workout_log_table = User.joins(:workouts, :logs).where(id: @user.id).pluck("logs.id, workouts.category, workouts.description, workouts.difficulty, workouts.calories_burned, workouts.duration, logs.mood").uniq
        user_workout_log_table.each do |workout|
            table << [workout[0], workout[1], workout[2], workout[3], workout[4], workout[5], workout[6]]
        end

        if table.length <= 1
            PROMPT.say("You do not currently have any workouts", color: :red)
            main_menu
        else 
            multirenderer = TTY::Table::Renderer::ASCII.new(table, multiline: true)
            table.orientation = :horizontal
            puts multirenderer.render
        
            PROMPT.say("You're doing amazing!!!", color: :blue)
        end
        main_menu
    end

    def update_log
        puts "----------"
        table = TTY::Table.new header: ["ID", "Category", "Desc", "Difficulty", "Cal. Burned", "Duration", "Mood"]
        user_workout_log_table = User.joins(:workouts, :logs).where(id: @user.id).pluck("logs.id, workouts.category, workouts.description, workouts.difficulty, workouts.calories_burned, workouts.duration, logs.mood").uniq
        user_workout_log_table.each do |workout|
            table << [workout[0], workout[1], workout[2], workout[3], workout[4], workout[5], workout[6]]
        end

        if table.length <= 1
            PROMPT.say("You do not currently have any workouts to update", color: :yellow)
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
                PROMPT.say("Your mood has been updated.", color: :green)
                total_minutes_worked_out
                total_calories
                main_menu
            elsif update_type == "Delete"
                id_input = PROMPT.ask "Which workout ID would you like to delete?"
                user_selected_workout = @user.logs.find_by(id: id_input)
                user_selected_workout.destroy
                PROMPT.say("Workout deleted", color: :yellow)
                main_menu
            end
        end
    end

    def total_minutes_worked_out
        total = 0
        @user.workouts.each do |workout|
            total += workout.duration 
        end
        total
    end

    def total_calories
        total = 0
        @user.workouts.each do |workout|
            total += workout.calories_burned
        end
        total
    end

    def fav_workouts
        total = Workout.joins(:logs).group("workouts.category").count
        fav_array = total.max_by {|category, num| num }
        most_popular_category = fav_array[0]
        count_logged = fav_array[1]
        puts "#{most_popular_category} is the most popular workout and has been logged #{count_logged} times"
    end

    def user_fav_workouts
        total = @user.workouts.group("workouts.category").count
        fav_array = total.max_by {|category, num| num }
        fav_workout = fav_array[0]
    end


    def avg_cals_burned
        num_of_logged_workouts = @user.workouts.length 
        total = total_calories / num_of_logged_workouts  
    end

    def cal_burn_progress
        cals_left = @user.calorie_goal - total_calories
    end

    def view_user_stats
        puts "----------"
        puts "You've burned #{total_calories} calories total!"
        puts "----------"
        puts "You've logged #{total_minutes_worked_out} minutes of workouts!"
        puts "----------"
        puts "Your favorite workout is #{user_fav_workouts}."
        puts "----------"
        puts "On average, you burn #{avg_cals_burned} calories per workout"
        puts "----------"
        puts "You set a goal of burning #{@user.calorie_goal} calories. You have #{cal_burn_progress} calories to go."
        main_menu
    end
end
