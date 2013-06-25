Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3FYJM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 05:12:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54127 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FYJMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 05:12:25 -0400
Date: Tue, 25 Jun 2013 10:12:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Chao Xie <xiechao.mail@gmail.com>
Cc: Chao Xie <chao.xie@marvell.com>, lgirdwood@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        yizhang@marvell.com
Message-ID: <20130625091201.GW27646@sirena.org.uk>
References: <1371713467-3256-1-git-send-email-chao.xie@marvell.com>
 <20130621152416.GC27646@sirena.org.uk>
 <CADApbeigFTQNhxR-CVBGUhXvg+jVtt7ZVvEHuKqeSA80CFz-dQ@mail.gmail.com>
 <20130624101454.GG27646@sirena.org.uk>
 <CADApbeh7upEmy7URYvoMdU0jUR4qC-a+AErH5ND5QG5xwVdAdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aNCdKw9zdX/rqzEJ"
Content-Disposition: inline
In-Reply-To: <CADApbeh7upEmy7URYvoMdU0jUR4qC-a+AErH5ND5QG5xwVdAdg@mail.gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] regulator: 88pm800: add regulator driver for 88pm800
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aNCdKw9zdX/rqzEJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 25, 2013 at 10:13:38AM +0800, Chao Xie wrote:
> On Mon, Jun 24, 2013 at 6:14 PM, Mark Brown <broonie@kernel.org> wrote:

> > If you really need to have platform data for all the regulators then
> > just embed the array inside the platform data so there's no possibility
> > of any confusion.

> Some regulators will not be exported to kernel depending on boards which are
> for special usage. So i do not use a array inside the platform data.

Remember that the regulator API won't do anything except read from a
regulator unless it's got constraints saying it's OK to do so.  Are you
saying that even reading the hardware state is a problem?

--aNCdKw9zdX/rqzEJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyV7eAAoJELSic+t+oim9Ri8P/j6uuySDi7YGrmeyGBSDLvVO
pvo6iX1dSNoUpgMmYrGVVoV84GBISyVCrXJl3LxzgmSCpHg8pT+qH41ocNGLfSvd
xTfDvjadIz3AoPBJWPzHxb4jPWFUC6WjTojImRjYsqUuPx0Qgl5B+Jh0b5mKoZkJ
pMgFw1WPZCDEmoI6vEFTTxeDBOn86cmdURGO4rEbTVTMOYZRwjRQ1Q23zL4QbgjE
+MWB56ngqbHwgXY5jcrVbEjle0FY0pi6JVdRelgJz2bD1tjNAMprgKdJ4SPFxrbY
mQumwesq8AktPgfdeX7lUApfV2Ok6c3lv/Rg3mqB6+0pgnwx0KQfSmTmPETINkz5
a7tcfDIamBNKnXd4ENMOgGd9qaEjuZfNCEUFUrV5PuvHW8VJXEFTSoavODOhaZRP
7cOoM1nDH0zr60F0CjbCDhLhxCTbChSHyuLs2goqwvoCaDJpmPzGNxfb3XBIsN6t
njdneRHBqXrOaB4SVjysYsRPZfHnryLKWnjkXd6VcWKMtp3OHNhtv/cEPgGiACqZ
+aYLJ9r/9fOeozcbTDJhHSfogG4gyZHRNB8lzny67pEt1ue319tzY2Sh6ujexG0D
KNweSq83XML2ae+itXi8shGCBwAYFgYS4zUbfzCDucIAemv2ITgnDJlnMFUf4GlZ
wIkTl6qyk2Fd2m8o1sVH
=O0h5
-----END PGP SIGNATURE-----

--aNCdKw9zdX/rqzEJ--
