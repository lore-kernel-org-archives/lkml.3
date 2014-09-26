Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbaIZKaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:30:23 -0400
Received: from ozlabs.org ([103.22.144.67]:49138 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754960AbaIZKaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:30:19 -0400
Date: Fri, 26 Sep 2014 20:30:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Sebastian Reichel <sre@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: linux-next: manual merge of the akpm tree with the battery tree
Message-ID: <20140926203012.1d150cd3@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/p9bA17IZEtg9wnoRSjQPks8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p9bA17IZEtg9wnoRSjQPks8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/power/Kconfig between commit 6a91e854442c ("power: max14577:
Fix circular config SYSFS dependency") from the battery tree and commit
821246576e03 ("drivers/power/Kconfig: revert part of "charger:
max14577: Add support for MAX77836 charger"") from the akpm tree.

I dropped the akpm tree patch as the battery tree patch fixes the same
problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/p9bA17IZEtg9wnoRSjQPks8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJUA5AAoJEMDTa8Ir7ZwVSGAP/jTc5v+0AguuS5XIJLzZltZ9
AhOl6DA72usjjmOe5VimKAaZPTohYKMoWh7hYOOQqbSCyJpxcOGzGgRkxN2vtSha
CMFJ0qDMoEzN26S/gvP8WWvN9WgnmNyoXE6iyUpE9PJ7xahVrKVJRLIyokoh8HxT
Fl57bMvhUoqGfzy3a6eenrEHILDeeZKMef5dw9lacqb8S/GFa2G5eHmUDEQuXv7u
TBz/aJqIFW+g42dGPmZVUwR9zGYsKbiXTrBlAWaWCykMtQ/y7YQd8DzBzf9Rq/Tc
UHLKn0ZFHaBZKo/s3UAdZHeQvR9AokaYc5OW2y1i8vdu8NkWV4V4UB86dZNVkqTc
Josd056qidx+rQj+r7/akbQBMnnXEHzwF+tgNJhkPdZVU5F7Lbgk3g+oL2w9J1lT
mq7BI9G6R6TMyb3Vb6PmF1e8tZ6M6/J5eub2O/eoSaEMFXv1XT4TnM6Yq6rS0Rej
NKKSnvkzoUroNVlcfEdYvLiPLpXptoA3SGzfTaDM+Mqx5t2DeQSW8DzAY4rAURvV
tqwFcPukO7qi2ORHdg1fTzsQ845Dx08bwlGYBu2ruJM71HoYKfH920OY7ws+TvQj
fH1g3sQ9GcKNBMzu+Xsl1MTwEWQ/eetvAPr/MQ5JVA+RkO08eKd93Dz3DmfkwcU3
FunLU12lP2Zf4DXohvfN
=0DTc
-----END PGP SIGNATURE-----

--Sig_/p9bA17IZEtg9wnoRSjQPks8--
