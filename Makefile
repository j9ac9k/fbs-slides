make get-reveal:
	wget https://github.com/hakimel/reveal.js/archive/master.tar.gz +
	tar -xzvf master.tar.gz +
	mv reveal.js-master reveal.js

slides: ## create slides
	/usr/local/bin/pandoc slides.md \
		--css="./css/style.css" \
		--standalone \
		--slide-level=2 \
		-t revealjs \
	  	-V revealjs-url=./reveal.js \
	  	-V theme=white \
	  	-V width=1024 \
		-o slides.html \

