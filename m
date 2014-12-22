Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795AbaLVNqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 08:46:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43916 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184AbaLVNqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 08:46:38 -0500
Date: Mon, 22 Dec 2014 13:45:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222134551.GO17800@sirena.org.uk>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
 <8f40608d5665e80bfd3e9723784ec3bc2078e0d2.1418826016.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zipuvUKAEymKn2g"
Content-Disposition: inline
In-Reply-To: <8f40608d5665e80bfd3e9723784ec3bc2078e0d2.1418826016.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/5] ASoC: dwc: Ensure FIFOs are flushed to prevent
 channel swap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zipuvUKAEymKn2g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2014 at 04:18:05PM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> Flush the FIFOs when the stream is prepared for use.  This avoids
> an inadvertent swapping of the left/right channels if the FIFOs are
> not empty at startup.

Applied, thanks.

--6zipuvUKAEymKn2g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmCCOAAoJECTWi3JdVIfQMjMH/is0DkMuFODkJSyTCO60aAmm
NIbsRZR7zFY2f86spS3JzQ2pw0SKPSIw2OrCIqiJY8KxqjUbQAuJAeCYRooCKGMU
AiX8bxsQD9lAKYI0N63RL4mB5Wj5ZakIR19eaFhqvgugD8UG5Gm70oT5LMrbeV3B
MquDsWJyPqxmlFa12+ulL3lNcZUl0MvjFyoK3ww5NmSHQq1NJouWZ8oouzr79vXn
pEE1hxwnhEPS+e8hARsJ5fVU8/jbr8lsClLLoirf2kbRCp2gVJ2SDnQrIaFBGK7/
0dduTfgyfuPz/JmfWVERWF7RW12DfM+X1f96pmLZTyOf2HA98UpMQYU3WLyiaSE=
=r6bD
-----END PGP SIGNATURE-----

--6zipuvUKAEymKn2g--
