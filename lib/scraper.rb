require "open-uri"
require "nokogiri"
# require "pry"

class Scraper
    SRC = "https://cooking.nytimes.com"
    
    def self.scrape
        numberOfPages = 4
        pageNum = 1
        
        while pageNum <= numberOfPages do
            puts "scraping (#{pageNum} / #{numberOfPages})"
            target = SRC + "/search?q=&page=" + "#{pageNum}"
            html = open(target)
            doc = Nokogiri::HTML(html)
            # all = 
            doc.css('article').each do |r|
                name = r.css('h3.name').text.strip
                url = r.attribute('data-url').value
                recipe = Recipe.new(name, url)
                recipe.save
            end
            pageNum += 1
        end

        def self.scrape_details(recipe)
            html = open(SRC + recipe.url)
            doc = Nokogiri::HTML(html)
            recipe.author = doc.css(".byline-name").text.strip

            if doc.css(".recipe-yield-value").length == 0
                recipe.yield = nil
                recipe.time = nil
            else
                recipe.yield = doc.css(".recipe-yield-value").first.text.strip
                recipe.time = doc.css(".recipe-yield-value")[1].text.strip
            end 

            recipe.intro = doc.css(".topnote p").first.text.strip

            recipe.tags = doc.css(".tags-nutrition-container").collect{ |tag|    
                tag.text.strip
            }
            recipe.steps = doc.css("ol.recipe-steps li").collect{ |step|
                step.text
            }

            ingredientsArray = doc.css(".recipe-ingredients").collect { |i|
                hash = {}
                i.css("li span.quantity").each.with_index {|q, index|
                    key = i.css("li span.ingredient-name")[index].text.gsub("\n", "").strip
                    hash[key] = q.text.gsub("\n", "").strip
                }
                hash
            }

            ingredientsArray.delete_at(-1) if ingredientsArray.length > 1
            
            if doc.css("h4.part-name")
                partsArray = doc.css("h4.part-name").collect{|part| part.text}
                recipe.ingredients = partsArray.collect {|part|
                    hash = {}
                    
                    ingredientsArray.each do |i|
                        hash[part] = i
                    end  
                    
                    hash
                }
            end

            recipe.ingredients = ingredientsArray if ingredientsArray.size == 1
        end
    end
end