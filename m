Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaFVKw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 06:52:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53383 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaFVKwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 06:52:25 -0400
Date: Sun, 22 Jun 2014 11:52:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140622105205.GM24291@sirena.org.uk>
References: <1402238742.32652.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FxlYARId5dseejUu"
Content-Disposition: inline
In-Reply-To: <1402238742.32652.1.camel@phoenix>
X-Cookie: This is NOT a repeat.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: ab8500: Remove ab8500_regulator_of_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FxlYARId5dseejUu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 08, 2014 at 10:45:42PM +0800, Axel Lin wrote:
> Now this is a DT-only driver because non-devicetree probe path is removed,
> so merge ab8500_regulator_of_probe() into ab8500_regulator_probe().

Applied both, thanks.

--FxlYARId5dseejUu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTprVSAAoJELSic+t+oim9I2YP/0AyWlIYm4h8xP2CO67YsA+h
dpPEli2PMNyO1aOwwMADBsrQJear4xkxrsHXmIF/sjuVbb4aWoFiQidjlEIdvfrF
z8hPraOjfEH7KLZGqPWUZbdiz23FUItuiHrSUeip4ZHRrj2Evr02Yuy96QgVPvD/
uqSMAZsruGlq3TMecOROfzslxV/K9V4N5OupS8ek/EHhWVghgtXTwQSdJgueo/mb
6BARSDIfhsdlYxwdr09SJM1MPYabrj/VYHUYT+rzSH0TGS4aE8Ei9fBJAkjpJoaF
WjV9Zqb/1DyHe7xkp21OtmQLZelcg6DSmXUAp7zejZ0S/zkJrOUbuntiU718X3ZS
cp5hm/kAlSsk7aNQH2G+ovGPtfbRwRrAH1SHFYSDT0/sxc/n/NGQxHpcTpbyck2s
d9y98Y/CjNugrQsZsBMda2D5S4FMPxsK5679cc6Ar0xd/q0KQtNPnXeDpvKEDHA4
xhhUGvFGJvH08lE2gCP4Hi7skKgvV1ULwch0y2z6TJVBZwqjHxp9yQS627IhZlaj
TNpY88tQ86W9GUjuRr4diw2pD4WBatC/CpT0onP6Z5P6dNAAupc4YajzM6twCttB
aPgO61JxPkiPfRJW4ymKrz/wzyxn26MPgmYrcvmBXZ6mZDIobJ+v0jYxCNzy5suF
SKkybBCn04rYCAUw0J5T
=i4d9
-----END PGP SIGNATURE-----

--FxlYARId5dseejUu--
