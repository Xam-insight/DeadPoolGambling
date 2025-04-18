local L = LibStub("AceLocale-3.0"):NewLocale("Deadpool", "frFR", false)

if L then

L["DEADPOOL_WELCOME"] = "Tapez /deadpool pour ouvrir Dead Pool."

L["SPACE_BEFORE_DOT"] = " "

L["GENERAL_SECTION"] = "Options générales"
L["NOTIFICATIONS_SECTION"] = "Options de notifications"
L["ENABLE_NOTIFICATIONS_IN_BOSS_FIGHTS"] = "En combat de boss"
L["ENABLE_NOTIFICATIONS_IN_BOSS_FIGHTS_DESC"] = "Active / désactive les notifications en combat contre un boss"
L["ENABLE_NOTIFICATIONS_IN_MYTHIC_PLUS"] = "En %s"
L["ENABLE_NOTIFICATIONS_IN_MYTHIC_PLUS_DESC"] = "Active / désactive les notifications en %s"
L["ENABLE_SOUND"] = "Sons actifs"
L["ENABLE_SOUND_DESC"] = "Active / désactive les sons de Dead Pool"
L["ENABLE_REMINDER"] = "Rappel actif"
L["ENABLE_REMINDER_DESC"] = "Active / désactive le rappel lors de l'Appel"
L["ENABLE_DEATH_ANNOUNCE"] = "Annonce de Mort"
L["ENABLE_DEATH_ANNOUNCE_DESC"] = "Active / désactive l'annonce de la Mort"
L["ENABLE_DEATH_QUOTES"] = "Citation de Mort"
L["ENABLE_DEATH_QUOTES_DESC"] = "Active / désactive les citations de PNJ lors de votre mort"
L["ENABLE_ACHIEVEMENT_ANNOUNCE"] = "Hauts faits"
L["ENABLE_ACHIEVEMENT_ANNOUNCE_DESC"] = "Active / désactive l'annonce des Hauts Faits"
L["ENABLE_MODEL_POPUP"] = "Vêtement perdu"
L["ENABLE_MODEL_POPUP_DESC"] = "Active / désactive l'affichage du personnage qui vient de perdre un vêtement à côté de la fenêtre Dead Pool"
L["MODEL_POPUP_SIDE"] = "Position du modèle"
L["MODEL_POPUP_SIDE_DESC"] = "Définit le côté d'affichage du personnage qui vient de perdre un vêtement"
L["MODEL_POPUP_SIDE_LEFT"] = "Gauche"
L["MODEL_POPUP_SIDE_RIGHT"] = "Droite"
L["ENABLE_MINIMAPBUTTON"] = "Bouton Minimap"
L["ENABLE_MINIMAPBUTTON_DESC"] = "Affiche / cache le bouton de la Minimap"
L["ENABLE_BETBUTTON"] = "Bouton sur les portraits"
L["ENABLE_BETBUTTON_DESC"] = "Affiche / cache le bouton de pari sur le cadre des unités du groupe"
L["ENABLE_TUTO"] = "Didacticiels"
L["ENABLE_MENUTUTO"] = "Messages d'aide"
L["ENABLE_TUTO_DESC"] = "Affiche / cache les messages d'aide"
L["RULES_SECTION"] = "Règles"
L["ENABLE_TRULY_UNEQUIP_ITEMS"] = "Vraiment retirer les vêtements"
L["ENABLE_TRULY_UNEQUIP_ITEMS_ENABLED"] = "Retire vraiment les vêtements"
L["ENABLE_TRULY_UNEQUIP_ITEMS_DESC"] = "Active/désactive la mise dans l'inventaire des éléments d'armure de votre personnage lors de l'échange de vêtements contre des jetons."
L["ENABLE_TRULY_UNEQUIP_ITEMS_TOOLTIP"] = "Active/désactive la mise dans l'inventaire|ndes éléments d'armure de votre personnage|nlors de l'échange de vêtements contre des jetons."
L["NEVER_TRULY_UNEQUIP_ITEMS_TOOLTIP"] = "Bloque le mode '%s' et empêche les autres joueurs de vous le proposer."
L["ENABLE_SAVING_DATA_AFTER_LEAVING_GROUP"] = "Sauvegarde des données"
L["ENABLE_SAVING_DATA_AFTER_LEAVING_GROUP_DESC"] = "Active / désactive la sauvegarde des données. Le créateur du prochain groupe pourra continuer la session de paris."
L["WINDOW_SECTION"] = "Options de fenêtre Dead Pool"
L["LOCAL_WINDOW_OPTIONS"] = "Options pour ce personnage uniquement"
L["LOCAL_WINDOW_OPTIONS_DESC"] = "Les options de fenêtre ci-dessous et de position ne s'appliquent que pour ce personnage."
L["HIDE_IN_COMBAT"] = "Cacher en combat"
L["HIDE_IN_COMBAT_DESC"] = "Cacher la fenêtre Dead Pool en combat"
L["PLAYER_FIRST"] = "Joueur en premier"
L["PLAYER_FIRST_DESC"] = "Le personnage du joueur apparaît en premier dans la liste."
L["BET_REMINDER"] = "Rappel"
L["BET_REMINDER_DESC"] = "Lors d'un appel du chef de groupe, Deadpool vous rappelle de miser."
L["DEADPOOLFRAME_ALPHA"] = "Transparence de Dead Pool"
L["DEADPOOLFRAME_LINEHEIGHT"] = "Hauteur des lignes"
L["ROSTER_SECTION"] = "Options de la liste de personnages"
L["ADMIN_SECTION"] = "Options d'administration"
L["TELL_ANNOUNCER"] = "Indiquer l'annonceur"
L["TELL_ANNOUNCER_DESC"] = "Indique le nom de l'annonceur lors de l'annonce d'un nouveau titre."
L["GUILD_CHAT_ANNOUNCE"] = "Annoncer sur le canal de guilde"
L["GUILD_CHAT_ANNOUNCE_DESC"] = "Annonce les nouveaux titres sur le canal de guilde."
L["NOT_ADMIN_ERROR"] = "Votre niveau d'administration Dead Pool n'est pas assez élevé pour effectuer cette action."
L["NOT_ENOUGH_CREDITS"] = "Jetons insuffisants pour accepter ce pari. Voulez-vous retirer %d |4vêtement:vêtements;\194\160? (%s par vêtement retiré)"
L["TRULY_UNEQUIP_ITEMS"] = "%s a activé le mode |cFFFFFF00Vraiment retirer les vêtements|r. Voulez-vous l'activer également\194\160?|n|n|cFFFF0000Les vêtements échangés contre des jetons seront placés dans votre inventaire.|r"
L["DEADPOOL_SELL_ITEM_WARNING"] = "Tant que le mode |cFFFFFF00Vraiment retirer les vêtements|r est activé, cet objet ne peut pas être vendu. Voulez-vous désactiver le mode |cFFFFFF00Vraiment retirer les vêtements|r\194\160?"
L["NOT_ENOUGH_ITEMS"] = "Vous n'avez plus assez de vêtements."
L["UNIT_IN_COMBAT"] = "Ce personnage est en combat, attendez qu'il sorte de combat pour parier."
L["SELF_BET_NOT_ALLOWED"] = "Vous ne pouvez pas parier sur vous-même."
L["EMPTY_BANK"] = "La Banque est vide. Vous ne pouvez pas la faire sauter."
L["DEADPOOL_SOLEILBET"] = "Soleîl est votre déesse. Parier contre elle vous fait perdre un vêtement."
L["DEADPOOL_VERSION_UPDATE"] = "Veuillez mettre à jour %s : nouvelles règles."
L["DEADPOOL_VERSION_UPDATE_DESC"] = "La nouvelle version de %s apporte un changement aux règles. Mettez à jour pour assurer son bon fonctionnement."

