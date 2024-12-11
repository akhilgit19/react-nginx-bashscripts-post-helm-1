#!/bin/bash
sudo docker container prune -f && sudo docker image prune -a -f && sudo docker volume prune -f && sudo docker network prune -f && sudo docker system prune -a -f
##this above step is not recommned step, i am deleting existing images to save space
sudo rm -r gold
sudo mkdir gold
cd gold/
sudo git clone https://github.com/akhilgit19/Gold_Site_Ecommerce-1.git
cd Gold_Site_Ecommerce-1
git_commit=$(sudo git rev-parse HEAD)
##if you are doing for the first time install node and npm
##sudo apt install nodejs 
##sudo apt install npm
sudo npm install react-scripts
sudo npm run build
sudo chmod 777 build
current_date=$(date +%d%m%Y)
aws s3api put-object --bucket testuploadbucket01 --key "${current_date}/"
aws s3 cp --recursive build "s3://testuploadbucket01/${current_date}/$(basename build)"
sudo docker build -t react-nginx:$git_commit -f golddockerfile1 .
sudo docker tag react-nginx:$git_commit akhilpagadapoola/react-nginx:$git_commit ##make sure you did docker login
# sudo touch image_vulnerability.txt
# sudo chmod 777 image_vulnerability.txt
# trivy image akhilpagadapoola/react-nginx > image_vulnerability.txt
# /home/ubuntu/slack.sh
# echo "Please find the attached Trivy file file." | mutt -s "Image Vulnerability" -a image_vulnerability.txt -- akhilpagadapoola123@gmail.com
sudo docker push akhilpagadapoola/react-nginx:$git_commit
aws s3 rm s3://testuploadbucket01/new_value.txt
sudo touch new_value.txt
sudo chmod 777 new_value.txt
sudo echo $git_commit > new_value.txt
aws s3 cp new_value.txt s3://testuploadbucket01/
sudo rm new_value.txt
