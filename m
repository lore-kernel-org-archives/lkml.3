Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3G2Fuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:50:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59051 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3G2Fug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:50:36 -0400
Date: Mon, 29 Jul 2013 06:50:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Robin Gong <b38343@freescale.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20130729055011.GM9858@sirena.org.uk>
References: <1375070881.5721.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="16v/2qlBd61GVM3u"
Content-Disposition: inline
In-Reply-To: <1375070881.5721.0.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: pfuze100: REGULATOR_PFUZE100 needs to
 select REGMAP_I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--16v/2qlBd61GVM3u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 12:08:01PM +0800, Axel Lin wrote:
> This fixes below build errors:

Applied, thanks.

--16v/2qlBd61GVM3u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9gKQAAoJELSic+t+oim9NIoP/1vQAu9Ov9g66JZhxxNrKART
h+pMFptar1T325SDcFe4fRSeC04C9aLMqGEqbTzNlx8LY3TOuIevbGhZoUP+kGTq
F2JqfOuMWbcBH14ZzENjSaSwtF0nnqa7DaWk7gbIkxD9OBFIw9/mBBVtcYM5tZlA
9YuXVzU1Z8dD+jjPIMuM1aRaZLFFL9J7uuKr5FrRYJ1xHWVzCWJ1tDJ5i/ZjAkBs
0992fORQqxSCxsvHz6F7yTnPAvC3Tic0ldfLyfTr8DrUclr+uu/gEMz/CxEVywyS
XHNgywubIyj/XNoDVymDIwfA7Oc4mmrb6ns2C594iBqbnPvxEDwxWGBZLwPLXaCj
NEUie+ci0IZ20rt0IRSycWURH/6PdPThQpqih0L9DtW/lKMWyVFVV7fZu2yFdh9b
XRGlpRAAmMJA+di8SO1RBYpUoRKD7af2NXi2AemhUMs68BjFjDiI4XmaNsfpftl5
uzKblWZDHS5qdnjKVgyRmTkIrQ1WE244Jb5VddDKINswxsX0XaD8XlemeXfdkRSV
teTahQGOm7XPohPkAq42J1VtoLpjow2WMojq6/nMZrXC9blnsYyHEVhjGKjMwN3x
pnmmKTNTTBXQS9zA2wuIwF5LqU4qRl+vmjpxWusKWH/TtZqBJD2zwocO2MvFtxNQ
GSK6418VKx0XXDZ3ze6s
=8bwW
-----END PGP SIGNATURE-----

--16v/2qlBd61GVM3u--
