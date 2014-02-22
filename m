Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaBVCtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:49:22 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48757 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaBVCtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:49:21 -0500
Date: Sat, 22 Feb 2014 11:49:03 +0900
From: Mark Brown <broonie@kernel.org>
To: Nenghua Cao <nhcao@marvell.com>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20140222024903.GL25940@sirena.org.uk>
References: <1392969945-28004-1-git-send-email-nhcao@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xjamM5M9kpPM/bcu"
Content-Disposition: inline
In-Reply-To: <1392969945-28004-1-git-send-email-nhcao@marvell.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.103.222
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] driver: regmap: fix coccinelle warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xjamM5M9kpPM/bcu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 21, 2014 at 04:05:45PM +0800, Nenghua Cao wrote:
> From: Nenghua Cao <nhcao@marvell.com>
>=20
>    /drivers/base/regmap/regmap.c:717:6-33: WARNING:
> Comparison to bool.

Applied, thanks.  Please use subject lines consistent with the
subsystem.

--xjamM5M9kpPM/bcu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCBAcAAoJELSic+t+oim9uE0P/jdwZga0DHX2tU3TntovE29D
C+MT1t4OmRKja3UCVrcGFFei2w/OKmpfcM472FkuffHbKDV23TzEmWHFcdDcHr9r
j1/yN0ayAeI6wNw0Dvba/RGPlkReASAdbjU6UCFCoosLH5p2uUtm54lRhD52D1kL
tiSsTwMaVh7J0NxRgrkxHQetu9HAHOqpG27iL5OAwiufRst5XYfOZiJ/6wY05Lgd
S8R+Cyeqr39+yKmqtIymLmrLsORIhHZ7WUCYNWYMm4su9b0vNa1LECuxSDiktWLv
FsgxVpTlc0OAN4u9imd119sI+MzLZfTUfu+FodTY4Du2O18rOs87PiS9l+2lzoRz
vdVoZjnibwZW1JyVeO2i7KLiXp3UUaa7GoBwHJigcIA9yWdI0ZMwi6NBjhVHml5m
B6p7MMa6ow+TDAazG40H/H8d2lLcbyAxDHEtVVy7oz6aMRvwvB2xgIXd4eUkrsKw
4uf+TbHqBx7N9gio1cezXvvRLG5PDZiaSXBqsnOcziM9Vi2urbrUUtNprIkNschA
BoyS0epR7sdGDRPUk2Zr5EaCBp2+eKdLlw50xF7rTwa7qqwsJR2/lYuhUeYpM8CZ
HagY+bRZasy0GQ4TiqgMQTVh3CbEvn5JswjOySndg8cHVgFhycpTCb3wuLBwAulG
PDw8gMW9CcJEX3Sv6LRS
=1k7j
-----END PGP SIGNATURE-----

--xjamM5M9kpPM/bcu--
