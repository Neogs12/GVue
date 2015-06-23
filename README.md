# GVue
Google Drive for linux GUI

Optional personal cloud support?

Git Repository support would be nice.

prompt user for superuser password
-echo "password"|sudo -S installer -pkg /YOURDIRECTORY -target / 

:Pass chmod 755 [appnamehere] to term to allow for read,write,execute perms.

Shell Script to auto install required libraries/repositories. Prompts for admin pass?

Custom Icon images for different file types.

Auto-update capabilities. (on/off)

Drag and drop to gui to store in local repository for sync.

Needs to grab repositories using the term.

:Grabbing google Drive
-sudo apt-get install golang git mercurial
-go get github.com/rakyll/drive

:Initiallizing google Drive
-drive init
--Asks for local Directory to store files.
--Asks for authentication code, posts web address.
-input Auth code

:Using google Drive
-push, pushes file to server.
-pull, pulls file to computer.

TEST
