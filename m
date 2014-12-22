Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaLVPGx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:06:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44052 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaLVPGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:06:52 -0500
Date: Mon, 22 Dec 2014 15:06:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Jackson <andrew.jackson@arm.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141222150611.GW17800@sirena.org.uk>
References: <cover.1418826016.git.Andrew.Jackson@arm.com>
 <67cea1f0a74c333ec2048c7796cda37302d45e95.1418826016.git.Andrew.Jackson@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Y6L//1es8ezVqBy"
Content-Disposition: inline
In-Reply-To: <67cea1f0a74c333ec2048c7796cda37302d45e95.1418826016.git.Andrew.Jackson@arm.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 31.51.36.65
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/5] ASoC: dwc: Iterate over all channels
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Y6L//1es8ezVqBy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2014 at 04:18:06PM +0000, Andrew Jackson wrote:
> From: Andrew Jackson <Andrew.Jackson@arm.com>
>=20
> The Designware core can be configured with up to four stereo channels.
> Each stereo channel is individually configured so, when the driver's
> hw_params call is made, each requested stereo channel has to be
> programmed.

Applied, thanks.

--/Y6L//1es8ezVqBy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmDNiAAoJECTWi3JdVIfQX2UH/iT2iPHru0FaT/pmSDbvDLpc
sAHQuWm3pU68wujAMKiEFvcZq0L8POUh7ISWOWF4h4Y8bez+7acPTb95E+2wxRe+
AUmuOUItU3oh2rv4BZcxT0nqbD3g8G6Kudz56ffJ1Ir9du/syZyt4vZHmaRerHZF
/vROh3Ccdk2xlw2CadCYvNzWasM6DeE2QnzhTxTZmQtQjdBocXMVgkavuKusomFp
kr4KFK5W52HWr/0www0UWMZYhhfLW5PRasgnit4PNtBXJeoaxwrH4pguYQhnU8FY
sNJaZre8cbl7uhFAcUU4vYPyMhxhg0N5geaR7RAz6ygbPLc0cuNE15DkTQya/40=
=/Mrt
-----END PGP SIGNATURE-----

--/Y6L//1es8ezVqBy--