L["ANNOUNCEDEADPOOLSESSIONBUTTON_TOOLTIP"] = "Logs de résultats"
L["ANNOUNCEDEADPOOLSESSIONBUTTON_TOOLTIPDETAIL"] = "Affiche / cache la fenêtre des logs de résultats."

L["LOCKBUTTON_TOOLTIP"] = "Verrouiller"
L["LOCKBUTTON_TOOLTIPDETAIL"] = "Vérouille / dévérouille la fenêtre."

L["NO_SELECTED_CHARACTER"] = "Aucune sélection"

L["MINIMAP_TOOLTIP1"] = "Clic gauche pour afficher/cacher Dead Pool."
L["MINIMAP_TOOLTIP2"] = "Clic droit pour ouvrir les options."

L["MENUOPTIONS_TOOLTIP"] = "Options de Dead Pool"
L["MENUOPTIONS_TOOLTIPDETAIL"] = "Modifier les options de Dead Pool."

L["DEADPOOLLOGS_DIED0"] = " est mort."
L["DEADPOOLLOGS_DIED1"] = " est morte."
L["DEADPOOLLOGS_HASBETANDDIED"] = "La banque récupère un vêtement sur %s."
L["DEADPOOLLOGS_NOWINNER"] = "Personne ne gagne de pari standard."
L["DEADPOOLLOGS_THEBANK"] = "La Banque"
L["DEADPOOLLOGS_WINS"] = " gagne "
L["DEADPOOLLOGS_COLLECTS"] = " collecte "
L["DEADPOOLLOGS_CHIPS"] = "%s\194\160!"
L["DEADPOOLLOGS_BANKCHIPS"] = "%s de la banque\194\160!"

