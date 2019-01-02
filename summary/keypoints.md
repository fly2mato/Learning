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