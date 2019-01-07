#KeyPoints

**判断目录是否存在**
```
if not os.path.isdir('./paralog/'):
    os.mkdir('./paralog/')
```

**保存数据及读取**
```
saver = tf.train.Saver()
sess = tf.Session()
if True: 
    saver.restore(sess, './paralog/model.ckpt')
else:
    sess.run(tf.global_variables_initializer())

saver.save(sess, "./paralog/model.ckpt")
```

**将numpy array由浮点型转换为整型**
```
x.astype(int)
```

**mojoco报错 GLEW initalization error**

open .bashrc sudo gedit ~/.bashrc

add this line at the end export 

LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libGLEW.so:/usr/lib/x86_64-linux-gnu/libGL.so