#!/bin/bash
cd /home/ubuntu/react-chart/
aws s3 cp s3://testuploadbucket0/old_value.txt .
aws s3 cp s3://testuploadbucket0/new_value.txt .
old_value=$(cat old_value.txt)
new_value=$(cat new_value.txt)
sed -i "s/${old_value}/${new_value}/g" values.yaml
helm upgrade react-chart .
aws s3 rm s3://testuploadbucket0/old_value.txt
echo $new_value > old_value.txt
aws s3 cp old_value.txt s3://testuploadbucket0/
rm old_value.txt new_value.txt
