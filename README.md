# rm_is_safe

`rm_is_safe` makes your rm command more safer.

![](E:\onedrive\blog_imgs\a13-1588658636362.gif)

# How it works

`rm_is_safe` creates a shell script named `/bin/rm` which replaces the native rm(at the same time, it will backup the native rm command to `/bin/rm.bak`). So, how do you use `rm`, how do you use `rm_is_safe`. 

`rm_is_safe` will check all arguments after `rm`, if arguments contains some important files, it will skip your rm command.

`rm_is_safe` is effective for all users(already exists or future newuser).

# Which file is important?

1. `/` and subfiles or subdirs under `/`, these files always be protected  
2. also you can specify important files in `/etc/security/rm_fileignore`, one file path one line. like below: 

    ```
    /home/junmajinlong
    /home/junmajinlong/apps
    ```

All files specified in this file will be protected, you can't detele them with `rm`.

**Notes:**  
1. Obviously, there is no recursion here. So, '/bin' is safe, but '/bin/aaa' is not safe in default  
2. Paths you defined in /etc/security/rm_fileignore can trail slashs, both '/home/junmajinlong' and '/home///junmajinlong/////' are valid  
3. Don't use wildcard in the paths you defined in /etc/security/rm_fileignore  

# Usage

1.git clone or copy the shell script to your host
```
git clone https://github.com/malongshuai/rm_is_safe.git
```

2.Execute rm_is_safe.sh
```
sudo bash rm_is_safe.sh
```

Now, your rm is safe.

3.If you really want to remove protected files, you can use `/bin/rm.bak`, it is the native rm command.
```
rm.bak /path/to/file
```

4.if you want to uninstall `rm_is_safe`, execute function `uninstall_rm_is_safe`:
```
# if uninstall_rm_is_safe command is not found, `exec bash` first
$ uninstall_rm_is_safe
```

Now, your `rm` is the native `/bin/rm`.
