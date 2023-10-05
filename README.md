# Zombie Invasion 2nite

**Author:** Tyler Meyers  
**Video Demo:** [Watch Demo](https://youtu.be/HfMk_WfMGR4) - Unfortunately the video quality is poor so the sound is noticeably laggy. Download for the true experience!  
**Time Spent:** Approximately 20 hours  
**Project Completion:** January 2023  

## Running the Love2D Game Locally
Make sure you have Love2D installed on your computer. You can download it from [love2d.org](https://love2d.org).

### Clone the Repository
- Clone the repo and use your operating system's file explorer or terminal/command prompt to navigate to the directory containing the Love2D game files (where `main.lua` is located).

### On Windows:
- Simply drag and drop the game directory onto the `love.exe` executable that you installed earlier. This will launch the Love2D game.

### Description:
Utilizing the Love 2d framework (and Lua - the scripting language), I created a demo of a game I envisioned could potentially expanded on with more features, better funcionality, and improved graphics. The game took me about a week to finish (around 20 hours total), and was completed in two very distinct stages - the game mechanics stage (spawning hero, zombies, and bullets - collision system) and the polish stage (sprties, sounds, background, gamestates). Each took around 10 hours.

For context, I knew I wanted to create a game for my CS50x project, but after watching some videos on youtube, I realized that I was way out of my league for creating anything worth playing. So, I decided to enroll in CS50g which was a spinoff course that taught game development. After about week 3 of the course, I decided I was ready to take what I learned and finally create my own game.

This game took me much longer than expected. My final project for CS50p (python), took around 5 hours in total. I knew this project would take longer, but didn't expect it to take this long. 

This game includes a healthy amount of features, and it was interesting to see what I struggled with, and what I exceled with. Overall, this project boosted my confidence as a programmer, and I'm excited to keep on progressing.

It was fun to get stuck on something and then either find a creative solution or a work around. I wasn't too hard on myself as this was my first game, so if I couldn't figure something out or do it the right way, I'd find a trick to still implement the feature or simply skip it for timesake.

I utilized some code from CS50g's pong to get me started with a template.

### Below are things that I struggled with...
- Implementing the Knife library which was used in the CS50g lecture. This libary used timers, and I just couldn't figure out how to implement them. In the end, I used a workaround that probably added more code than was ideal. 
- Surprisngly, it was difficult to find the ideal background and adjust it properly.
- For the gunshots, I realized that only one sound can be played at a time. (this didn't work as you could shoot in-game multiple times but only hear one gunshot). The workaround in the code was... if a gunshot was already playing, you need to stop it, and play another.
- reloading required a little more math than expected. needed a lot of if statements for if the reserve ammo was lower than 0.


### Ways I could have improved (but would have added more time)
- Animations for the player and zombie where they move.
- Powerups such as extra ammo.
- More weapons and different types of zombies.
- Health for the hero.
- Zombies attacking the hero rather than running past.