L["DEADPOOLCOLLUMNS_CHARACTER"] = "Personnage"
L["DEADPOOLCOLLUMNS_NEXTDEATHBETS"] = "Paris sur prochain mort"
L["DEADPOOLCOLLUMNS_ODDS"] = "Cote"
L["DEADPOOLCOLLUMNS_WHOM_ODDS"] = "Cote de %s"
L["DEADPOOLCOLLUMNS_BET"] = "Mise"
L["DEADPOOLCOLLUMNS_MODEL"] = "Modèle"
L["DEADPOOLCOLLUMNS_STATS"] = "Stats"
L["DEADPOOLCOLLUMNS_STATS_WINS"] = "Victoires"
L["DEADPOOLCOLLUMNS_STATS_FIRSTDEATH"] = "Mort en premier"
L["DEADPOOLCOLLUMNS_STATS_CREDITSGAIN"] = "Gains"
L["DEADPOOLCOLLUMNS_STATS_LOSTITEMS"] = "Vêtements retirés"
L["DEADPOOLCOLLUMNS_STATS_DEATHS"] = "Morts"
L["DEADPOOLCOLLUMNS_STATS_DEATHSONBOSS"] = "Morts en combat de boss"
L["DEADPOOLCOLLUMNS_STATS_EARNINGS"] = "Bénéfices"
L["DEADPOOLCOLLUMNS_STATS_LOSSES"] = "Pertes"

