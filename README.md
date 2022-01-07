# gitftputil
1. Requires [git-ftp](https://git-ftp.github.io/)
2. Server configs are encrypted with AES using 7z
2. Put `gitftputil.sh` in your path as `gitftputil`
3. Configure a server to push to using `gitftputil mk s <server nickname>`
4. From a git repository, configure a location on the server to push to using `gitftputil mk d <deployment nickname>`
5. Execute git-ftp commands using `gitftputil <deployment nickname>`