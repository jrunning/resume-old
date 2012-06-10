#!/usr/bin/env ruby

require 'yaml'
require 'erb'

class ResumeRenderer
  attr_reader :content, :template

  def initialize data
    @content  = YAML::load data
    @template = @content.delete 'TEMPLATE'
  end

  def to_html template=nil
    ERB.new( template || @template ).result binding
  end

  private
    def format_dates format, dates
      dates.map do |date|
        case date
          when 'Present' then date
          else Date.parse(date).strftime format
        end
      end.join '&ndash;'
    end

    # Replace [Markdown-style links][1] with HTML links (naive!)
    def l text, links
      if links
        text.gsub! /\[([^\]+]*)\]\[([0-9])\]/,  '<a href="%\2%">\1</a>'
        text.gsub! /\[([0-9])\]/,               '<a href="%\1%">\1</a>'
        links.each {|key, url| text.gsub! "%#{key}%", url }
      end

      text
    end

    def method_missing meth
      @content[ meth.id2name ] || super
    end

    def respond_to? meth
      !@content[ meth.id2name ].nil? || super
    end
end

resume = ResumeRenderer.new DATA.read

if ARGV.empty? || ARGV.first == '-'
  $stdout
else
  File.open( ARGV.shift, 'w' )
end << resume.to_html

__END__
--- %YAML:1.0  # DATA
details:
  name:     Jordan Running
  email:    jr@jordanrunning.com
  phone:    (925) 567-3267
  location: Iowa City, Iowa
  tagline:  Web application developer specializing in Ruby on Rails
            and JavaScript

experience:
- company:  Independent Contractor
  position: Web Application Developer
  dates:    [ Oct 2010, Present ]
  bullet points:
  - Architected and implemented a complex registration wizard for merchant
    services customers for a client of [Tag Creative Studio][1]. As the sole
    back-end developer, built the Ruby on Rails- and MySQL-backed five-step
    workflow with more than 70 fields and strict, interdependent validations
    for each.

  - Implemented from precise specification a Node.js application for
      initializing, managing and communicating with instances of other Node.js
      applications as requested by remote clients. The application is modular,
      allowing new types of application instances to be supported while
      maintaining strict separation between components.

  - Developed a web frontend and Node.js backend for a Redis-backed
    English-Spanish translation database for [Componica, LLC][2].

  - Designed and prototyped a social networking and live chat system in Ruby
    on Rails, backed by MySQL and Redis. The product users to be "paired"
    according to several attributes, for which Redis' fast set operations were
    an excellent match.

  links:
    1: http://tagcreativestudio.com/
    2: http://componica.com/

- company:  Cramer Development
  url:      http://cramerdev.com/
  position: Web Application Developer
  dates:    [ Jul 2009, Sept 2010 ]
  bullet points:
  - Developed and maintained large, public-facing web applications and
    e-commerce sites in Ruby on Rails and object-oriented PHP.

  - Designed and implemented a Ruby client for a complex third-party API which
    gathered search engine data for [DIYSEO.com][1].

  - Profiled and optimized complex queries on databases with tens of millions
    of records.

  - Worked directly with clients for whom an hour's downtime equaled
    thousands of dollars in lost revenue.

  links:
    1: http://diyseo.com/

- company:  Digital Artefacts
  url:      http://digitalartefacts.com/
  position: Software Developer
  dates:    [ Oct 2008, Jul 2009 ]
  bullet points:
  - Designed and implemented a system for uploading and manipulating
    (cropping, rotating) images, initially in Flash with a PHP backend, then
    again in JavaScript and ASP.NET/C#.

other experience:
- company:  Busy Coworking
  url:      http://busycoworking.com/
  position: Cofounder
  dates:    [ Apr 2012, Present ]
  bullet points:
  - Opened Iowa City's first and only coworking space, now flourishing at
    218 E. Washington St. downtown.

- company:  Tucows
  url:      http://tucows.com/
  position: Tutorial Writer, Screencaster
  dates:    [ Feb 2007, Sept 2008 ]
  bullet points:
  - Wrote, recorded, and produced 26 short form how-to screencasts (ex. [1],
    [2], [3], [4]) for Tucows' [Butterscotch.com][5] in one month on
    accomplishing common and time-saving tasks on Windows and the web.
  - Wrote dozens of [instructional articles][6] on using software and
    understanding computing concepts, from backing up browser settings
    to making time-lapse movies.

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
  bullet points:
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
- title:      jrunning on GitHub
  url:        http://github.com/jrunning
