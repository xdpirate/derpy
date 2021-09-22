# Derpy
A collection of more or less useful functions for legacy versions of WoW (currently TBC 2.4.3, WotLK 3.3.5a, and Cataclysm 4.3.4)


## Passive automatic functions
When turned on, these functions will work automatically:
- **AntiShitter** ![The Burning Crusade][tbc]![Cataclysm][cata] -- Notifies you if there's an ignored player in your party/raid (defaults to *on*)
- **AutoPurge** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Allows you to maintain a list of items to be automatically purged from your bags (defaults to *off*)
- **CapShard** ![Wrath of the Lich King][wotlk] -- Caps the amount of Soul Shards you carry to a certain number. When this is on, any excess shards are automatically deleted (defaults to *off*)
- **Guild Ding Notifier** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Lets your guild know when you level up! (defaults to *off*)
- **HonorGoal** ![Cataclysm][cata] -- Lets you set an honor point goal and get updates whenever you earn honor (defaults to *off*)
- **iLvLUpdate** ![Cataclysm][cata] -- Notify you when your average equipped item level changes (defaults to *off*)
- **Innervate Notifier** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Sends a whisper to the receiving target when you cast Innervate on them (defaults to *on*)
- **Monster Emote** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Emphasizes monster emotes such as "Murloc runs away in fear!", by displaing them in the top error frame (defaults to *on*)
- **Party Achievement Notifier** ![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Posts a notification about your gained achievements to the party chat, for grouping with guild outsiders (defaults to *off*)
- **RepTrack** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Changes your currently watched faction ("display as bar") whenever you gain reputation (defaults to *on*)
- **RepAnnounce** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Shows you a discreet notification window and plays a non-intrusive sound whenever your standing with a faction changes (defaults to *on*)
- **RepCalc** ![The Burning Crusade][tbc]![Cataclysm][cata]  -- Shows you progress to next reputation level whenever you gain reputation with a non-Exalted faction (defaults to *off*)
- **Rested Notifier** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Notifies you when entering or leaving a resting area, showing how much rested XP you've accumulated, if any (defaults to *on*)
- **SpiderBurrito** ![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Notifies nearby players when you are afflicted by Web Wrap (defaults to *on*)
- **SetRescue** ![Cataclysm][cata] -- Automatically buys back items part of an equipment set if sold to a vendor (defaults to *on*)

All of the passive functions can be easily toggled in-game. As seen above, the spammy or annoying functions are off by default, until you turn them on.

## Manually activated functions
These functions have to be activated manually through the command line or by using them in a macro:
- **Bag Worth** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Show the total worth of the items in your bags
- **Book Club** ![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Add TomTom waypoints for the Higher Learning achievement in Dalaran
- **Gray** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Purge all gray items from your bags (asks for confirmation first)
- **LowGray** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Purge the lowest value gray item slot from your bags
- **Pony** ![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Squeal about who has their Crusader Aura on (can be sent to just you, or to party/raid chat)
- **Raid Disband** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Completely disband a raid group you are the leader of
- **Random Pet** ![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Summon a random pet companion with some snazzy random dialogue to go with it
- **Silent Random Pet** ![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Summon a random pet companion without the snazzy random dialogue (boring version)
- **Skin** ![The Burning Crusade][tbc]![Wrath of the Lich King][wotlk] -- See what the highest level skinnable mob is with your current skill
- **Speed** ![Wrath of the Lich King][wotlk]![Cataclysm][cata] -- Calculates and outputs your current speed. Useful for finding out which speed buffs/effects stack and what the resulting speed is

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