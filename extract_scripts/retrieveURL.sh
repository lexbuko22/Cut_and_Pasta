#!/bin/bash
# Script:
#  retrieveURL.sh
#
# Purpose:
#   Validates and retireve the URL and puts it into a html file within directory
#
# Inputs:
#   Initial URL
#
# Outputs:
#   extracted html file
#
# Notes:
#   using h1 markers to find recipe title
#
# Exits
#   0 = success
#   1 = bad url
#   2 = bad grep 
#    
# Changelog:
#    Date (MM-DD-YYYY)     Name      Change Description
#    02-15-2024            EDonkus   Initial Creation
#
#------------------------------------------------------------------
#------------------------------------------------------------------
DEBUG=1
# Only echoes if debug is turned on
decho () {
    if [[ $DEBUG == 1 ]];
    then
        echo $1
        echo ""
    fi
}


#-------------------
# Take input and give name
#-------------------
inputurl=$1

#------------------
# Valid Flag
# --spider puts wget into a check mode rather download
# -q = silent mode
#------------------
validurl_flag=$(wget --spider -q $inputurl)

#------------------
# If the weblink is good download to temp file
#------------------
if [[ ! $validurl_flag ]];
then
    wget -q -O temp.html $inputurl
else
    decho "Bad URL"
    exit 1
fi

#---------------
# Grep for the Recipe Title
#---------------
grepTitle=$(grep -Eo '<h1.*\/h1>*' temp.html | grep -Eo '>.*<\/h1')

#---------------
# if grep can't find h1 markers, then we exit with bad staus
#---------------
if [[ ! $grepTitle ]];
then
    decho "Couldn't find header"
    exit 2
fi

#--------------
# Remove characters surrounding title and replace spaces with '_'
#--------------

decho $grepTitle

#Finds and removes '>' from previous grep
tempTitle="${grepTitle/>/}"
decho "TEMP Title: $tempTitle"

# Finds and removes '</h1' from previous grep
tempTitle2="${tempTitle/<\/h1/}"
decho "TEMP2 title: $tempTitle2"

# Replaces spaces with '_'
finalTitle="${tempTitle2// /\_}"
decho "Final: $finalTitle"

#-----------------
# Get just the name of website xyz in www.xyz.com
#-----------------
decho "Input: $inputurl"
tempURL="${inputurl#*www.}"
decho "Shortened: $tempURL"

# Since we stripped all leading characters before base name
# We should be able to get the basenaem up to .com ending piece
websiteName="${tempURL%.*}"


#-----------------
# Verify that file does not exist in heirarchy
#-----------------
#Hallee:heirarchy
    #ingredients based off print page

#-----------------
# Move temp.html to finalTitle.html, and under appropiate hierarchy structure
#-----------------
rawHTML="$websiteName/$finalTitle/${finalTitle}_raw.html"
decho "RAWHTML: $rawHTML"

decho "Moving raw HTML to subdir $websiteName/$finalTitle/"

#VVVV---STUB---VVVV#
mkdir -p $websiteName/$finalTitle/
#^^^^---STUB---^^^^#

mv temp.html $rawHTML

recipeHTML="${finalTitle}_recipe.html"
decho "Retreiving print Directory from website"

#------------------
# wprm_print = WordPress Recipe Maker
# Looks to be a fairly common plugin 
#--------------------
grepout=$(grep -ia "wprm_print" $rawHTML | grep -Eo 'href=\"https?:\/\/[^"]+\"'| grep -Eo '\"https?:\/\/[^"]+\"')
echo "grepout: $grepout"
if [[ ! $grepTitle ]];
then
    decho "Couldn't find print url"
    exit 2
fi

#Trims leading quote
temp="${grepout%\"}"
decho "TEMP: $temp"

#Trims trailing quote
recipeurl="${temp#\"}"
decho "RecipeURL: $recipeurl"

#------------------
# Validate print url. Should be good if grep worked
#------------------
validurl_flag=$(wget --spider -q $recipeurl)

#------------------
# If the weblink is good download to temp file
#------------------
if [[ ! $validurl_flag ]];
then
    recipePath="$websiteName/$finalTitle/$recipeHTML"
    wget  -O $recipePath $recipeurl
else
    decho "Bad print URL"
    exit 1
fi

echo "Extraction Complete"
exit 0