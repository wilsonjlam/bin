utility
=======

Some of my settings and scripts for storage and sharing purposes

pull this first: https://gist.github.com/39cc41a9837e7de42258.git
run pull_config.sh to setup root tracking with git info in folder

8/19/2016: Set up with TJ's vim and dot files
	-https://github.com/tjbearse/utility
		(not pulled: https://github.com/tjbearse/bin)
		-cloned the repo to ~/utility
	-downloaded and ran Vundle to install plugins
	-ran ~/utility/install/links.sh
	-brew install macvim --override-system-vim; brew linkapps
		(installed and overrode system vim with macvim)
	-go to valloric/youcompleteme -- run the install.py in ~/.vim/bundle/YouCompleteMe
	-npm install -g jshint
	-install git completion: https://github.com/bobthecow/git-flow-completion
	-hybrid:
		-foreground in iterm should be 8a8a8a
		-selection should be c5c8c6
		-selected text should be 1562c3
	-airline
	-install avn
	-brew install tree
	-typescript:
		-need the vim plugins 
		-need to npm install typescript
		-need to npm install typscript-eslint-parser

NVM
> You currently have modules installed globally with `npm`. These will no
=> longer be linked to the active version of Node when you install a new node
=> with `nvm`; and they may (depending on how you construct your `$PATH`)
=> override the binaries of modules installed with `nvm`:

/usr/local/lib
├── avn@0.2.3
├── avn-n@0.2.0
├── avn-nvm@0.2.1
├── bower@1.8.2
├── grunt@1.0.1
├── grunt-cli@1.2.0
├── gulp-cli@1.2.2
├── istanbul@0.4.5
├── jscodeshift@0.3.30
├── jsonlint@1.6.2
├── karma-cli@1.0.1
├── node-inspector@0.12.8
├── nodemon@1.10.0
├── pf-e2e-tests-model@2.0.22 -> /Users/WilsonL/qualtrics/pf_e2e_tests_model
├── pf_e2e_tests@2.0.0 -> /Users/WilsonL/qualtrics/pf_e2e_tests
├── qsurveylookup@0.2.0
├── ripsaw-cli@0.12.0
├── typescript@2.6.1
├── typescript-eslint-parser@9.0.1
├── webpack@2.2.1
└── yarn@1.2.1
=> If you wish to uninstall them at a later point (or re-install them under your
=> `nvm` Nodes), you can remove them from the system Node as follows:

     $ nvm use system
     $ npm uninstall -g a_module
