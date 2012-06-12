require "tempfile"

PdfPath = "public/Jordan_Running_Resume_2012-06-11.pdf"

task :default => "public/index.html"
task :pdf     => 'pdf:render'

task :render  => "resume.rb" do
  sh "./resume.rb index.html"
end

file "index.html" => :render

file "public/index.html" do ENV['RESUME_ENV'] ||= 'production' end
file "public/index.html" => [ "index.html", "public/css/resume.css" ] do
  sh "htmlcompressor -o public --remove-quotes --remove-intertag-spaces \
                     --compress-css --compress-js index.html"
end

file "public/css/resume.css" => FileList[ *%w[ css/resume.css css/lib/*.css ] ] do
  sh "juicer merge -o public/css/resume.css --force \
        css/lib/reset.css css/lib/ribbon.css css/resume.css"

  mkdir_p "public/css/lib"
  cp FileList[ "css/lib/*" ].exclude( "**/*.css" ), "public/css/lib/"
end

namespace :pdf do
  task :set_env do ENV['RESUME_ENV'] = 'pdf' end

  task :render => :set_env
  task :render => 'public/index.html' do
    puts "Rendering to PDF"
    sh %Q( wkhtmltopdf --print-media-type http://resume.dev/index.html "#{PdfPath}" )
  end
end
