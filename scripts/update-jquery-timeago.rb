#!ruby

puts "Clone repository.."
puts `mkdir ./tmp`
puts `git clone https://github.com/rmm5t/jquery-timeago.git ./tmp`

puts "Patch jquery timeago..."
puts `cd ./tmp && patch -p1 < ../scripts/jquery.timeago.js.1.patch`
puts `cd ./tmp && patch -p1 < ../scripts/jquery.timeago.js.2.patch`

print 'Patch locale files ... '
`rm ./tmp/locales/jquery.timeago.en.js`
Dir["./tmp/locales/*.js"].each do |file|
  if file =~ /jquery\.timeago\.(.+)\.js$/
    `sed -i "s/timeago.settings.strings/timeago.settings.strings[\\"#{$1}\\"]/" #{file}`
    print "#{$1} "
  end
end
puts

puts "Copying asset files..."
puts `cp ./tmp/jquery.timeago.js ./vendor/assets/javascripts/`
puts `cp ./tmp/locales/*.js ./vendor/assets/javascripts/locales`

puts "Generate rails-timeago-all.js..."
`echo "// Rails timeago bootstrap with all locales" > ./lib/assets/javascripts/rails-timeago-all.js`
`echo "//= require rails-timeago" >> ./lib/assets/javascripts/rails-timeago-all.js`
Dir["./vendor/assets/javascripts/locales/*.js"].each do |file|
  `echo "//= require locales/#{File.basename(file)}" >> ./lib/assets/javascripts/rails-timeago-all.js`
end

puts "Clean up..."
puts `rm ./tmp -rf`
