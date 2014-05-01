Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaEAUbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 16:31:46 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54520 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaEAUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 16:31:45 -0400
Date: Thu, 1 May 2014 13:31:27 -0700
From: Mark Brown <broonie@kernel.org>
To: Xia Kaixu <kaixu.xia@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd@arndb.de, Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20140501203127.GE3245@sirena.org.uk>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
 <1398770316-19715-15-git-send-email-kaixu.xia@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="t2l9rd8t7n6opnx1"
Content-Disposition: inline
In-Reply-To: <1398770316-19715-15-git-send-email-kaixu.xia@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 14/15] ASoC: Amstrad E3 needs TTY support for codec
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--t2l9rd8t7n6opnx1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 29, 2014 at 07:18:35PM +0800, Xia Kaixu wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The cx20442 codec driver used here requires the TTY layer to
> be enabled, or we get a link error:

Applied, thanks.

--t2l9rd8t7n6opnx1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYq8cAAoJELSic+t+oim9aZMP/intw8UovuN+r4QorrtyW/Nc
Qqu69xEmjbtwg3J47hsfdH5F4rNHVpl5hYR3tUbhGp3aHEIxog9rIRRqhFzAL2HL
iISrsEDF8lxaLM9+w/C/eiZHJy939anZ6LeXEJk4SLHTUHbzPc+v3dpTKCYJFdDc
7Drsxb/nt8UMwkNk/a8rXBw37QlLZLPaivIiQNQCqaI249zPk/5SS7aW0fPhcNh2
JF57JDXpLyMka0vSTQYlD+tTF8bApF1GlO/34gEq9RbJv8GiPM6G+gulX+us9ftY
stMFAqxqQfYlq9P5mWHXC0/Byc7a7SebryWVlkoCY20VUw9goKTm1QPSb+Lcx9ez
et40p3pYQLBasJu/RVIEslXvFZmFqsR3x+LQ14eC3G1nMEMjmqWE22PxVcRn5jGc
l8Csc9/T0YsDFZ+cT76CS0DKeGZotZj3OM81Yl8WefLL9//D+WkOKOeiLpG/3INj
//MOSIO7D+WmOHg7UpL6Tv9msEJ2VxcqRAmChCGJp1zap19sNgAytNhFOWuOaXQd
RXlfIAmSpZtrnDN1ybJAGZYhGYSO1/AZth7yv2DD4W0qiiK6vmeHdi9ROwDrHVNU
73+k7XetyVMjOCAM34PutHL9Q723GD5rUYoW9DR8mafNVgVDjOcXcH3rIjRU/16V
2ghJVadTxZbnLynyNpU1
=0lRq
-----END PGP SIGNATURE-----

--t2l9rd8t7n6opnx1--