L["DEADPOOLUI_PLAYINGDEADPOOL"] = "Joue à Dead Pool %s"
L["DEADPOOLUI_BETSONNEXTDEATH"] = "Pari prochain mort"
L["DEADPOOLUI_CHIPS"] = "Jetons"
L["DEADPOOLUI_CHIPS_TOOLTIP"] = "Vos jetons"
L["DEADPOOLUI_CHIPS_TOOLTIPDETAIL"] = "Nombre de jetons en votre possession"
L["DEADPOOLUI_CHIPS_TOOLTIPDETAILGREEN"] = ""
L["DEADPOOLUI_BANK"] = "Banque"
L["DEADPOOLUI_BANK_TOOLTIP"] = "Jetons de la Banque"
L["DEADPOOLUI_BANK_TOOLTIPDETAIL"] = "Nombre de jetons dans la Banque"
L["DEADPOOLUI_BANK_TOOLTIPDETAILGREEN"] = "Si personne ne gagne, les mises vont dans la Banque.|nTentez un pari unique pour remporter le contenu de la Banque."
L["DEADPOOLUI_BETS"] = "Mises"
L["DEADPOOLUI_BETS_TOOLTIP"] = "Total des mises"
L["DEADPOOLUI_BETS_TOOLTIPDETAIL"] = "Nombre total de jetons misés par les joueurs"
L["DEADPOOLUI_BETS_TOOLTIPDETAILGREEN"] = ""
L["DEADPOOLUI_RESULTS"] = "Résultats"
L["DEADPOOLUI_WINNER"] = "Joueur en tête"
L["DEADPOOLUI_WINNER_NONE"] = "Aucun"

L["DEADPOOLUI_BET"] = "La cote actuelle sur la mort de ce personnage "
L["DEADPOOLUI_BET2"] = "permet de remporter "
L["DEADPOOLUI_BET3"] = " fois sa mise."
L["DEADPOOLUI_BET4"] = "Votre gain potentiel : "
L["DEADPOOLUI_BET5"] = "Votre pari modifiera les cotes."
L["DEADPOOLUI_BET6"] = "Vous avez parié sur ce personnage pour faire sauter la Banque."
L["DEADPOOLUI_BET7"] = "Vous avez misé %s%s sur ce personnage."

L["DEADPOOLUI_NOMORECHIPS"] = "Vous n'avez plus de jetons."
L["DEADPOOLUI_MAXBETS"] = "Vous ne pouvez miser que sur %d |4personnage:personnages; (dépend de la taille du groupe)."
L["DEADPOOLUI_BETSCHANGEDONCHAR"] = "Les mises vous concernant ont changé."

L["DEADPOOLMENU_BET"] = "Pari standard (limité en nombre)"
L["DEADPOOLMENU_ADD"] = "Ajouter"
L["DEADPOOLMENU_ALL"] = "Miser tout ce que j'ai"
L["DEADPOOLMENU_REMOVE"] = "Retirer la mise"
L["DEADPOOLMENU_BANKBET"] = "Faites sauter la Banque"
L["DEADPOOLMENU_UNIQUE"] = "Pari unique (gratuit)"
L["DEADPOOLMENU_OPTIONS"] = "Options"

L["DEADPOOLTUTO_TUTO1"] = "Bienvenue dans la Dead Pool\194\160!|nD'après vous, qui sera le prochain à casser sa pipe\194\160? Pour parier, cliquez sur la pile de jetons d'un personnage et choisissez votre mise."
L["DEADPOOLTUTO_TUTO2"] = "Parfait\194\160! Il n'y a plus qu'à attendre patiemment le prochain coup du sort et à rafler la mise\194\160!"
L["DEADPOOLTUTO_TUTO3"] = "Eh bien, eh bien... Je vois qu'il n'a pas fallu bien longtemps. Consultez les résultats dans la fenêtre principale de discussion. Pensez à parier à nouveau\194\160! Un accident est si vite arrivé..."
L["DEADPOOLTUTO_TUTO4"] = "Oui, j'oubliais. On ne peut pas parier sur soi-même, c'est un manque de savoir vivre\194\160!"
L["DEADPOOLTUTO_TUTO5"] = "Les paris sont ouverts entre les combats. Je vous conseille de rester concentrés, la banque récupère un vêtement sur les parieurs maladroits qui se font occire\194\160!"
L["DEADPOOLTUTO_TUTO6"] = "Quand vous entrez dans un groupe, vous rejoignez la Dead Pool de ce groupe. Vos paris et jetons sont réinitialisés."
L["DEADPOOLTUTO_TUTO7"] = "Vous voulez tenter de faire sauter la banque\194\160? Pour ce pari, vous ne choisissez qu'un seul personnage."

