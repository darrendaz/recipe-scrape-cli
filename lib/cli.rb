# require "pry"

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
                puts "Makes #{recipe.yield}"
                puts "Takes approximately #{recipe.time} to make."
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