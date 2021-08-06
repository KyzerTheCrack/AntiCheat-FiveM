CREATE TABLE `anticheatinfo` (
  `id` int(11) NOT NULL,
  `playerip` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `identifier` varchar(25) COLLATE utf8mb4_bin DEFAULT NULL,
  `Token` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `liveid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `xblid` varchar(21) COLLATE utf8mb4_bin DEFAULT NULL,
  `discord` varchar(30) COLLATE utf8mb4_bin DEFAULT NULL,
  `playername` varchar(32) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;



-- Index pour la table `anticheatinfo`

ALTER TABLE `anticheatinfo`
  ADD PRIMARY KEY (`id`);


-- AUTO_INCREMENT pour les tables déchargées

-- AUTO_INCREMENT pour la table `anticheatinfo`

ALTER TABLE `anticheatinfo`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=714;
COMMIT;


CREATE TABLE `anticheatban` (
  `id` int(11) NOT NULL,
  `ip` text CHARACTER SET latin1 DEFAULT NULL,
  `Steam` varchar(255) CHARACTER SET latin1 NOT NULL,
  `SteamLink` text CHARACTER SET latin1 DEFAULT NULL,
  `SteamName` text CHARACTER SET latin1 DEFAULT NULL,
  `DiscordUID` text CHARACTER SET latin1 DEFAULT NULL,
  `DiscordTag` text CHARACTER SET latin1 DEFAULT NULL,
  `GameLicense` text CHARACTER SET latin1 DEFAULT NULL,
  `xbl` text CHARACTER SET latin1 DEFAULT NULL,
  `live` text CHARACTER SET latin1 DEFAULT NULL,
  `BanType` text CHARACTER SET latin1 DEFAULT NULL,
  `Other` text CHARACTER SET latin1 DEFAULT NULL,
  `Date` text CHARACTER SET latin1 DEFAULT NULL,
  `Banner` text CHARACTER SET latin1 DEFAULT NULL,
  `Token` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- Déchargement des données de la table `blacklist`

INSERT INTO `anticheatban` (`id`, `ip`, `Steam`, `SteamLink`, `SteamName`, `DiscordUID`, `DiscordTag`, `GameLicense`, `xbl`, `live`, `BanType`, `Other`, `Date`, `Banner`, `Token`) VALUES
(1, 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', 'Default', '[\"4:400423cff244c62ba608afcd\",\"4:a602bf2a8924fb0a0aa2bbf8\",\"1:88ac322ede187a4e5a3e\",\"4:52caf4d1cbf74644027a\",\"4:977779c330b6e2d1\",\"4:c7c9b5edb0496\",\"3:5cdbfecf14603956222deae\",\"4:d9a5db096cb4cb8e\",\"4:9f81247074b53bce190eb\"]');


-- Index pour les tables déchargées

-- Index pour la table `anticheatban`

ALTER TABLE `anticheatban`
  ADD PRIMARY KEY (`id`);

-- AUTO_INCREMENT pour les tables déchargées

-- AUTO_INCREMENT pour la table `anticheatban`

ALTER TABLE `anticheatban`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;
COMMIT;

