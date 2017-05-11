# JDBreaksLoading

***
# Introduction
JDBreaksLoading Based on simple UIView and SpriteKit.

You can easily start up a little breaking game by one line.

By the way, don't make user wait too long to play the game~

Thanks for using.

![Alt text](/../master/Readme_img/JDBreaksLoading.gif?raw=true "")

# Usage

To add JDBreaksLoading to your view, just give it a frame and addSubview.

```Swift
  let jdbreaksLoading:JDBreaksLoading = JDBreaksLoading(frame: frame)
  self.view.addSubview(jdbreaksLoading)
```

### Game Configuration 
The default [ Ball, Block , Paddle -> All white, Block count: 3 ]

If you want to chagnge some game setting (color, block...etc).

You will need to set 'JDBreaksGameConfiguration'

```Swift
  let config:JDBreaksGameConfiguration = JDBreaksGameConfiguration(paddle_color: UIColor.white, ball_color:  UIColor.white, block_color:  UIColor.white, blocks_count: 3)
  let jd:JDBreaksLoading = JDBreaksLoading(frame: frame, configuration: config)
  self.view.addSubview(jd)
```
