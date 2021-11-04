# Derpy
A collection of more or less useful functions for legacy versions of WoW (currently TBC 2.4.3, WotLK 3.3.5a, and Cataclysm 4.3.4)
<br /><br />
## Passive/automatic functions

**AntiShitter** ![The Burning Crusade][tbc]![Cataclysm][cata]<br />
*Toggle with ```/dr antishitter```*<br />
Notifies you if there's an ignored player in your party/raid (defaults to *on*)

**AutoPurge** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Access submenu with ```/dr autopurge```*<br />
Allows you to maintain a list of items to be automatically purged from your bags (defaults to *off*)

**CapShard** ![Wrath of the Lich King][wotlk]<br />
*Set shard amount with ```/dr shard XX```*<br />
Caps the amount of Soul Shards you carry to a certain number. When this is on, any excess shards are automatically deleted (defaults to *off*)

**Guild Ding Notifier** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Toggle with ```/dr gding```*<br />
Lets your guild know when you level up! (defaults to *off*)

**HonorGoal** ![Cataclysm][cata]<br />
*Set Honor amount with ```/dr honorgoal XX```*<br />
Lets you set an honor point goal and get updates whenever you earn honor (defaults to *off*)

**iLvLUpdate** ![Cataclysm][cata]<br />
*Toggle with ```/dr ilvlupdate```*<br />
Notify you when your average equipped item level changes (defaults to *off*)

**Innervate Notifier** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Toggle with ```/dr innervate```*<br />
Sends a whisper to the receiving target when you cast Innervate on them (defaults to *on*)

**Monster Emote** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Toggle with ```/dr monster```*<br />
Emphasizes monster emotes such as "Murloc runs away in fear!", by displaing them in the top error frame (defaults to *on*)

**No Deal** ![Cataclysm][cata]<br />
*Access submenu with ```/dr nodeal```*<br />
Lets you maintain a list of items that the addon will prevent you from selling. Great for things you want to keep, but have a sale value (enchanting rods, Pet Rock, etc)

**Party Achievement Notifier** ![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Toggle with ```/dr partyachi```*<br />
Posts a notification about your gained achievements to the party chat, for grouping with guild outsiders (defaults to *off*)

**RepTrack** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Toggle with ```/dr rep```*<br />
Changes your currently watched faction ("display as bar") whenever you gain reputation (defaults to *on*)

**RepAnnounce** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Toggle with ```/dr repa```*<br />
Shows you a discreet notification window and plays a non-intrusive sound whenever your standing with a faction changes (defaults to *on*)

**RepCalc** ![The Burning Crusade][tbc]![Cataclysm][cata] <br />
*Toggle with ```/dr repc```*<br />
Shows you progress to next reputation level whenever you gain reputation with a non-Exalted faction (defaults to *off*)

**Rested Notifier** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Toggle with ```/dr rested```*<br />
Notifies you when entering or leaving a resting area, showing how much rested XP you've accumulated, if any (defaults to *on*)

**SpiderBurrito** ![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Toggle with ```/dr spiderburrito```*<br />
Notifies nearby players when you are afflicted by Web Wrap (defaults to *on*)

**SetRescue** ![Cataclysm][cata]<br />
*Toggle with ```/dr setrescue```*<br />
Automatically buys back items part of an equipment set if sold to a vendor (defaults to *on*)
<br /><br />
## Manually activated functions
These functions have to be activated manually through the command line or by using them in a macro:

**Bag Worth** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Activate with ```/dr bagworth```*<br />
Show the total worth of the items in your bags

**Book Club** ![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Activate with ```/dr bookclub```*<br />
Add TomTom waypoints for the Higher Learning achievement in Dalaran

**Gray** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Activate with ```/dr gray```*<br />
Purge all gray items from your bags (asks for confirmation first)

**LowGray** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Activate with ```/dr lowgray```*<br />
Purge the lowest value gray item slot from your bags, very useful to click when bags are full to get rid of the slot with the lowest value gray items in it

**Pony** ![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Activate with ```/dr pony```. Append ```raid``` or ```party``` to send a message to those channels*<br />
Squeal about who has their Crusader Aura on (can be sent to just you, or to party/raid chat)

**Raid Disband** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Activate with ```/dr disband```*<br />
Completely disband a raid group you are the leader of

**Random Pet** ![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Activate with ```/dr pet```*<br />
Summon a random pet companion with some snazzy random dialogue to go with it

**Silent Random Pet** ![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Activate with ```/dr spet```*<br />
Summon a random pet companion without the snazzy random dialogue (boring version)

**Skin** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]<br />
*Activate with ```/dr skin```*<br />
See what the highest level skinnable mob is with your current skill

**Speed** ![Wrath of the Lich King][wotlk]![Cataclysm][cata]<br />
*Activate with ```/dr speed```*<br />
Calculates and outputs your current speed. Useful for finding out which speed buffs/effects stack and what the resulting speed is

## How to install
1. Choose your version:
  - ![TBC][tbc]
  [The Burning Crusade (2.4.3)](https://github.com/xdpirate/derpy/archive/tbc.zip)

  - ![WotLK][wotlk]
  [Wrath of the Lich King (3.3.5a)](https://github.com/xdpirate/derpy/archive/wotlk.zip)

  - ![Cataclysm][cata]
  [Cataclysm (4.3.4)](https://github.com/xdpirate/derpy/archive/master.zip)
2. Open the downloaded archive
3. Enter the "Derpy-master", "Derpy-wotlk" or "Derpy-tbc" folder, and extract the folder named "Derpy" into "WoW Install Folder\Interface\AddOns"

## How to use
Type **/derp**, **/derpy** or **/dr** into the chat box in-game. This will show you more options, akin to what you can see in the screenshots below.

## Screenshots
These screenshots are from the WotLK version of the addon, and may look different under your game version, or have features added or removed.

### Main menu
![Main menu][mainMenu]

### Passive menu
![Passive menu][passiveMenu]

### AutoPurge menu
![AutoPurge menu][autoPurgeMenu]

### AutoPurge list example
![AutoPurge list example][autoPurgeList]

### RepAnnounce popup window
![RepAnnounce popup window][repAnnounce]

## Misc
Bug reports, pull requests, and feature requests are welcome!

In my defense, the slogans for the random pet functions are from 2011, when I originally made this addon, and in dire need of updates (and chemotherapy).

[mainMenu]: https://i.imgur.com/syKYJ1Z.png "Main menu"
[passiveMenu]: https://i.imgur.com/3JCYVEt.png "Passive menu"
[autoPurgeMenu]: https://i.imgur.com/WRJdGAp.png "AutoPurge menu"
[autoPurgeList]: https://i.imgur.com/jgysPOi.png "AutoPurge list example"
[repAnnounce]: https://i.imgur.com/x4T8b8t.jpg "RepAnnounce popup window"
[wotlk]: https://i.imgur.com/WsAkpoC.png "Available in the WotLK version of the addon"
[cata]: https://i.imgur.com/5wkh2Eo.png "Available in the Cataclysm version of the addon"
[tbc]: https://i.imgur.com/yekUNOW.png "Available in the TBC version of the addon"