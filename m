Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaIWAz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 20:55:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58050 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbaIWAzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 20:55:24 -0400
Date: Thu, 18 Sep 2014 10:57:52 -0700
From: Mark Brown <broonie@kernel.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140918175752.GC7960@sirena.org.uk>
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <53C675E4.4020502@samsung.com>
 <1409825105.5546.91.camel@x220>
 <201409041802.36466.arnd@arndb.de>
 <1411033409.2017.15.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iq4NytuvSVzaNT9H"
Content-Disposition: inline
In-Reply-To: <1411033409.2017.15.camel@x220>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 166.170.38.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: samsung: Remove goni or aquila with the WM8994
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iq4NytuvSVzaNT9H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2014 at 11:43:29AM +0200, Paul Bolle wrote:
> On Thu, 2014-09-04 at 18:02 +0200, Arnd Bergmann wrote:

> > I think it would be nice if you could submit a patch to remove the
> > drivers from ASoC, then we can see if anybody complains.

> Same thing for v3.17-rc5 and next-20140918. Let's see if we can remove
> the goni or aquila with wm8994 driver.
>=20
> Done on top of next-20140918. Untested.
> --------->8---------
> From: Paul Bolle <pebolle@tiscali.nl>

Please follow the patch submission process in SubmittingPatches.

--iq4NytuvSVzaNT9H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGx0gAAoJECTWi3JdVIfQ0dQH/0LObx/SgUOIE67+W1gel4jL
FBJb1yYOLmdCAIpEt3jkJj+FC0mQr+2bicV04wFdJe+WSeV1NMLfZvdgdZjTAaIe
u+w4sulgebk+AhPHlTHjHVqP4OfdOjnRSqk1IPTqBBC0aoD1YWXSTvwJk5/a+/lc
eTioE0v620EQIOM5HuVCtk0yBjXfxjdw4XextM7iUZcTTXWBP1YLCMJBrCSLUcyF
iIuqpbuFEHV2sb/G5ZCadRnEicY+4DB/Z+ecSazt4zVIlyoNPEOpQE55ActlgcAJ
M4IhpjWk2hB37CH8DAMoJnEhJmWVTBfz7yYoN275TYxRWLgGHrB27D1YB0JoaVU=
=Arz7
-----END PGP SIGNATURE-----

--iq4NytuvSVzaNT9H--
