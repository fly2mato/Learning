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

**不确定情况下的传参**

字典是另一种可变容器模型，且可存储任意类型对象。
字典的每个键值(key=>value)对用冒号(:)分割，每个对之间用逗号(,)分割，整个字典包括在花括号({})中 ,格式如下所示：
d = {key1 : value1, key2 : value2 }
键必须是唯一的，但值则不必。
值可以取任何数据类型，但键必须是不可变的，如字符串，数字或元组。
一个简单的字典实例：
dict = {'Alice': '2341', 'Beth': '9102', 'Cecil': '3258'}

*args

不确定往一个函数中传入多少参数，以元组（tuple）或者列表（list）的形式传参数的时候。

**kwargs

不确定往函数中传递多少个关键词参数或者传入字典的值作为关键词参数的时候。

**tensorflow里的索引切片**
```
index_col = np.array([0,1,2,1]).reshape([-1,1])
index = np.hstack([np.arange(4).reshape([-1,1]), index_col])
print(index)
#index = 
y = tf.gather_nd(testx, index.tolist())
print('='*10)
with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    print(sess.run(testx))
    print(sess.run(y))
```
结果为
```
[[0 0]
 [1 1]
 [2 2]
 [3 1]]
==========
[[1 2 3]
 [2 3 1]
 [0 1 3]
 [4 5 6]]
[1 3 3 5]
```
使用tf.gather_nd()这个函数，但是需要注意索引项的shape应该和被索引项相同。

直接对tensor操作：
```
a = np.array([1,3,4,5])
xa = tf.Variable(a, dtype=tf.int32)
y = tf.range(tf.shape(a)[0], dtype=tf.int32)
yy = tf.stack([y,xa], axis=1)
with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    print(sess.run(xa))
    print(sess.run(y))
    print(sess.run(yy))
```
结果为
```
[1 3 4 5]
[0 1 2 3]
[[0 1]
 [1 3]
 [2 4]
 [3 5]]
```