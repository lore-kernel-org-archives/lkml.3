Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaB0Hqm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 02:46:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52627 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaB0Hqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 02:46:40 -0500
Date: Thu, 27 Feb 2014 13:52:05 +0900
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140227045205.GQ9383@sirena.org.uk>
References: <1393324819-3810-1-git-send-email-geert@linux-m68k.org>
 <1393324819-3810-4-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Evp0T6PXIQ26qRMT"
Content-Disposition: inline
In-Reply-To: <1393324819-3810-4-git-send-email-geert@linux-m68k.org>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.133
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 4/4] spi: spidev_fdx: Add support for Dual/Quad SPI
 Transfers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Evp0T6PXIQ26qRMT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2014 at 11:40:19AM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> Use SPI_IOC_RD_MODE32 to print the full SPI mode, now in hex.

Applied, thanks.

--Evp0T6PXIQ26qRMT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDsRyAAoJELSic+t+oim9GjUP/2fQ6E7ALW/ssUUvwdrsPKrK
FQ39jbg1APCtAS+WWyATbmCx+cG4u54L+XPZRZXVfoYitnlopsZV0eC+eWngdb4C
v503svP12RcXFe5Lwnof3b7tV58lISEGiJYG6maCjkXpQIyey1C+lHh7uwCufRbR
a+ho+fa5HkiCIhUtF6vqtIAEx8oiCgjWSzxrS8RaxW9ale+0GZwQcs4JYEEKTWlr
u6hn2GI0qo2mTm0/uWCdoeLwP8VFrEYD+GAW0RTfXjcoo5+c6OYbrRW7VB373Ajz
Ld49A1fVY3vh1xxCyz6j7Vhu+PjtZBh0C2KKur3XfMMQlslugQvRi3rejEs2NaZR
RqNmSp1iNiC1R0PcJMmOm2pTP7grAm2FPEJnQnkxOsceTRf+klq3R3dNx6LrxcE2
3jjnEZAYieqc3h+Qoj68tvme7Aoht7O/SlLq6eVr+qJGIiWavH6VKsrJ++aehxVF
/6LXSBqeDEx80lGWj3Xlq7dzEPa31JP4u2wpDCCOIqigW/NKLzhUnjg9A8hV3fB0
yzmDjsj3X3nNrCy6bVsfoHO9qIff73G/eZhnss3hk58cb1YFU2QjXyxu1nLbBGdu
pUwpF+5gKM59LUVfMVhtIO7//d5HGIxXutfZM58ldC3MLXOQKvTEghmZYvoxs/+l
XqI/lBtrRfFROpiqVCrv
=tqBd
-----END PGP SIGNATURE-----

--Evp0T6PXIQ26qRMT--
