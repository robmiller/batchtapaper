# batchtapaper

Got a long list of URLs that you need to get into your
[Instapaper](http://www.instapaper.com/) account? Batchtapaper is
probably what you're looking for.

You'll often encounter things like Byliner's wonderful [curated
end-of-year lists of
articles](http://byliner.com/spotlights/102-spectacular-nonfiction-articles-2012).
I want to read all of them, but I don't want to have to add each one of
them to my Instapaper account manually; so, I use Batchtapaper.

## Installation

You can install batchtapaper using RubyGems:

	% gem install batchtapaper

## Usage

The simplest way to use batchtapaper is to point it at a file containing
some URLs:

	% batchtapaper /path/to/urls.txt

Enter your Instapaper username and password when prompted, and it should
fly away and add them one-by-one to your account.

The text file you pass to batchtapaper should have one URL on each line,
like so:

	http://example.com/article
	http://blog.example.org/2013/01/foo

However, you can also specify titles if you wish by separating them from
the URLs with a tab:

	http://example.com/article	An Article
	http://blog.example.org/2013/01/foo	A blog post

## Advanced usage

### Storing authentication details

If you use batchtapaper quite a lot, one of the first things you'll want
to do is to create an `~/.instapaperrc` file containing your
authentication details. All you need to do is put your username/email
address on the first line and your password — if you have one — on the
second, like so:

	foo@example.com
	p4ssw0rd

It's worth setting this file's permissions to `400` if you share your
computer with anyone else.

### Integration with other services

batchtapaper will also accept input from `STDIN`, which means that you
can use it in an ordinary chain of commands. If you've got something
that spits out URLs, then simply pipe that output into batchtapaper and
it will process them all:

	cat urls.txt | batchtapaper

