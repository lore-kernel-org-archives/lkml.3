Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaLHUq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:46:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52335 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaLHUq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:46:56 -0500
Date: Mon, 8 Dec 2014 20:46:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Message-ID: <20141208204632.GE11764@sirena.org.uk>
References: <1418052791-4257-1-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TXtjXAp+Y+VkYOQB"
Content-Disposition: inline
In-Reply-To: <1418052791-4257-1-git-send-email-peda@lysator.liu.se>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: pcm512x: Trigger auto-increment of register
 addresses on i2c
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TXtjXAp+Y+VkYOQB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2014 at 04:33:11PM +0100, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
>=20
> When the codec is connected using i2c, it will only auto-increment
> register addresses if msb (0x80) of the register address byte is set.

Applied, thanks.

--TXtjXAp+Y+VkYOQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhg4nAAoJECTWi3JdVIfQBFsH/jgZKWh1oR94M7ImgAm7YCet
3P2ZpHql2rGjNFwilWNr93NnrNxvXuo41ZwzERjBWwbhGndbCQMeDGAKEo6ZQEOr
zv2MiAd0PXMOhffTBFmn0tT/PLSMPJbxiY7k2Fb9xaeekbt3yoNLP5LLVKZQSFHq
uWfpTXJ/Reip0O3gQtste63c4WzXyNwimnbHuEb+bnezSi1lw9xLiZFLD2cpR/US
S0AQf0xSCAriDHblAExVTXgAfK0IVBW+/HAT9o7XP3yTlzfIiueexBzYlt1NWoPQ
1wQQnfZ25ewnxuImp7q5o8Y0pmSkB1Vhe5n5HeLTSd2XdOOTlN4vIAjve597lq0=
=KhOD
-----END PGP SIGNATURE-----

--TXtjXAp+Y+VkYOQB--
