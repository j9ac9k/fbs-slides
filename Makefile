make get-reveal:
	wget https://github.com/hakimel/reveal.js/archive/master.tar.gz +
	tar -xzvf master.tar.gz +
	mv reveal.js-master reveal.js

slides: ## create slides
	/usr/local/bin/pandoc -t revealjs -s -o slides.html slides.md -V revealjs-url=https://revealjs.com -V theme=beige -V height=900 -V width=1024 --resource-path=images

