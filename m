Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbaAMLVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:21:07 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53430 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaAMLVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:21:03 -0500
Date: Mon, 13 Jan 2014 11:20:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140113112058.GD29039@sirena.org.uk>
References: <1389531629-6026-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UsiV5d7KlsBC0zIw"
Content-Disposition: inline
In-Reply-To: <1389531629-6026-1-git-send-email-geert@linux-m68k.org>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: core: Improve tx/rx_nbits check comments
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UsiV5d7KlsBC0zIw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 12, 2014 at 02:00:29PM +0100, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@linux-m68k.org>
>=20
>   - Rephrase the comments about tx/rx_nbits validity checks,
>   - Remove the stale comment about SPI_3WIRE (the code it refers to was
>     removed in commit 368ca4e0c75612c0a4d6bbcef7efb944604340c2 ("spi:
>     Eliminate 3WIRE spi_transfer check")).

Applied, thanks.

--UsiV5d7KlsBC0zIw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS08wXAAoJELSic+t+oim9nfMP/jfSIfqAmwv0v6IYEMyU4MZh
Zt3i6WzSkf+VYy/Uzm5vKZRlvT6T414tL8sdWOogWqvw31o9JBbu3N4cvQgIztOo
g7korZjnbDNNiED9IfehK5N78V7RZbxlosgxsGfCKG3n1wQgAsNZj5pCSV2SyfFG
3jQ5wZxQIgQjaePtmoIuRB+fiwLaFHjheOBnwacP0+Rhg76pCGuBxWUpMFDWN3iL
lsn15w07qu8Zn5/FneVIaJ4sNS4ttfbvVTyl0BN+vAggTSSzA6LNYgjHZD0bQrfZ
lgZFXq+j9v4XnLjWfgCE5BXZpq7RcuJa/x3+QFBv4zDtO9ZROHHZ+OoTEtT1vhf4
EACLxGqcbehbDUhLQ72S7lnwWcxk4wdeYayW6ZWqCAAPZSqUDbI0nGGIMJ6HV9lq
EV1Hbm832nBJhC3bMm62cgNSSQGVBNh7fnBjMwM94BGqRE09E7evjAae/kSBXvwc
n4gH1HkMqMvWQId79phBNlcb7oerwWio5OOSaPxZvoEsarkkcnfB0BW7JbW7/+zO
HD4RpCDCV5Yl8g0MxcRbChGfps1JtTaSnsbBCPs1F7FORN7v/DwWqNuS12ErHcvh
NujUeCKOEUF4sP+HW5yYQ964GOuoXef6Tkc+pBSyhdu5NJ2/vIX0wxzTmmsgbhHM
u80AhxtuPlvpyR5LJW0U
=Ly7h
-----END PGP SIGNATURE-----

--UsiV5d7KlsBC0zIw--
