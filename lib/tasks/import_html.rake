namespace :import_html do
  task :import_lending => :environment do
    require 'nokogiri'
    require 'open-uri'

    # Fetch and parse HTML document
    doc = Nokogiri::HTML(open('https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183'))

    # puts "### Search for nodes by css"
    # doc.css('nav ul.menu li a', 'article h2').each do |link|
    #   puts link.content
    # end

    # puts "### Search for nodes by xpath"
    # doc.xpath('//nav//ul//li/a', '//article//h2').each do |link|
    #   puts link.content
    # end
    hash = {"customer_reviews" => []}
    months = {"January" => 1, "February" => 2, "March" => 3, "April" => 4, "May" => 5, "June" => 6,
    "July" => 7, "August" => 8, "September" => 9, "October" => 10, "November" => 11, "December" => 12}
    puts "### Or mix and match."
    doc.search('.mainReviews', '/').each do |link|
      comment = link.css('.reviewText').children[0].to_s
      month = link.css('.consumerReviewDate').children[0].to_s.split('Reviewed in ')[1].split(' ')[0]
      year = link.css('.consumerReviewDate').children[0].to_s.split('Reviewed in ')[1].split(' ')[1]
      date = DateTime.new(year.to_i,months[month])
      rating_string = link.css('.numRec').children[0].to_s
      rating = rating_string.split(' of ')[0].split('')[1].to_i
      author = link.css('.consumerName').children[0].to_s.gsub(' ','')
      author_location = link.css('.consumerName').children[1].to_s.split('<span>from')[1].split('</span')[0]
      hash["customer_reviews"].push({
        :date => date,
        :rating => rating,
        :author => author,
        :author_location => author_location
        })
      binding.pry
    end
  end
end
