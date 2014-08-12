Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbaHLV4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:56:24 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60502 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaHLV4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:56:23 -0400
Date: Tue, 12 Aug 2014 22:56:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Anuj Aggarwal <anuj.aggarwal@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>
Message-ID: <20140812215607.GD17528@sirena.org.uk>
References: <1407807670.8958.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbHJDalP8mx/Yvoe"
Content-Disposition: inline
In-Reply-To: <1407807670.8958.3.camel@phoenix>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: tps65023: Remove duplicate test for
 I2C_FUNC_SMBUS_BYTE_DATA functionality
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbHJDalP8mx/Yvoe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2014 at 09:41:10AM +0800, Axel Lin wrote:
> Since commit b42261078a91 ("regmap: i2c: fallback to SMBus if the adapter
> does not support standard I2C"), regmap-i2c will check the
> I2C_FUNC_SMBUS_[BYTE|WORD]_DATA functionality based on the regmap_config
> setting if the adapter does not support standard I2C.

Applied, thanks.

--VbHJDalP8mx/Yvoe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6o10AAoJELSic+t+oim9IhwP/RUUYiuyL6QD/qq2QyHuaYaG
iFRH+34Pg/XxO1Eqxs8wN9L9HBOhuiPhImQSetTeKz1tr3/dfGUDzBqtT4Vaj3Nz
OFfEApo9rsHUzg4LM5qANOjT0HAdj4+ukmp1BiPtJbhiYjYikh0KMaXVqPg5qBGP
AS78EpHiKOGzXHkvUFXsW7VA/wUfpDhNeB4qITuisCEp7IPfMO3ja9+vspOCeix6
mBXToEFiaG+4qGgvttbbCD7S8B0YCucSzWBPA055qvfzbna4tnu9hN6ZGkRNeQA5
JUo+6vqw0ygYUk8825MGW4rgbeyibRk6pVpEoicz6wRCdmpgQGNYJvdCFKlBLPeo
0a3ohJrCbkv8BUfXF/eTsik6X/uftd0Whep/BOxd96oucZ8GrclW1OQZqibeOz/o
1UD//askZx4MEs4+oJJ2px9vzKs4MmpLAfEWUuFIZjnbYfR9m5RTSIBEeXz2uVnO
Ygz9/UNDBMOtOafdjCrcheSM9+eUXnSOQRlobbTwzfQraOD5r3jOhe9cGiiDGhyA
dV6NuVhQ846ZzvOieBA6dB+t3YPzCRQmtc2an1kE4UGPYTGw9QcIHCl5eqOpo/pV
HLeaS9Udo//ByoMtkh7ZsAlKpqZEZY+JqVpZm+YQvFVHc0f6Hc9Ld2kJ811XqJpE
bZ/KLvlMdMBCBtcq0EKu
=NSQS
-----END PGP SIGNATURE-----

--VbHJDalP8mx/Yvoe--
