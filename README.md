# batchtapaper

Got a long list of URLs that you need to get into your
[Instapaper](http://www.instapaper.com/) account? Batchtapaper is
probably what you're looking for.

You'll often encounter things like Byliner's wonderful [curated
end-of-year lists of
articles](http://byliner.com/spotlights/102-spectacular-nonfiction-articles-2012).
I want to read all of them, but I don't want to have to add each one of
them to my Instapaper account manually; so, I use Batchtapaper.

## Usage

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

