Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaBVXhD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:37:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49505 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaBVXga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:36:30 -0500
Date: Sat, 22 Feb 2014 12:01:11 +0900
From: Mark Brown <broonie@kernel.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Gerhard Sittig <gsi@denx.de>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140222030111.GO25940@sirena.org.uk>
References: <1392890528-7417-1-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gh4H09KImyIEQ1se"
Content-Disposition: inline
In-Reply-To: <1392890528-7417-1-git-send-email-iivanov@mm-sol.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.4.12
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] spi: core: Validate length of the transfers in message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gh4H09KImyIEQ1se
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 12:02:08PM +0200, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>=20
> SPI transfer length should be multiple of SPI word size,
> where SPI word size should be power-of-two multiple

OK, I checked all the existing users and everything using unusual bits
per word settings seems to be doing the right thing here so I've applied
this - thanks!

--gh4H09KImyIEQ1se
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCBL0AAoJELSic+t+oim9dtsP/jA/0IQ+cH2AuFafiWvA2b3c
oUZjXF86o/1nZ3a3Y7QeV+/0UMB0IVteMq+EJ3nIG8kT6x8s1quo8ZjNc32PbOJr
fPGlXfVC4K6QntN0W1we5H8LiJ/bD7JWbGidKirMqp/nrGLu2y0dcN/Z/k/9FlzE
tyFo/xrVLlHzWdMygnEJ0I3jCADEtoYLHUyVCaggaMzXtDT5dK+Iy7KN3ILcJPhd
P8fDZXSrsuqCjFf9mCloLKYJxDypWFyHcLN88rM9CmAV6AsTij35nRtbHdELgZxy
cVfdwF/qSN1WR75gGLgx1aQJHq6Z0SUx7y8b/uqtXebt4XP9IyKja8Da3BhSMLcs
Y0DiBeFCQFhMaTtLqtEnjcUy3oLi0353l+Ji8FuRz3s86BEBtzPwL6SXjgeblxoo
NVv84qrBa7nA8/W9S2GrzbduPilpkIE80JgLpbdqGq7Y2eL3Xi/E3kIfhgqeWSxs
nTgSUr+726cksDqq83Il/MTomeAhZjQbb3K6TEbJmNDLmIh0KAwnlYPBIT3NIhKV
uuPI1Xi+4q1cQDXXDSG5mlq+6BxZhss8h/vhayeCp3DjjYLtBg143wOvh60x+meF
Ksd9xwpw9t9EGualRniGL7OAyHUj55KZk+nDv11FdZx8jH59iWK5vsLYeUUjEQEJ
o6VAW2IpQiGcWh316mjS
=5JMa
-----END PGP SIGNATURE-----

--gh4H09KImyIEQ1se--
