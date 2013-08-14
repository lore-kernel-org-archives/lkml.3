Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673Ab3HNSPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:15:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37268 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455Ab3HNSPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:15:31 -0400
Date: Wed, 14 Aug 2013 19:14:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Ben Dooks <ben-linux@fluff.org>, kernel-janitors@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130814181455.GH2401@sirena.org.uk>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376471493-22215-13-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FK65GREB+Evh/hTL"
Content-Disposition: inline
In-Reply-To: <1376471493-22215-13-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 12/29] sound/soc/samsung/ac97.c: simplify use of
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FK65GREB+Evh/hTL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 11:11:16AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.

Applied, thanks.

--FK65GREB+Evh/hTL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC8kcAAoJELSic+t+oim9VPoP/2AtXDR4sUam3Yv71XQ8x5Yc
Wj2NqbV2IewRM4CLzfouBfaOiKM9DrquVSNy3/QTXiQ1aCtt1vWqnkoxffoW62cj
NUwTJfAgZ2xb5lidFYnQzkBOXMlIEcxgDh4nLODwFSvrdRHVBoZZlxWNjK60bJcq
mOdwe/iYONf6iu2vz3Lbire4lQZXlz7H553EeeZ+xdk+xxuOW7jI2lCdpfZ5qm8c
vxUzv3v4CtGNJf6oT8czFN8kIILZlzR7q3XI2s8gJNMKR9pNURd1O0kTHEl9wXGK
4geOMZ2Th0K+fCR2Fo3ekEbs5MGlXipqgg3RI5IfHdnOXkpO6W6Ifca1M9g3TcRB
JjdKyeoF1CKbMyJrd2kBccMoOspZaLBLQmgGhtQSULsGAgf8zaLrW44ayZsyoBRd
IKmCE3OKRrXAJ5IDLFoBteYVnMT7HbzyjbZekPAzUFnkTg2Z+ncLIsxg9L+TvXZR
5hZgbWsS70nR3xKvuAD0nyemRPq9bnuE8KVcVbpGjIknU89rDG4vA9GKhaOEdEXU
VrUHvH8OWFq/6lsMPefpWEBuG9Il3BtiZD7Rx9MWua6A6+MMRHZRrBuZiZZJhg3w
r8h44z87huOfnYomNR2fDgLaoCNoqLoF8bymhsB5SANdTC8D2I3hvUWEfHvZP7El
7kO+8Fk+B+1CcR3UgzR3
=DU1Y
-----END PGP SIGNATURE-----

--FK65GREB+Evh/hTL--
