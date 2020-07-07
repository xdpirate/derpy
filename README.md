# Derpy
A collection of more or less useful functions for legacy versions of WoW (currently WotLK 3.3.5a and Cataclysm 4.3.4)


## Passive/automatic functions
- **AutoPurge** -- Allows you to maintain a list of items to be automatically purged from your bags
- **CapShard** ![Only available in the WotLK version of the addon][wotlk] -- Caps the amount of Soul Shards you carry to a certain number. When this is on, any excess shards are automatically deleted
- **RepTrack** -- Changes your currently watched faction ("display as bar") whenever you gain reputation
- **RepAnnounce** -- Shows you a notification and plays a non-intrusive sound whenever your standing with a faction changes
- **Innervate Notifier** -- Sends a whisper to the receiving target when you cast Innervate on them
- **SpiderBurrito** -- Notifies nearby players when you are afflicted by Web Wrap
- **Rested Notifier** -- Notifies you when entering or leaving a resting area, showing how much rested XP you've accumulated, if any
- **Party Achievement Notifier** -- Posts a notification about your gained achievements to the party chat, for grouping with guild outsiders
- **Guild Ding Notifier** -- Lets your guild know when you level up!
- **Monster Emote** -- Emphasizes monster emotes such as "Murloc runs away in fear!", by shoving them in your face (displays them in the top error frame)
- **AntiShitter** ![Only available in the Cataclysm version of the addon][cata] -- Notifies you if there's an ignored player in your party/raid
- **SetRescue** ![Only available in the Cataclysm version of the addon][cata] -- Automatically buys back items part of an equipment set if sold to a vendor

All of the passive functions can be toggled in-game.

## Activated functions
- **Gray** -- Purge all gray items from your bags
- **Skin** ![Only available in the WotLK version of the addon][wotlk] -- See what the highest level skinnable mob is with your current skill
- **LowGray** -- Purge the lowest value gray item slot from your bags
- **Bag Worth** -- Show the total worth of the items in your bags
- **Pony** -- Squeal about who has their Crusader Aura on (can be sent to just you, or to party/raid chat)
- **Raid Disband** -- Completely disband a raid group you are the leader of
- **Book Club** -- Add TomTom waypoints for the Higher Learning achievement in Dalaran
- **Random Pet** -- Summon a random pet companion with some snazzy random dialogue to go with it
- **Silent Random Pet** -- Summon a random pet companion without the snazzy random dialogue (boring version)
- **Speed** -- Calculates and outputs your current speed. Useful for finding out which speed buffs/effects stack and what the resulting speed is

## How to install
1. Choose your version:

  - ![Cataclysm][cata]
  [Cataclysm (4.3.4)](https://github.com/xdpirate/derpy/archive/master.zip)
  
  - ![WotLK][wotlk]
  [Wrath of the Lich King (3.3.5a)](https://github.com/xdpirate/derpy/archive/wotlk.zip)
2. Open the downloaded archive
3. Enter the "Derpy-master" or "Derpy-wotlk" folder, and extract the folder named "Derpy" into "WoW Install Folder\Interface\AddOns"

## How to use
**/derp**, **/derpy** or **/dr**

## Screenshots

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
[wotlk]: https://i.imgur.com/WsAkpoC.png "Only available in the WotLK version of the addon"
[cata]: https://i.imgur.com/5wkh2Eo.png "Only available in the Cataclysm version of the addon"