Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab3EMN7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 09:59:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40249 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3EMN7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 09:59:20 -0400
Date: Mon, 13 May 2013 17:59:15 +0400
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>
Message-ID: <20130513135915.GI6836@sirena.org.uk>
References: <1368441911-6562-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y96v7rNg6HAoELs5"
Content-Disposition: inline
In-Reply-To: <1368441911-6562-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] spi/pxa2xx: fix compile warning in
 pxa2xx_spi_acpi_get_pdata()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y96v7rNg6HAoELs5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 13, 2013 at 01:45:09PM +0300, Mika Westerberg wrote:
> Commit cbfd6a21b6f (spi/pxa2xx: Convert to devm_ioremap_resource())
> converted the driver to use devm_ioremap_resource(). However it causes
> following warning to be emitted:

Applied all, thanks.

--y96v7rNg6HAoELs5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkPGwAAoJELSic+t+oim9KSgP/2kzNE64g4SyIx/h7RH+U2YH
asKoYvvi0IzcNWDylXeY6QWd4seWqBbD8h/GzkNnegSG4KS+njn2q85QW4c59icT
IyEFvGcPVLmq4l42jj6CofK6ZUpQ7ELDcS0bC7SnVdmhQkfsrZthDUFjqsYqniFi
xd2/m8pZrKXbJSI8msIHpn7BDwIZZQzfZeegokEGvoxebxHZnbUGcLGy9yIazE4W
UFvIJ1cJhiY+R7R5pbxKYCxBFmU36H27Tx5iYe72HLnzYvpA1BJTuRIPJqVoCH6h
VTVAvH9u+1rCa8dUuPg4fF8DU9FElOC4B+twktP+u3nzGEE05nqFsGfib7ioJGXZ
JcjGMpvs+7imc2IFAtHUeIkuXu8MJIt9TNHJym15tEzK1JugVY+OJBozJvbINRyy
t85beEwGnuG5grCq5TUu/fQ+fXrTSDPEHJ9iEdwv9DSqKnhlNI4qhjyGr1SKNAzI
EucWMIMMqDF8Vi1ngV3KyQBbk3E9/vY3oiLOnBdT/l+MMO7rFKhLAdLVHChDvl34
tGCK62yfMRNrMzaROgM3wcZZTpi6pBpjPEnYTG11EO+ZNAp5NzkH/pix7Ec4vjn7
0AtsQ35U6u397M95ifP61Chw6Imc4FwQf4li20/LGrO86pxoV7jk4zRUxAkmv0GQ
GI5vi/PYH1M+0oGiitNN
=kim0
-----END PGP SIGNATURE-----

--y96v7rNg6HAoELs5--
