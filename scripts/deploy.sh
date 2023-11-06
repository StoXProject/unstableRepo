#!/bin/bash

echo "We have $PKG_REPO"

# Set path to fix Rtools 4.0 in Appveyor
PATH=/usr/bin:$PATH

set -o errexit -o nounset
cd ..

addToDrat(){
    
    # This codition applies to pre-releases on the unstableRepo and the testingRepo, and to official releases on the repo:
    if [ "${PRERELEASE}" = true ]; then
        
        mkdir drat; cd drat

        ## Set up Repo parameters
        git init
        git config user.name "StoXProject bot"
        git config user.email "stox@hi.no"
        git config --global push.default simple
        
        ## Get drat repo that we are in, so we know where we are (could this step be avoided?):
        git remote add upstream "https://x-access-token:${DRAT_DEPLOY_TOKEN}@github.com/StoXProject/unstableRepo.git"

        git fetch upstream 2>err.txt
        git checkout gh-pages
        
        echo "We have $PKG_REPO"
        
        # Running Rscript with single expressions is required for R 4.3 on Windows, so we do that:
        if [ "${DEPLOY_SRC+x}" = x ]; then
        Rscript -e "install.packages('remotes', repos = 'https://cloud.r-project.org')"
        Rscript -e "remotes::install_github(repo = 'eddelbuettel/drat', dependencies = FALSE"
        Rscript -e "if(require(drat)) drat::insertPackage('$PKG_REPO/drat/$PKG_TARBALL', repodir = '.', \
            commit='Repo update $PKG_REPO: build $TRAVIS_BUILD_NUMBER', OSflavour = R.Version()[['platform']])"
        Rscript -e "if(require(drat)) drat::updateRepo('.')"
        fi
        
        if [ "${TRAVIS_BUILD_NUMBER+x}" = x ]; then
        export BUILD_NUMBER=$TRAVIS_BUILD_NUMBER
        else
        export BUILD_NUMBER=$APPVEYOR_BUILD_NUMBER
        fi
        
        # Running Rscript with single expressions is required for R 4.3 on Windows, so we do that:
        Rscript -e "if(require(drat)) drat::insertPackage('$PKG_REPO/drat/$BINSRC', \
            repodir = '.', commit='Repo update $PKG_REPO: build $BUILD_NUMBER')"
        Rscript -e "if(require(drat)) drat::updateRepo('.')"
        
        git push 2>err.txt
        
    fi
  

}

addToDrat

cd $PKG_REPO
