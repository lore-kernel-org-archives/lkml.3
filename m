Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaLCHBj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:01:39 -0500
Received: from ozlabs.org ([103.22.144.67]:35942 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869AbaLCHBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:01:38 -0500
Date: Wed, 3 Dec 2014 18:01:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jyri Sarha <jsarha@ti.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: linux-next: manual merge of the driver-core tree with the omap_dss2
 tree
Message-ID: <20141203180127.2970ff3a@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/9good=_Lc0ia8j3enFmcxgD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9good=_Lc0ia8j3enFmcxgD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got conflicts in
sound/soc/omap/omap-hdmi-card.c and sound/soc/omap/omap-hdmi.c between
commit ab387c1e51d7 ("ASoC: omap: Remove obsolete HDMI audio code and
Kconfig options") from the omap_dss2 tree and commit d34135b4c0ef
("ASoC: omap: drop owner assignment from platform_drivers") from the
driver-core tree.

I fixed it up (I removed the files) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/9good=_Lc0ia8j3enFmcxgD
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUfrVMAAoJEMDTa8Ir7ZwVuNUQAI4Bibx+xUOZbv1l2mGBDTY2
6lxkUf64x56l+NtwjWys5I8l4x45xQ4ZT/LwUOh3PaLpbBqZKi88zjd7lMSE4Bnd
vIQPuAEB5SICTEUYU34iBFJKZks9e8IHuhtu50Fq0gaxvBcdFq9ROeF0f+wn5aTn
REOuLUSXOvYxmbfHt+UFXbk+WXtcX6KF03/JA1AURIa+mlyIZazDdM7zI2MTX6Hp
DmA6kqr0daQBTrG3l6K/hy2Ivw0O5rK+aEFFu4qLOqoY6MjZ6J+iW7njXUKXjffs
zFX9HPobAVwV8PxBvw14RGL5DayF4dt3DIkibEtSEzFZKIjF7cNkDUyHuhWl3m9O
uZecbKxJYnFyNW7FMFOykeFqry+y+XFeRqkxjFY7EA3ZWGuVY56HOgG06LS9T12B
Wo5eZ9NP3CUDFeuwwm3zwPnyUAyABmIixK+U7ezvmcX7SpLXp7iucYHEegANoauN
pwgPW/oj3327fuDYuD11WexoD7JcUL03eOnQXSPqpQR4W+InutgO0MjbECkbmKyK
5oHCbIMGXf/d86kFDV3yb1jwVuei7q+PXlLLPQNESR6ihPuWK6bqmDNzmD703o+y
+D+KMc/lEj+3O2wlrCL4fMZmiZozDBUKcZCZySvOS8Io+Q+AG6XUq0eUDb1I+Boc
Oj91/ROdRz1A5Y/XQQQx
=z65z
-----END PGP SIGNATURE-----

--Sig_/9good=_Lc0ia8j3enFmcxgD--
