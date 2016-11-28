<?php
/**
 * La configuration de base de votre installation WordPress.
 *
 * Ce fichier contient les réglages de configuration suivants : réglages MySQL,
 * préfixe de table, clés secrètes, langue utilisée, et ABSPATH.
 * Vous pouvez en savoir plus à leur sujet en allant sur
 * {@link http://codex.wordpress.org/fr:Modifier_wp-config.php Modifier
 * wp-config.php}. C’est votre hébergeur qui doit vous donner vos
 * codes MySQL.
 *
 * Ce fichier est utilisé par le script de création de wp-config.php pendant
 * le processus d’installation. Vous n’avez pas à utiliser le site web, vous
 * pouvez simplement renommer ce fichier en "wp-config.php" et remplir les
 * valeurs.
 *
 * @package WordPress
 */

// ** Réglages MySQL - Votre hébergeur doit vous fournir ces informations. ** //
/** Nom de la base de données de WordPress. */
define('DB_NAME', 'wordpress');

/** Utilisateur de la base de données MySQL. */
define('DB_USER', 'wordpress');

/** Mot de passe de la base de données MySQL. */
define('DB_PASSWORD', 'w0rdpressp@SS');

/** Adresse de l’hébergement MySQL. */
define('DB_HOST', '192.168.54.9');

/** Jeu de caractères à utiliser par la base de données lors de la création des tables. */
define('DB_CHARSET', 'utf8mb4');

/** Type de collation de la base de données.
  * N’y touchez que si vous savez ce que vous faites.
  */
define('DB_COLLATE', '');

/**#@+
 * Clés uniques d’authentification et salage.
 *
 * Remplacez les valeurs par défaut par des phrases uniques !
 * Vous pouvez générer des phrases aléatoires en utilisant
 * {@link https://api.wordpress.org/secret-key/1.1/salt/ le service de clefs secrètes de WordPress.org}.
 * Vous pouvez modifier ces phrases à n’importe quel moment, afin d’invalider tous les cookies existants.
 * Cela forcera également tous les utilisateurs à se reconnecter.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'Mv|_|@&2u[R~={!4`HceJR*vzA4=gO0]fb(_N<L8}9+N/nQKy([5K9@nu%w{4K2T');
define('SECURE_AUTH_KEY',  'O-@:QAenY}<ma.o%Np!Mi[gpPp~7_khdny;/On#+zOM$ZEgvG..$PrhiT_lk`Mom');
define('LOGGED_IN_KEY',    'k1@L=k{O]E#O{9[96pqH o=KQRH+Uw,IV?{u6.8rseQVb#cE{7)h^Vl>GV7L<-@/');
define('NONCE_KEY',        '- @.1|hrpOC7B>-ju|Z*rOq/}>4uZF/*pj*b#8rU,U,wKKzKqKXpXCxgDV8T%u:@');
define('AUTH_SALT',        'HT|5z=Gg$DJOeMW5!sP-nXD/~2bG*rki3@iq;X)t_14RuN*caR#YF9JJ`HWRZe]0');
define('SECURE_AUTH_SALT', 'K@hw.1lT(KPbGg^Go[5d}o<Q_mex0>-xpQ^vbs6WIKhivjvWM%b=Qg(P8o9/Br2w');
define('LOGGED_IN_SALT',   ']vE]C]AfdNsPaHso+o.y_vB>//r]1:yhf,Y?Px;v:S:JM;df6qprhmg`YDD>Rfh{');
define('NONCE_SALT',       'zPI2Vm,r/,~K7N-u,n]+#m,XlX=y%3+RQ}xEP2ta:/,r@+lcX%J.@s4=q76%J),9');
/**#@-*/

/**
 * Préfixe de base de données pour les tables de WordPress.
 *
 * Vous pouvez installer plusieurs WordPress sur une seule base de données
 * si vous leur donnez chacune un préfixe unique.
 * N’utilisez que des chiffres, des lettres non-accentuées, et des caractères soulignés !
 */
$table_prefix  = 'wp_';

/**
 * Pour les développeurs : le mode déboguage de WordPress.
 *
 * En passant la valeur suivante à "true", vous activez l’affichage des
 * notifications d’erreurs pendant vos essais.
 * Il est fortemment recommandé que les développeurs d’extensions et
 * de thèmes se servent de WP_DEBUG dans leur environnement de
 * développement.
 *
 * Pour plus d'information sur les autres constantes qui peuvent être utilisées
 * pour le déboguage, rendez-vous sur le Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define('WP_DEBUG', false);

/* C’est tout, ne touchez pas à ce qui suit ! */

/** Chemin absolu vers le dossier de WordPress. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Réglage des variables de WordPress et de ses fichiers inclus. */
require_once(ABSPATH . 'wp-settings.php');
