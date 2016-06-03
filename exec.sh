# Date d'exécution
execTime='['`date +%H:%M:%S`'] '

# Délai entre deux éxecutions
delay=1

# Stockage des images téléchargées
imgPath='./images/';

# Nombre d'images conservées
keepImages=3;

# Fichier contenant le nom de l'image la plus récente
currentImgTrackerFile='./currentImg.txt'

# Initialisation de la connexion avec l'apn
gphoto2 --auto-detect > /dev/null

# Let's go !
echo $execTime"Connexion établie avec l'APN, let's shoot !"

# Création du fichier de tracking
if [ ! -e "$currentImgTrackerFile" ]
then
    touch $currentImgTrackerFile
fi
> $currentImgTrackerFile

while true
do
    execTime='['`date +%H:%M:%S`'] '
    echo $execTime"-- Start --"

    while read -r line; do 
        filename=`echo $line | sed 's/^.* \(.*.JPG\) .*/\1/'`
        range=`echo $line | sed 's/^#\([0-9]*\) .*/\1/'`
        lastImgOnCamera=$filename
    done < <(gphoto2 -L | grep ".JPG")


    # Présence d'images sur l'apn
    if [ ! -z "$lastImgOnCamera" ];
    then
        currentImgTracker=`cat $currentImgTrackerFile`  
        if [ "$currentImgTracker" != "$lastImgOnCamera" ];
        then
            echo 'GO DL : '$lastImgOnCamera
            rm -rf ./*.JPG
            printf "n\nn" | gphoto2 -p $range > /dev/null
        fi
    fi

    echo $lastImgOnCamera > $currentImgTrackerFile

    sleep $delay
done

