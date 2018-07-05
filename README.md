# Hello Nintendo

## Attract Mode Theme

### YouTube Video https://www.youtube.com/watch?v=M9e8xJY-XY0
#### version 1.1

A layout based on the original Nintendo Entertainment System (NES). The layout uses a custom grid navigation system and provides a multitude of optional parameters to customise your experience.

The layout code should be fairly straight forward to follow if your a newbie to Squirrel programming language and Attract Mode theme/layout building. Even if you do not want to do anything with the code then you can use your own assets to change things up such as telling the them to use 3dboxes as shown in the video showcase or swap out a similar image in the parts folder.

![Default Settings](/parts/gitscreen1.jpg)

![Favourite Icon Activation](/parts/gitscreen2.jpg)

![8x5 Grid](/parts/gitscreen3.jpg)

![10x5 Grid](/parts/gitscreen4.jpg)

![3x2 Big Box Grid](/parts/gitscreen5.jpg)

![4x2 Big Box Grid](/parts/gitscreen6.jpg)

![DK](/parts/donkey-kong.png)

## Assets (Emulator Configuration)

Attract Mode has default asset names which include snap, marquee, flyer, etc... Since this theme will draw upon more than what is already setup by default then you will need to provide attract mode with these additional asset references.

**logo** - This is the transparent logo above the video snap
**cart** - This referes to the cartridge images
**snaptitle** - Shows an image snap of the title screen on the game
**backbox** - Shows the rear art of the game box (Opposite to **box** which should show the front)

Of course this is just a guide and should you want to modify any of these settings or pull in alternative types of images then this can be easily done from the layout.nut file contained within this directory. The second near the top under "//external assets" references these assets

Enjoy!

1.1 Update
- Bug fix: Menu would eventually slow down over time, this could have lead to the application crashing. This was due to image assets being constantly added to the playing field instead of a controlled number of specific assets which is now the case.
