require 'curb'
require 'nokogiri'
require 'csv'

    puts "Enter url of page with goods:"
        page = gets.chomp

    puts "Enter filename you prefer:"
        file_name = gets.chomp

    #page = "https://www.petsonic.com/snacks-huesos-para-perros/"
    puts "getting page " + page
    main_page = Curl.get(page)
    doc = Nokogiri::HTML(main_page.body_str)

count_product = doc.xpath('//*[@class="heading-counter"]').text.to_i

    puts "Count product " + count_product.to_s

    if count_product % 25 == 0
      count_page = (count_product / 25)
    else
      count_page = (count_product / 25).next
    end

    puts "Count page " + count_page.to_s

  all_product_link = []

     puts "Parsing links from all pages"

  i = 1
  while i <= count_page do
      if i == 1
        pagination_page = Curl.get(page)
      else
        pagination_page = Curl.get(page + "?p=" + "#{i}")
      end
      puts "Number of page parsing - " + i.to_s
       i+=1
      current_pagination_page = Nokogiri::HTML(pagination_page.body_str)

    current_pagination_page.xpath('//*[@class="product_img_link product-list-category-img"]/@href').each do |products|
      all_product_link << products
    end
  end
      puts "All products: " + all_product_link.length.to_s

    puts "Create and open file"
  CSV.open(file_name, "wb") do |csv_line|
  csv_line << ["Product name", "Product price", "Product image"]

    all_product_link.each do |product_link|

      puts "Getting product page - " + product_link
      current_link = Curl.get(product_link)
      product_page = Nokogiri::HTML(current_link.body_str)

      puts "Parsing data from this page"
        product_name= product_page.xpath('//div/h1').text
        product_img=product_page.xpath('//*[@id="bigpic"]/@src')

        attribute_list = product_page.xpath('//fieldset//ul/li')

      k=0
      attribute_list.each do |i|
        product_weight = i.xpath('//*[@class="radio_label"]')[k].text
        product_price = i.xpath('//*[@class="price_comb"]')[k].text
        k+=1
        puts "Write data to csv"
        koneccccc = ["#{product_name} - #{product_weight}", product_price, product_img ]
        csv_line << koneccccc
        puts "_____Write successfully_____"
      end
    end
end
 puts "Work was finished"