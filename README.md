# Derpy
A collection of more or less useful functions for legacy versions of WoW (currently WotLK 3.3.5a and Cataclysm 4.3.4)


## Passive automatic functions
When turned on, these functions will work automatically:
- **AntiShitter** ![Only available in the Cataclysm version of the addon][cata] -- Notifies you if there's an ignored player in your party/raid (defaults to *on*)
- **AutoPurge** -- Allows you to maintain a list of items to be automatically purged from your bags (defaults to *off*)
- **CapShard** ![Only available in the WotLK version of the addon][wotlk] -- Caps the amount of Soul Shards you carry to a certain number. When this is on, any excess shards are automatically deleted (defaults to *off*)
- **Guild Ding Notifier** -- Lets your guild know when you level up! (defaults to *off*)
- **iLvLUpdate** ![Only available in the Cataclysm version of the addon][cata] -- Notify you when your average equipped item level changes (defaults to *off*)
- **Innervate Notifier** -- Sends a whisper to the receiving target when you cast Innervate on them (defaults to *on*)
- **Monster Emote** -- Emphasizes monster emotes such as "Murloc runs away in fear!", by displaing them in the top error frame (defaults to *on*)
- **Party Achievement Notifier** -- Posts a notification about your gained achievements to the party chat, for grouping with guild outsiders (defaults to *off*)
- **RepTrack** -- Changes your currently watched faction ("display as bar") whenever you gain reputation (defaults to *on*)
- **RepAnnounce** -- Shows you a discreet notification window and plays a non-intrusive sound whenever your standing with a faction changes (defaults to *on*)
- **RepCalc** ![Only available in the Cataclysm version of the addon][cata] -- Shows you progress to next reputation level whenever you gain reputation with a non-Exalted faction (defaults to *off*)
- **Rested Notifier** -- Notifies you when entering or leaving a resting area, showing how much rested XP you've accumulated, if any (defaults to *on*)
- **SpiderBurrito** -- Notifies nearby players when you are afflicted by Web Wrap (defaults to *on*)
- **SetRescue** ![Only available in the Cataclysm version of the addon][cata] -- Automatically buys back items part of an equipment set if sold to a vendor (defaults to *on*)

All of the passive functions can be easily toggled in-game. As seen above, the spammy or annoying functions are off by default, until you turn them on.

## Manually activated functions
These functions have to be activated manually through the command line or by using it in a macro:
- **Bag Worth** -- Show the total worth of the items in your bags
- **Book Club** -- Add TomTom waypoints for the Higher Learning achievement in Dalaran
- **Gray** -- Purge all gray items from your bags (asks for confirmation first)
- **LowGray** -- Purge the lowest value gray item slot from your bags
- **Pony** -- Squeal about who has their Crusader Aura on (can be sent to just you, or to party/raid chat)
- **Raid Disband** -- Completely disband a raid group you are the leader of
- **Random Pet** -- Summon a random pet companion with some snazzy random dialogue to go with it
- **Silent Random Pet** -- Summon a random pet companion without the snazzy random dialogue (boring version)
- **Skin** ![Only available in the WotLK version of the addon][wotlk] -- See what the highest level skinnable mob is with your current skill
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
Type **/derp**, **/derpy** or **/dr** into the chat box in-game. This will show you more options, akin to what you can see in the screenshots below.

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