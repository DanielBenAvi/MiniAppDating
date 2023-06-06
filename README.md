# Dating

## About
A Miniapp in A collection in Superapp.
The dating mini app is a platform invented to allow the users to maintain their love life and develop them. 
This app gives the user the opportunity to connect with other users who match the criteria based on their hobbies and gender preferences. 
The app will be presented as a feed, where the user will be exposed to other user's bio with potential matches. 
User A has a choice to like user B based on his bio. Once both users “like” each other a “match” will occur. Following the match, the users will be able to talk to each other via chat.


## Technologies
1. Flutter - client
2. Spring boot - server
3. MongoDB - database
4. FireBase - store images

## Client contributers
1. Daniel Ben-Avi
2. Ido Ben Yaakov

## How to install in Linux afeka machine
### Mongo

1. In command line

	``` bash
	docker run --name my-mongo-container -p27017:27017 -d mongo:latest
	docker exec -it my-mongo-container mongosh
	```

### Server

1. Extract "projectName".zip file
2. open STS
	- File -> open project from file system.
	- Find project folder.
	- Click finish
	- Right click on the project -> configure -> add gradle nature and wait until finish downloading
	- Right click on project/src/main/java/aplication.java -> Run As -> java application

### Client

1. Open new terminal window
2. Install flutter:

	```bash
	sudo snap install flutter --classic
	```

3. Install vs code:

	``` bash
	sudo snap install code --classic
	```

4. Extact  "flutterProjectName".zip
5. open terminal in extracted folder
6. open in vs code:

	```bash
	code .
	```

7. Install flutter package in vs code.
8. In terminal in projsect root folder run and wait

	``` bash
	flutter run get
	```

9. Make sure that in the right left corner in vs code chrome is showen
10. Open folder home/snap/flutter/common/flutter/packages/flutter_tools/lib/src/web
11. In chrome.dart in after line 201 add

	```txt
	'--disable-web-security',
	```

12. Delete file home/snap/flutter/commom/flutter/bin/cache/flutter_tools.stamp
13. From root project directory run the following bash command

	```bash
	chmod +x starter.sh
	sed -i -e 's/\r$//' starter.sh
	./starter.sh
	```

14. Go to \lib\main.dart
15. In main.dart click Run