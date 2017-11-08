## Vivaldi BASH Installer

**CAUTION**: This code is provided AS-IS with NO warranties or guarantees.  The code worked great in my environment.

You are free to review the code to see what it is doing and make any changes.  Still you are responsible for YOUR system(s).  It is my hope it does aid you in saving time and effort.  Good luck.

There are two files brought over from GIST:

1) **vivaldi-debian-bash.sh** => Is for Debian based Linuxes running on 64-bit hardware

2) **vivaldi-general-bash.sh** => Is for Debian and RPM based Linuxes running on 32 or 64-bit hardware

Both installers will download the latest version to your ~/Downloads/ from the Vivaldi repo (using curl), install it (using gdebi, yum, or dnf), and then remove the file.

I have used "vivaldi-debian-bash.sh" in my environment. However since I prefer Debian based desktop Linuxes I have NOT heavily tested "vivaldi-general-bash.sh".  I don't run 32-bit hardware or RPM based Linux desktops.  The checks were returning the correct files.  Do feel free to let me know should you encounter a problem and I'll see what I can do to fix the code.  Still NO guarantees are implied.

Also both scripts are written to run, on their own, after download, and execute permission set.  However, obviously, one could incorporate the code into a more extensive script or call it from another.

###Requirements:

1) **curl** - Required for both scripts

*Debian (Ubuntu) Based Linuxes:*
shell> **sudo apt-get install curl**

*RPM Linuxes:*
shell> **sudo yum install curl**
 -OR-
shell> **sudo dnf install curl**
  
2) **gdebi** (ONLY for Debian Based Linuxes)
shell> **sudo apt-get install gdebi**
