Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaHMLOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:14:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33228 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaHMLOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:14:44 -0400
Date: Wed, 13 Aug 2014 12:14:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, kernel-janitors@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Message-ID: <20140813111425.GO17528@sirena.org.uk>
References: <1407492475-26283-8-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kfy0q0s2rBHKMG0i"
Content-Disposition: inline
In-Reply-To: <1407492475-26283-8-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 8/14] ASoC: rsnd: delete unneeded test before of_node_put
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kfy0q0s2rBHKMG0i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 12:07:49PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Of_node_put supports NULL as its argument, so the initial test is not
> necessary.

Applied, thanks.

--Kfy0q0s2rBHKMG0i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT60iOAAoJELSic+t+oim9Qu4P/02dlKJ+WIXGN3WoYbKUQWZ5
ZMMcea2h9M2pCz4A5MNmfgW1/SEX/bu6W0+Fq2FrIkXgFdH8GxSM3y8E/lKXuVLS
nTZXs4PfKf2cPtoRf/PTHskcCiyV6A5gpp9Z49iheGmzgGVwOTgZuHHe44e5Dz5M
UyE+haT6L5PZ22FaRXi/R0V6bqJdZKaRKjM6qTfatRGS/b3lq96QV5zl9CsSOeoB
q5xIsMJC4Ji0Us2MRk/G+i/oRqXGTvU4xEv757nwfObUrKbcHU0eQ6fEULGk7jVB
Xq/XyQk4oGYpf4SnOZsqr09+VE1dX6K0X074MFIKKbl+CzZ1UnZmhkYlO00MlLYK
PqaMLVKorHupYIRzoj1pgzGVYW0RfTwYOZ9RWtnk4gHdGVv7SZ0oIR/O26felrgf
D8A1roJs15vQ3LynsD2D9eIRa/2XNNd+lt8jXsJwNVS/JZCPU39IWmeULMvU2QdZ
aTlZdbO+Y2ztbS0fWHAGAMLdlw/YefxWWZ8K7X0fm7oRWz7TL+mtxOPF5yaVARyg
pZ2S2+vq5+ffKcwKu74e0lD5gWx7+TBFZJem4m3saLqZ32cuNsKdzPlV1/K5trjQ
sP3HGS5yUM4rPZVduKxmEFz0TPvj9XZRWhQtXCKtraKL7rzvgHKxBIBiANFdx0kC
3/vrdSylDWhhCovG+DAy
=0zvg
-----END PGP SIGNATURE-----

--Kfy0q0s2rBHKMG0i--
