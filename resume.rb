#!/usr/bin/env ruby

jordan_running = %{
  details:
    name:     Jordan Running
    email:    jr@jordanrunning.com
    phone:    (920) 737-9440
    location: Iowa City, Iowa
    tagline:  Web application developer specializing in Ruby on Rails
              and JavaScript
  
  experience:
  - company:  Independent Contractor
    position: Web Application Developer
    dates:    [ Oct 2010, Present ]
    bullet-points:
    - Developed a web frontend and Node.js backend for a Redis-backed
      English-Spanish translation database for [Componica, LLC][1]
    - Designed and prototyped a social networking and live chat
      system in Ruby on Rails, backed by MySQL and Redis
    links:
      1: http://componica.com/

  - company:  Cramer Development
    url:      http://cramerdev.com/
    position: Web Application Developer
    dates:    [ Jul 2009, Sept 2010 ]
    bullet-points:
    - Developed and maintained large web applications in Ruby on Rails and
      object-oriented PHP
    - Designed and implemented a Ruby client for a complex third-party API
    - Profiled and optimized complex queries on databases with tens of millions
      of records
    - Worked directly with clients for whom an hour's downtime equaled
      thousands of dollars in lost revenue
  
  - company:  Digital Artefacts
    url:      http://digitalartefacts.com/
    position: Software Developer
    dates:    [ Oct 2008, Jul 2009 ]
    bullet-points:
    - Designed and implemented a system for uploading and manipulating
      (cropping, rotating) images, initially in Flash with a PHP backend, then
      again in JavaScript and ASP.NET/C#.
    
  - company:  Tucows
    url:      http://tucows.com/
    position: Tutorial Writer, Screencaster
    dates:    [ Feb 2007, Sept 2008 ]
    bullet-points:
    - Wrote, recorded, and produced 26 short form how-to screencasts (ex. [1],
      [2], [3], [4]) for Tucows' [Butterscotch.com][5] in one month on
      accomplishing common and time-saving tasks on Windows and the web
    - Wrote dozens of [instructional articles][6] on using software and
      understanding computing concepts, from backing up browser settings
      to making time-lapse movies
    links:
      1: http://butterscotch.com/tutorial/How-To-Manage-The-Windows-Vista-Firewall
      2: http://butterscotch.com/tutorial/How-To-Defrag-Your-Hard-Drive-In-Windows-Vista
      3: http://butterscotch.com/tutorial/How-To-Download-And-Install-Mozilla-Firefox
      4: http://butterscotch.com/tutorial/Using-Windows-Defender-To-Get-Rid-Of-Spyware
      5: http://butterscotch.com/
      6: http://www.tucows.com/articles/author/jrunning
    
  - company:  Weblogs, Inc. / AOL
    url:      http://weblogsinc.com/
    position: Lead Blogger
    dates:    [ Mar 2005, Feb 2007 ]
    bullet-points:
    - Managed the [Download Squad][1] blog, building and
      supervising a team of more than a dozen bloggers and growing traffic
      from zero to more than 1.5 million monthly pageviews
    - Wrote and published [thousands of blog posts][2] on all topics relating to
      software and web applications
    - Contributed extensively to internal documentation and technical
      discussions
    links:
      1: http://downloadsquad.com/
      2: http://downloadsquad.com/bloggers/jordan-running
  
  education:
  - institution:  Cornell College
    url:          http://cornellcollege.edu/
    location:     Mt. Vernon, Iowa
    years:        [ 2000, 2005 ]
    degree:       BA in Computer Science, Art
    details:
      Coursework including software design, systems software, data management
      systems, and progamming language concepts (including functional
      programming, virtual machines, and declarative languages)
  
  web:
  - title:      @swirlee on Twitter
    url:        http://twitter.com/swirlee
  - title:      jrunning on GitHub
    url:        http://github.com/jrunning
  - title:      JordanRunning.com
    url:        http://jordanrunning.com/
  - title:      LinkedIn
    url:        http://linkedin.com/in/jordanrunning
  - title:      Stack Overflow
    url:        http://careers.stackoverflow.com/jordan

  interests: [  geolocation, mobile computing,
                web standards (current and emerging),
                microformats, machine vision, typography and design,
                blogging and new media, open source, photography, art
             ]
}

require 'yaml'
require 'erb'
  
