# rm_is_safe

[[English](https://github.com/malongshuai/rm_is_safe/blob/master/README.md) | 简体中文]

`rm_is_safe`可以让你的rm命令变得更加安全。

![](https://www.junmajinlong.com/img/stuffs/a13-1588658636362.gif)

# 工作方式

`rm_is_safe`会创建一个名为`/bin/rm`的shell脚本，同时会备份原生的/bin/rm为/bin/rm.bak。所以，原来如何使用rm，现在也以一样的方式使用rm，没有任何区别。

`rm_is_safe`会自动检查rm被调用时传递的参数，如果参数中包含了重要文件，可能意味着这是一次危险的rm操作，`rm_is_safe`会直接忽略本次rm。至于哪些属于重要文件，由你自己来决定。

`rm_is_safe`对所有用户都有效，即包括已存在的用户和未来新创建的用户。

# 哪些是重要文件？

1. 根目录`/`以及根目录下的子目录、子文件总是被保护的  
2. 你可以在`/etc/security/rm_fileignore`中定义你自己觉得重要的文件，每行定义一个被保护的文件路径。例如：

    ```
    /home/junmajinlong
    /home/junmajinlong/apps
    ```

现在，该文件中定义的两个文件都被保护起来了，它们是安全的，不会被rm删除。

**注意事项:**  

1. 显然，被保护的目录是不会进行递归的，所以'/bin'是安全的，而'/bin/aaa'是不安全的，除非你将它加入/etc/security/rm_fileignore文件中  
2. 根目录`/`以及根目录下的子目录是自动被保护的，不用手动将它们添加到/etc/security/rm_fileignore中  
3. /etc/security/rm_fileignore文件中定义的路径可以包含任意斜线，`rm_is_safe`会自动处理。所以，'/home/junmajinlong'和'/home///junmajinlong/////'都是有效路径  
4. /etc/security/rm_fileignore中定义的路径中不要使用通配符，例如`/home/*`是无效的  
5. /etc/security/rm_fileignore中不要定义相对路径，要定义绝对路径  

# Usage

1.git clone或拷贝仓库中的Shell脚本到你的主机上

```
$ git clone https://github.com/malongshuai/rm_is_safe.git
```

2.执行该Shell脚本

```
$ cd rm_is_safe
$ sudo bash rm_is_safe.sh
```

执行完成后，你的rm命令就变成了安全的rm了。

3.如果你确实想要删除被保护的文件，比如你明确知道/data是可以删除的，而根目录下的子目录默认总是被保护的，那么你可以使用原生的rm命令，即/bin/rm.bak来删除。

```
$ rm.bak /path/to/file
```

4.如果你想要卸载`rm_is_safe`，执行函数`uninstall_rm_is_safe`即可：

```
# 如果找不到该函数，则先exec bash，在执行即可
$ uninstall_rm_is_safe
```

卸载完成后，`/bin/rm`就变回原生的rm命令了。