L["DEADPOOLTUTO_MINIMIZE"] = "Vous pouvez minimiser la fenêtre de Dead Pool."
L["DEADPOOLTUTO_SELFBET"] = "Vous ne pouvez pas parier sur vous-même, seulement sur les autres personnages de votre groupe."
L["DEADPOOLTUTO_BET"] = "Vous allez parier sur le prochain personnage qui va mourir."
L["DEADPOOLTUTO_BET1"] = "Vous pouvez ajouter un jeton sur ce personnage."
L["DEADPOOLTUTO_BET5"] = "Vous pouvez ajouter des jetons sur ce personnage. Ajustez le nombre grâce à la jauge."
L["DEADPOOLTUTO_BETTOMUCH"] = "Si vous n'avez pas assez de jetons, Dead Pool vous proposera d'échanger des vêtements contre des jetons supplémentaires."
L["DEADPOOLTUTO_BETALL"] = "Vous pouvez miser d'un coup tous vos jetons restants sur ce personnage."
L["DEADPOOLTUTO_BETREMOVE"] = "Vous pouvez retirer votre mise sur ce personnage."
L["DEADPOOLTUTO_UNIQUEBET"] = "Vous n'avez plus ni jetons ni vêtements mais vous pouvez faire sauter la banque\194\160!|n|nCe pari est gratuit mais vous ne pouvez choisir qu'un seul personnage.|n|nVous gagnez ce qu'il y a dans la banque sous forme de vêtements et de jetons."
L["DEADPOOLTUTO_BANKER"] = "Gallywix ainsi que les sujets de donjons peuvent participer aux paris."
L["DEADPOOLTUTO_BANKERBET"] = "Demandez-leur de miser, ils choisiront sur quel personnage il veulent parier."
L["DEADPOOLTUTO_BANKERHASBET"] = "Il a déjà choisi son pari, les jeux sont faits\194\160!"
L["DEADPOOLTUTO_BOSS"] = "Si tous les joueurs de Dead Pool sont dans votre instance de raid et que ce raid est de votre niveau, vous pouvez parier sur la mort du prochain boss !"

L["NEW_TITLE_FOR"] = "Nouveau titre pour %s"
L["DEADPOOL_ACHIEVEMENT_WINS"] = "En veine"
L["DEADPOOL_ACHIEVEMENT_WINS_DESC"] = "Être le premier à gagner %s fois dans une même partie."
L["DEADPOOL_ACHIEVEMENT_FIRSTDEATH"] = "Fragile"
L["DEADPOOL_ACHIEVEMENT_FIRSTDEATH_DESC"] = "Être le premier à mourir en premier %s fois dans une même partie."
L["DEADPOOL_ACHIEVEMENT_CREDITSBALACE"] = "Nabab"
L["DEADPOOL_ACHIEVEMENT_CREDITSBALACE_DESC"] = "Être le premier à gagner %s jetons dans une même partie."
L["DEADPOOL_ACHIEVEMENT_LOSTITEMS"] = "Tout nu"
L["DEADPOOL_ACHIEVEMENT_LOSTITEMS_DESC"] = "Être le premier à perdre tous ses vêtements dans une même partie."
L["DEADPOOL_ACHIEVEMENT_SOLEILBET"] = "Profanateur de Soleîl"
L["DEADPOOL_ACHIEVEMENT_SOLEILBET_DESC"] = "Être le premier à miser %s fois sur la mort de %s et à perdre ainsi %s vêtements en châtiment dans une même partie."

L["MAKE_BANKER_PLAY"] = "Faire miser %s"
L["MAKE_FOLLOWERS_PLAY"] = "et les sujets"
L["BANKER_BET"] = "%s\na misé sur %s."
L["BANKER_NO_CHIPS"] = "%s\nn'a plus de jetons."

L["NEXT_BOSS"] = "Prochain boss"

end
