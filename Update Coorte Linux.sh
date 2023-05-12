echo "Update Coorte Script by Messas"

read -e -p "Update Coorte-API? [y/n] ?: " -i "y" updateAPI

if [ "$updateAPI" == "y" ]; then

  read -e -p "Enter new API tag: " APITag

fi

read -e -p "Update Coorte-WEB? [y/n] ?: " -i "y" updateWEB

if [ "$updateWEB" == "y" ]; then

  read -e -p "Enter new WEB tag: " WEBTag

fi

if [ "$updateAPI" == "y" ]; then

  (
    echo cd coorte-api
    echo git fetch
    echo git checkout $APITag
    echo npm install
    echo npm run build
    echo pm2 restart 0
    echo pm2 list
  ) > apiCommands

  cat apiCommands

  ssh cloud@coortesz.com.br < apiCommands

else
  echo Skipping API
fi

if [ "$updateWEB" == "y" ]; then

  (
    echo cd coorte-api
    echo git fetch
    echo git checkout $WEBTag
    echo npm install
    echo npm run build:prod
    echo pm2 restart 0
    echo pm2 list
  ) > webCommands

  cat webCommands

  ssh cloud@coortesz.com.br < webCommands

else
  echo Skipping WEB
fi