- title:      LinkedIn
  url:        http://linkedin.com/in/jordanrunning
- title:      Stack Overflow
  url:        http://careers.stackoverflow.com/jordan

interests: [  mobile computing, web standards (current and emerging) and
              microformats, typography and design, web curation, blogs and new
              media, nontraditional modes of working, open source, Vim,
              photography, art, baking
           ]

TEMPLATE: |- # TODO Add hResume microformat: http://microformats.org/wiki/hresume
  <!DOCTYPE html>
  <html>
    <head>
      <title><%= details['name'] %> &emdash; <%= details['email'] %> &emdash; Resume</title>
      <link rel="stylesheet"
        href="http://fonts.googleapis.com/css?family=Lato:300,300italic,400,400italic,900italic">
      <link rel="stylesheet" href="css/lib/reset.css">
      <link rel="stylesheet" href="css/lib/ribbon.css">
      <link rel="stylesheet" href="css/resume.css">
      <link rel="profile" href="http://microformats.org/profile/hcard">
      <link rel="me" type="text/html"
        href="http://www.google.com/profiles/jrunning">
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
          <a class="tel" href="tel:+1<%= details['phone'].gsub /[^0-9]/, '' %>"><%= details['phone'] %></a>
        </p>
      </section>

    <% [ 'experience', 'other experience' ].each do |experience| %>
      <section id="<%= experience.gsub ' ', '-' %>">
        <h2><%= experience.capitalize %></h2>

        <ul>
        <% send( experience ).each do |job| %>
          <li>
            <header>
            <% if job['dates'] %>
              <p class="dates"><%= format_dates('%B %Y', job['dates']) %></p>
            <% end %>
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

          <% if job['bullet points'] %>
            <ul class="bullet-points">
            <% job['bullet points'].each do |point| %>
              <li><%= l(point, job['links']) %></li>
            <% end %>
            </ul>
          <% end %>
          </li>
        <% end %>
        </ul>
      </section>
    <% end %>

      <section id="education">
        <h2>Education</h2>

        <ul>
        <% education.each do |school| %>
          <li>
            <header>
              <p><span class="dates"><%= school['years'].join '&#8202;&ndash;&#8202;' %></p>
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
        <h2>On the web</h2>

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
        <a class="email" href="mailto:<%= details['email'] %>"><%= details['email'] %></a>
        <a class="phone" href="tel:+1<%= details['phone'].gsub /[^0-9]/, '' %>"><%= details['phone'] %></a>
        <span class="locality"><%= details['location'] %></span>
      </section>
      <a id="myribbon" href="http://github.com/jrunning/Resume"
        class="gray ribbon right top" target="_blank">
        <span class="text">Fork me on GitHub</span>
      </a>

      <script type="text/javascript">
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', 'UA-23720675-1']);
        _gaq.push(['_trackPageview']);

        (function() {
          var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
          ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
          var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
        })();

        // Shenanigans
        var els, numEls, incr, ribbonColor, i = 0
        , currentColor = [ 22,  4, 18 ], endColor = [  0, 24, 10 ]
        ;

        if( document.querySelectorAll ) {
          ribbonColor = document.querySelector('.ribbon').style.color;
          els = document.querySelectorAll( '*:not(.ribbon)' );
          if( els.length ) {
            el = els[i];
            while( el.tagName != 'BODY' ) { el = els[ ++i ]; }
            numEls = els.length - i;

            incr  = [ ( endColor[0] - currentColor[0] ) / numEls
                    , ( endColor[1] - currentColor[1] ) / numEls
                    , ( endColor[2] - currentColor[2] ) / numEls
                    ];

            for(; i < els.length; i++ ) {
              els[i].style.color = "rgb(" +
                ( currentColor[0] += incr[0] ) + "%," +
                ( currentColor[1] += incr[1] ) + "%," +
                ( currentColor[2] += incr[2] ) + "%)"
              ;
            }

            // kludge
            document.querySelector( "#myribbon *" ).style.color = ribbonColor;
          }
        }
      </script>
    </body>
  </html>
