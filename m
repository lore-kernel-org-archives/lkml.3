Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbaAUSNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:13:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57664 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaAUSNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:13:35 -0500
Date: Tue, 21 Jan 2014 18:13:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140121181330.GL17314@sirena.org.uk>
References: <1390317009-8292-1-git-send-email-geert@linux-m68k.org>
 <1390317009-8292-3-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4pX28sySFCT/oEO"
Content-Disposition: inline
In-Reply-To: <1390317009-8292-3-git-send-email-geert@linux-m68k.org>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/5] spi: Correct set_cs() documentation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4pX28sySFCT/oEO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 04:10:07PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
> The documentation for spi_master.set_cs() says:
>=20
>     assert or deassert chip select, true to assert

Applied, thanks.

--T4pX28sySFCT/oEO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS3rjHAAoJELSic+t+oim9gP4QAJ0UYRehilvm3LteGuGep6kF
v4RNiYE2WguRXOc6WxtisLTOgOvtDbn4zW8MJAHZMizp22QLPQKFZSMcPktTxkhq
c+B20mN0I8zZDz3g585jPxNbcZ1zjAnGazvRc86+JPPPYdIbLoTiWGW3GDYlSeZi
9itLTUYI2mWfO/FKx6TBGW8SPksd79Ajh5ziFQyRaf3egA4znkmrAzLNmwuPCAgm
wvLFc7/AwWWxLdpwHokQFgWebdIbHcuFd1bCbh8pDIBjOH7ZnxQjZCqXMhXat8Cb
yaSaS+4V887+Sl1Uy0Euk05ugOCwLDrC+qPr3RV25ZRjZCP2Ii5m/rnNW8Cs6/PW
LiWplPDomdZwpHQ4f0DhjOC4gr+RjFu46yXzBfHLRZQwfzfmfY+KYmYXnX2Y0DOp
qGB2895NKdAWIz/eEFEOuMx+qopdMhQxj1B1nGGq72j51tATSGTl360b7Mi4CJKr
zY6MEsLiiC7amoiQbt+enS+uYuPLeF3dteLm2rS3ew7LFP8Q7Gb/vkDixyBs3rFf
yfSPIUqujMjso1XG9y+kc9N/5VJ4LHG/uxsezMol8uNRZdSre54EK1P2RC+MuAh0
IA1JP10HoLnQ8iUKh8yS8mm01zNf1BiF4w9eb9o+WskwKbovIYz0X41LKsytFr9q
D51FbS92nJ8lX/BKzQlY
=D8s5
-----END PGP SIGNATURE-----

--T4pX28sySFCT/oEO--
