<p align="center">
  <img src=".github/icon.png" alt="LongMacro" width="128">
</p>

<h1 align="center">LongMacro</h1>

<p align="center">
  <strong>Macros longer than 255 characters, in Blizzard's own macro window.</strong><br>
  <em>Des macros de plus de 255 caractères, dans la fenêtre de macros de Blizzard.</em>
</p>

<p align="center">
  <a href="#english">English</a> · <a href="#français">Français</a>
</p>

## English

LongMacro removes the 255-character typing limit inside the real `/macro` window. Write as much as you want and press Save as usual. If the macro is too long for a real slot, LongMacro stores the full text and puts a short stub in its place, icon included. Opening the macro again shows your full text. No separate editor, no extra clicks: it is just your macro window, unlocked.

### Features

- **No 255-character limit** in the Blizzard macro window. The counter turns gold and shows the real length.
- **Automatic:** longer macros are saved by LongMacro and run through a `/lmrun` stub in the real slot.
- **Seamless editing:** reopening a long macro shows the full text, ready to edit.
- **No wasted slots:** one long macro still uses a single macro slot.

### Limitation

Blizzard does not let addons run protected actions (casting spells, targeting, using items in combat) from macro text stored outside a real macro. Lines such as chat messages, emotes and interface toggles always work. Lines that cast or target may be refused, and LongMacro tells you when that happens.

### Installation

Copy the `LongMacro` folder into `Interface\AddOns`, then restart the game or reload your interface.

### Commands

You can use `/longmacro` or `/lm`.

| Command | What it does |
|---|---|
| `/lm` | List your long macros |
| `/lm forget Name` | Forget the long text saved for the macro `Name` |
| `/lmrun Name` | Run the long macro `Name` (written into the macro slot for you) |

### Copyright

Copyright (c) 2026 Daeler. All rights reserved.

---

## Français

LongMacro supprime la limite de 255 caractères dans la vraie fenêtre `/macro`. Écrivez autant que vous voulez et cliquez sur Enregistrer comme d'habitude. Si la macro est trop longue pour un vrai emplacement, LongMacro garde le texte complet et met une courte commande à sa place, icône comprise. En rouvrant la macro, vous retrouvez votre texte complet. Pas d'éditeur à part, pas de clic en plus : c'est votre fenêtre de macros, débridée.

### Fonctionnalités

- **Plus de limite de 255 caractères** dans la fenêtre de macros de Blizzard. Le compteur passe en doré et affiche la vraie longueur.
- **Automatique :** les macros plus longues sont enregistrées par LongMacro et lancées par une commande `/lmrun` dans le vrai emplacement.
- **Édition transparente :** en rouvrant une longue macro, vous retrouvez le texte complet, prêt à modifier.
- **Aucun emplacement gaspillé :** une longue macro n'utilise toujours qu'un seul emplacement.

### Limite

Blizzard n'autorise pas les addons à lancer des actions protégées (sorts, ciblage, objets en combat) depuis un texte de macro stocké hors d'une vraie macro. Les lignes comme les messages de chat, les emotes et l'affichage des fenêtres fonctionnent toujours. Les lignes qui lancent un sort ou ciblent peuvent être refusées, et LongMacro vous le signale.

### Installation

Copiez le dossier `LongMacro` dans `Interface\AddOns`, puis relancez le jeu ou rechargez l'interface.

### Commandes

Vous pouvez utiliser `/longmacro` ou `/lm`.

| Commande | Effet |
|---|---|
| `/lm` | Lister vos longues macros |
| `/lm forget Nom` | Oublier le texte long enregistré pour la macro `Nom` |
| `/lmrun Nom` | Lancer la longue macro `Nom` (écrit pour vous dans l'emplacement de la macro) |

### Droits d'auteur

Copyright (c) 2026 Daeler. Tous droits réservés.
