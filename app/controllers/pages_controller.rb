require 'nokogiri'
require 'open-uri'
class PagesController < ApplicationController
  def get_reviews
    if params[:link].present?
      begin
        @customer_reviews = get_reviews_parse(params[:link])
         render json: @customer_reviews
      rescue Exception => e
        error_msg = e.message
        render json: {error:error_msg}, status: :unprocessable_entity
      end
    else
      error_msg = 'Link parameter is missing'
      render json: {error:error_msg}, status: :unprocessable_entity
    end

  end

  def get_reviews_parse(link)
    sum = 0
    total_reviews = 0
    customer_reviews = {"average_rating" => 0,"customer_reviews" => []}
    months = {"January" => 1, "February" => 2, "March" => 3, "April" => 4, "May" => 5, "June" => 6,
    "July" => 7, "August" => 8, "September" => 9, "October" => 10, "November" => 11, "December" => 12}
    (1..20).to_a.each do |x|
    doc = Nokogiri::HTML(open(link + "?sort=cmV2aWV3c3VibWl0dGVkX2Rlc2M=&pid=#{x}"))
    page_reviews = {"page_#{x}" => []}
    doc.search('.mainReviews', '/').each do |link|
      if link.css('reviewText').children == []
        break
      else
        total_reviews += 1
          title = link.css('.reviewTitle').children[0].to_s.strip
          comment = link.css('.reviewText').children[0].to_s.strip
          date_str = link.css('.consumerReviewDate').children[0].to_s
          month,year = date_str.split('Reviewed in').last.strip.split(' ')
          #month,year = link.css('.consumerReviewDate').children[0].to_s.split('Reviewed in ')[1].split(' ')[0] if link.css('.consumerReviewDate').children
          #year = link.css('.consumerReviewDate').children[0].to_s.split('Reviewed in ')[1].split(' ')[1]
          date = Date.new(year.to_i,months[month])
          rating_string = link.css('.numRec').children[0].to_s
          rating = rating_string.split(' of ')[0].split('')[1].to_i
          sum += rating
          author = link.css('.consumerName').children[0].to_s.gsub(' ','')
          author_location = link.css('.consumerName').children[1].to_s.split('<span>from')[1].split('</span')[0].split(' ').join(' ')
          if !page_reviews["page_#{x}"].find {|x| x[:comment] == comment }
            page_reviews["page_#{x}"].push({
              :title=> title,
              :date => date,
              :rating => rating,
              :comment => comment,
              :author => author,
              :author_location => author_location
              })
            end
          end
        end
        customer_reviews["customer_reviews"].push(page_reviews)
      end
      average = sum / total_reviews
      customer_reviews["average_rating"] = average.to_f
      return customer_reviews
      # respond_to do |form|
      #   form.json {render json: @customer_reviews}
      # end
    end
end
