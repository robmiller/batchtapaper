require "faraday"
require "uri"
require "pry"

class Batchtapaper
  attr_reader :pages, :conn, :username, :password

  # A Page is a resource that we'll be adding to Instapaper.
  Page = Struct.new(:url, :title) do
    def valid_url?
      begin
        URI.parse(url)
      rescue URI::InvalidURIError
        return false
      end

      true
    end
  end

  # A Request is the actual request made to Instapaper, including the
  # response from the API.
  Request = Struct.new(:page, :"successful?")

  # This exception is raised when Batchtapaper is unable to find
  # authentication details in an rcfile, and is unable to get user input
  # from a TTY.
  class NoAuthError < StandardError; end

  def initialize(pages)
    @pages = Array(pages).map { |p| Page.new(p[:url], p[:title]) }

    @conn = Faraday.new(url: "https://www.instapaper.com") do |faraday|
      faraday.request :url_encoded
      faraday.adapter Faraday.default_adapter
    end

    auth = get_auth
    unless auth
      raise NoAuthError.new("Error: No authentication details available (no ~/.instapaperrc file and no TTY)")
    end

    @username = auth[:username]
    @password = auth[:password]
  end

  # Attempts to fetch authentication details, first from the
  # ~/.instapaperrc file (if it exists) and then from standard input. If
  # an rcfile doesn't exist and there's no TTY available (for example,
  # if you're piping input into this script) then it will return false.
  def get_auth
    # First, attempt to read usernames and passwords from the
    # ~/.instapaperrc file.
    auth = get_rcfile
    return auth if auth

    # Otherwise, prompt for it on the commandline
    if STDIN.tty?
      # If we do have a TTY (if the URLs are in a file), then we can prompt
      # the user for their auth details.
      begin
        print "Email or username: "
        username = STDIN.gets.chomp

        print "Password (if you have one): "
        # We don't want to echo input when the user is entering their
        # password, to prevent shoulder surfing; so, we disable the
        # terminal's echo temporarily.
        system 'stty -echo'
        password = STDIN.gets.chomp
        system 'stty echo'

        puts "\n\n"
      rescue NoMethodError, Interrupt
        # In case the user interrupts when typing their password, we don't
        # want to leave them with a terminal that isn't echoing.
        system 'stty echo'
        exit
      end

      return { username: username, password: password }
    end

    false
  end

  # Gets authentication from an rcfile in the user's home directory.
  def get_rcfile
    rcfile = File.expand_path("~/.instapaperrc")
    if File.exists?(rcfile)
      username, password = IO.read(rcfile).split("\n")
      return { username: username, password: password }
    end

    false
  end

  # Processes the URL queue, adding all of the URLs to Instapaper
  def process
    @pages.each do |page|
      next unless page.valid_url?

      request = add(page)

      yield(request) if block_given?
    end
  end

  # Adds a given URL to Instapaper
  def add(page)
    post = { username: username, password: password, url: page.url, title: page.title }.delete_if { |k, v| v.nil? }
    response = conn.post "/api/add", post

    successful = [200, 201].include?(response.status)
    page.title ||= response.headers["x-instapaper-title"]

    Request.new(page, successful)
  end

  class << self
    # Given a string formatted either as:
    #
    #   url
    #   url
    #   url
    #
    # or:
    #
    #   url   title
    #   url   title
    #
    # (i.e. url<TAB>title)
    #
    # Will return a new instance of Batchtapaper with the URLs from the
    # string.
    def from_string(string)
      urls = []
      string.each_line do |line|
        line.strip!

        # If the line contains a tab, then assume it's in "URL[tab]title" format
        if line =~ /\t/
          url, title = line.split("\t")
        else
          url = line
          title = nil
        end

        urls << { url: url, title: title }
      end

      Batchtapaper.new(urls)
    end
  end
end
