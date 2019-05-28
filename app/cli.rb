require "pry"

class Cli
    def run
        Scraper.scrape
        puts 'Scrape complete!'

        display_recipes
        menu
    end

    def display_recipes
        Recipe.all.each.with_index(1) do |recipe, i|
            puts "#{i}. #{recipe.name}"
        end
    end

    def menu
        puts "Choose a recipe:"
        input = gets.chomp.downcase
        if input == "exit"
            puts "Until next time my friend!"
        else
            # binding.pry
            recipe = Recipe.all[input.to_i - 1]

            if !recipe
                puts "I didn't quite catch that."
                puts "Please try again and make sure you entered the correct menu number."
                menu
            else
                puts "Sure! #{recipe.name}"
                
                Scraper.scrape_details(recipe)
                
                puts "#{recipe.name}"
                puts "By #{recipe.author}"
                
                if recipe.yield
                    puts "Makes #{recipe.yield}"
                else
                    puts "This is a no-recipe recipe so it will make as much as you want."
                end
                if recipe.time
                    puts "Takes approximately #{recipe.time} to make."
                else
                    puts "This is a no-recipe recipe so it will take as long as you want."
                end
                puts "Intro: #{recipe.intro}"
                puts "Ingredients: #{recipe.ingredients}"
                puts "Steps: "
                
                recipe.steps.each.with_index(1) do |step, i|
                    puts "Step #{i}: #{step}"
                end
                
                puts "Tags: #{recipe.tags}"
            end
        end
    end
end