#wget -O SkinnyTasteR.html https://www.skinnytaste.com/white-chicken-chili/
#grepout=$(grep -ia "print" SkinnyTasteR.html | grep -Eo 'href=\"https?:\/\/[^"]+\"'| grep -Eo '\"https?:\/\/[^"]+\"')
#temp="${grepout%\"}"
#echo $temp
#recipeurl="${temp#\"}"
#echo $recipeurl
#wget -O SkinnyRecipeFinal.html $recipeurl
#./extract1.sh https://www.skinnytaste.com/chicken-florentine/

#url1="https://www.skinnytaste.com/chicken-florentine/#recipe"


#tempURL="${url1#*www.}"
#echo $tempURL
#echo " The basename is ${url1##*/}"
#echo "${tempURL%.*}"
#tempURL="${tempURL%*.com*}"
#echo $tempURL

#if [[ $url1 == *".com"* ]];
#then 
#    echo "Truth"
#fi

#if [[ $url1 == *".com"* ]];
#then 
#    websiteName="${tempURL%*.com*}"
#    echo $websiteName
#else
#    echo "URL was not a '.com'"
#    exit 2
#fi

#Recipes used:
#https://www.skinnytaste.com/healthy-baked-fish-sticks-with-lemon/
#https://www.skinnytaste.com/chicken-florentine/

./extract_scripts/retrieveURL.sh https://www.budgetbytes.com/ham-and-cheese-sliders/
status=$?
echo $status
if [[ $status -ne 0 ]];
then
    exit $status
fi

./extract_scripts/retrieveURL.sh https://www.skinnytaste.com/healthy-baked-fish-sticks-with-lemon/
if [[ $? -ne 0 ]];
then
    exit 1
fi
./extract_scripts/retrieveURL.sh https://www.skinnytaste.com/chicken-florentine/
if [[ $? -ne 0 ]];
then
    exit 1
fi