PdfPath = "public/Jordan_Running_Resume_2012-06-11.pdf"

begin
  require 'vlad'
  Vlad.load :scm => :git, :config => 'deploy.rb'
rescue LoadError
  # do nothing
end

desc "Regenerate the site, optionally push to master and deploy"
task :deploy do
  STDOUT.print "Git push to origin/master first? "
  sh "git push origin master" if STDIN.gets =~ /^y/i
end
task :deploy  => "public/index.html"
task :deploy  => "vlad:update"

desc "Generate HTML, minify assets and package in ./public"
task :default => "public/index.html"

desc "Generate a PDF"
task :pdf     => 'pdf:render'

desc "Generate HTML by invoking resume.rb"
task :render  => "resume.rb" do
  desc "Invoke resume.rb to regenerate the HTML"
  sh "./resume.rb index.html"
end

file "index.html" => :render

file "public/index.html" do ENV['RESUME_ENV'] ||= 'production' end
file "public/index.html" => [ "index.html", "public/css/resume.css" ] do
  desc "Minify and concatenate HTML and inline CSS and JavaScript"
  sh "htmlcompressor -o public --remove-quotes --remove-intertag-spaces \
                     --compress-css --compress-js index.html"
end

file "public/css/resume.css" => FileList[ *%w[ css/resume.css css/lib/*.css ] ] do
  desc "Minify and concatenate CSS files"

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
