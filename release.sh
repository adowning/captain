#!/bin/bash
git add .
#!/bin/bash

#get highest tag number
VERSION=`git describe --abbrev=0 --tags`

#replace . with space so can split into an array
VERSION_BITS=(${VERSION//./ })

#get number parts and increase last one by 1
VNUM1=${VERSION_BITS[0]}
VNUM2=${VERSION_BITS[1]}
VNUM3=${VERSION_BITS[2]}
VNUM3=$((VNUM3+1))

#create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"

echo "Updating $VERSION to $NEW_TAG"

#get current hash and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT`

#only tag if no tag already (would be better if the git describe command above could have a silent option)
if [ -z "$NEEDS_TAG" ]; then
    echo "Tagged with $NEW_TAG (Ignoring fatal:cannot describe - this means commit is untagged) "
    git tag $NEW_TAG
    git push --tags
else
    echo "Already a tag on this commit"
fi

# current Git branch
branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

# v1.0.0, v1.5.2, etc.
versionLabel=$NEW_TAG
echo $versionLabel
echo $versionLabel
echo $versionLabel

# establish branch and tag name variables
devBranch=develop
masterBranch=master
releaseBranch=release-$versionLabel
 
# create the release branch from the -develop branch
git checkout -b $releaseBranch $devBranch
 
# file in which to update version number
versionFile="version.txt"
 
# find version number assignment ("= v1.5.5" for example)
# and replace it with newly specified version number
sed -i.backup -E "s/\= v[0-9.]+/\= $versionLabel/" $versionFile $versionFile
 
# remove backup file created by sed command
rm $versionFile.backup
 
# commit version number increment
git commit -am "Incrementing version number to $versionLabel"
 
# merge release branch with the new version number into master
git checkout $masterBranch
git merge --no-ff $releaseBranch
 
# create tag for new version from -master
git tag $versionLabel
 
# merge release branch with the new version number back into develop
git checkout $devBranch
git merge --no-ff $releaseBranch
 
# remove release branch
git branch -d $releaseBranch

echo $versionLabel

caprover deploy --default