class ResumeRenderer
  attr_reader :content
  
  def initialize content
    @content = YAML::load content
  end
  
  def to_html template
    ERB.new(template).run binding
  end

  private
    def format_dates(format, dates)
      dates.map { |date|
        case date
          when 'Present' then date
          else Date.parse(date).strftime format
        end
      }.join '&ndash;'
    end
    
    # Replace [Markdown-style links][1] with HTML links (naive!)
    def l(text, links)
      if links
        text.gsub!(/\[([^\]+]*)\]\[([0-9])\]/, '<a href="%\2%">\1</a>')
        text.gsub!(/\[([0-9])\]/, '<a href="%\1%">\1</a>')
        links.each {|key, url| text.gsub!("%#{key}%", url) }
      end
      
      text
    end
    
    def method_missing meth
      @content[meth.id2name] || super    
    end
    
    def respond_to? meth
      !@content[meth.id2name].nil? || super
    end
end

resume = ResumeRenderer.new jordan_running
resume.to_html DATA.read

# TEMPLATE:
__END__
<!DOCTYPE html>
<html>
  <head>
    <title><%= details['name'] %> - <%= details['email'] %> - Resume</title>
    <link href="http://fonts.googleapis.com/css?family=Shanti:regular"
      rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="css/lib/reset.css" type="text/css" />
    <link rel="stylesheet" href="css/lib/ribbon.css" type="text/css" />
    <link rel="stylesheet" href="css/resume.css" type="text/css" />
    <link rel="profile" href="http://microformats.org/profile/hcard">
    <link rel="me" type="text/html"
      href="http://www.google.com/profiles/jrunning"/>
  </head>
  <body class="vcard">
    <section id="top" class="clearfix adr">
      <header>
        <h1 class="fn"><%= details['name'] %></h1>
        <h2><%= details['tagline'] %></h2>
      </header>
      <p><a href="mailto:<%= details['email'] %>" class="email">
          <%= details['email'] %>
        </a>
        <span class="tel">(920) 737-9440</span>
      </p>
    </section>

    <section id="experience">
      <h2>Experience</h2>
      
      <ul>
      <% experience.each do |job| %>
        <li>
          <header>
            <p class="dates"><%= format_dates('%B %Y', job['dates']) %></p>
            <h3><% if job['url'] %>
              <a href="<%= job['url'] %>" target="_blank">
              <%= job['company'] %></a>
            <% else %>
              <%= job['company'] %>
            <% end %>
            <% if job['location'] %>
              <span><%= job['location'] %></span>
            <% end %>
            </h3>
            <p><%= job['position'] %></p>
          </header>
        
        <% if job['bullet-points'] %>
          <ul class="bullet-points">
          <% job['bullet-points'].each do |point| %>
            <li><%= l(point, job['links']) %></li>
          <% end %>
          </ul>
        <% end %>
        </li>
      <% end # job %>
      </ul>
    </section>
    
    <section id="education">
      <h2>Education</h2>
      
      <ul>
      <% education.each do |school| %>
        <li>
          <header>
            <p><span class="dates"><%= school['years'].join '&ndash;' %></p>
            <h3><a href="<%= school['url'] %>" target="_blank">
                <%= school['institution'] %></a>
              <span><%= school['location'] %></span>
            </h3>
            <p><%= school['degree'] %></p>
          </header>
          <ul class="bullet-points"><li><%= school['details'] %></li></ul>
        </li>
      <% end %>
      </ul>
    </section>
    
    <section id="web">
      <h2>On the Web</h2>
      
      <ul class="clearfix">
      <% web.each do |site| %>
        <li><a href="<%= site['url'] %>" class="url" rel="me">
          <%= site['title'] %>
        </a></li>
      <% end %>
      </ul>
    </section>
    
    <section id="interests">
      <h2>Interests</h2>
      <p><%= interests.join(', ').capitalize + '.' %></p>
    </section>
    
    <section id="bottom" class="clearfix adr">
      <p><a href="mailto:<%= details['email'] %>"><%= details['email'] %></a>
        <span class="locality"><%= details['location'] %></span>
        <span class="phone"><%= details['phone'] %></span>
      </p>
    </section>
    <a id="myribbon" href="http://github.com/jrunning/Resume"
      class="gray ribbon right top" target="_blank">
      <span class="text">Fork me on GitHub</span>
    </a>
  </body>
</html>
