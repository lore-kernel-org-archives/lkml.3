Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbbAFRDM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:03:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38796 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbbAFRDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:03:11 -0500
Date: Tue, 6 Jan 2015 17:02:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150106170259.GC2634@sirena.org.uk>
References: <1420550620-12693-1-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2zue9K3IhLF/3KAd"
Content-Disposition: inline
In-Reply-To: <1420550620-12693-1-git-send-email-laurentiu.palcu@intel.com>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/dln2: simplify return flow for
 dln2_spi_transfer_setup and dln2_spi_enable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2zue9K3IhLF/3KAd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 03:23:40PM +0200, Laurentiu Palcu wrote:
> This fixes the following kbuild test robot warnings:
>=20
> >> drivers/spi/spi-dln2.c:124:1-4: WARNING: end returns can be simplified=
 if negative or 0 value
> >> drivers/spi/spi-dln2.c:656:1-4: WARNING: end returns can be simplified=
 if negative or 0 value
>=20
> Additionally, fix a comment after switching from CONFIG_PM_RUNTIME to
> CONFIG_PM.

Applied, thanks.

--2zue9K3IhLF/3KAd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrBVCAAoJECTWi3JdVIfQnBwH/3eAcp76uYc8icPPYu/BH755
QFt4enUbugacPdcvpie6grlPp+w8UbEurmQPkvLiGLXIGVHeKgLfA8yKEDU6V06O
/w3WW/VrGXoP5zMhCO8hc4ByomrvfLFyDCej/ETl4hhKELhAzpYj0BBwSNkgnvJ5
zBfBv8rfcK5Mzdjq+uOMyUzX5bSfjQJitumQHQYdL/n+NnE7Ep7op2IEW0xbjWe9
8b/23MfKNx96UcCfziUVS1SV+ozjzNlAHQwdKHcNCmPEyGi25DvSekdFK1wA0Upy
JSsTzGlpeCKEluIB6eSOP1agGvQpAuNpzFk24ogqWysvxZ2a3llEvPvJGZv7b7w=
=GB+E
-----END PGP SIGNATURE-----

--2zue9K3IhLF/3KAd--
