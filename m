Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaFRVCL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:02:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38796 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaFRVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:02:09 -0400
Date: Wed, 18 Jun 2014 23:01:59 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@pengutronix.de,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] regmap: Add Kconfig option for debugfs register writes
Message-ID: <20140618210159.GC32450@pengutronix.de>
References: <1403033795-9122-1-git-send-email-mpa@pengutronix.de>
 <20140618001127.GC5099@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <20140618001127.GC5099@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:13:17 up 56 days,  2:44, 62 users,  load average: 0.04, 0.05,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 18, 2014 at 01:11:27AM +0100, Mark Brown wrote:
> On Tue, Jun 17, 2014 at 09:36:35PM +0200, Markus Pargmann wrote:
>=20
> > To enable writing of registers through the regmap debugfs interface, it
> > was necessary to alter the regmap-debugfs.c source code. This is not
> > really practical.
>=20
> > As this is a powerful tool for debugging, this patch creates an expert
> > kconfig option for this function. This makes it easier to enable
> > register writing in the kernel.
>=20
> This is deliberately hard to enable in order to make it clear that it
> should never, ever be used in production as a bodge around writing
> drivers and generally in order to reduce the risk to the rest of the
> system.  Enabling this will typically give userspace full access to
> components like PMICs which have the potential to cause physical damage
> to the system if misused.

The userspace already has full access to all those registers if you
want. For example memory mapped registeres can be written through
/dev/mem. I2C registers can easily be changed using i2c-tools or the
/dev/i2c-* devices. So you are already able to write a userspace driver
if you really want to.

I think this kconfig option would make it easier to debug hardware or
driver issues, as it is much more comfortable to have a clean kconfig
option.

>=20
> Anyone with a use for this is most likely building their own kernels
> anyway and if a user modifies the code to enable it is clear that it is
> their responsibility to deal with the fallout.
>=20
> > This patch also fixes the file mode when the regmap debugfs write code =
is
> > compiled.
>=20
> Seperate changes in separate patches, especially don't put bugfixes in
> the same patch as features.

Ok, I will split this to a seperate patch

Thanks,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTof5GAAoJEEpcgKtcEGQQtlUP/0jsvlTPnCNVGYX5tCsUpNjW
0HczaYprZWZq2h9HC65p3SD/EMF/oL6RIbNwa5lMnK9pJfY1EfEvj0m0h/y7C9D3
p+s89Y63e/1LXBVASBhd2JzliS7AuDIE5KvtdWiWGx4TQ55F2goIgMtiVbEHCB2c
ttRVLAJ10hzgrgGXC+I9YVXEZC4zMikjiCR09s/PoZYfUVubkdwEmBF5vhgEaXuW
pGiWXUloxGAfP0grv6Whuj9zfhYs/26h+eHqni1tAbQlQ6fatca6sfJk9EyGwsMg
Qn63uwoF1P6pBl4sPt55I5qqskfqlZ1AbbOMq+xI3VccTFYsCpa8cFWCKBfbw23b
3d8puUCrnI4sSbiUbym9D8q9+Q4dbIVvTdfsLe4dbX5s4MKk0Qc1XuxEIH5CiLxS
BjuqwkgOOafEWLYtQ7FKvbU3go4MUg+7eX9H8hTRZOmOKzbijDTsRmX7uKEiZ4TJ
hu1H3CJZ4NBVTmMCj7ujAlkhZJ3MUqP5ayNFjtosNiuYW/p9IbJx/qyi6qAGLkzs
tmKLEw2yBNAq18IHtVftwhVCPEwPmWjPjONdXRq8jOSxag/vEURbspUjYbTOWJHZ
77PD8y+j4nf1R1ONEAbiY1nFkW7I/nxL43ecpstb6S8xXH7IMtR1qxpghH/yHwXx
2Y2cAbBWyQgNri2izGnZ
=EMtH
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
