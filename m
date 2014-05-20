Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751092AbaETVpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 17:45:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34686 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbaETVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 17:44:58 -0400
Date: Tue, 20 May 2014 22:44:39 +0100
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Tim Kryger <tim.kryger@linaro.org>,
        Markus Mayer <markus.mayer@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Message-ID: <20140520214439.GS12304@sirena.org.uk>
References: <1398295293-11033-1-git-send-email-mporter@linaro.org>
 <1398295293-11033-3-git-send-email-mporter@linaro.org>
 <20140428115627.GY21279@lee--X1>
 <20140428140910.GB7719@beef>
 <20140520161131.GB32025@lee--X1>
 <20140520190055.GQ12304@sirena.org.uk>
 <20140520202923.GT32082@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gb/phn1tfmfgR5gt"
Content-Disposition: inline
In-Reply-To: <20140520202923.GT32082@beef>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/4] mfd: bcm590xx: add support for secondary I2C
 slave address
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gb/phn1tfmfgR5gt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 04:29:23PM -0400, Matt Porter wrote:

> Just resent the v2 series.

I looked at that but it seems I already acked the regulator part of the
series and nothing else looked immediately relevant?

--gb/phn1tfmfgR5gt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTe8zEAAoJELSic+t+oim9wbUP/jWNnjXLDEiMzAoP/g8RnVw2
zK5Ikuq9JDVHzy+IGhXqS5l2v1Juc2qnxthcJeQRF9ycu7nzTNLgio0uf81uDJNK
JHsZBrU6CmcF+VqpQ3wAUdr0OrcUDKKzXczVQaJgv7F52urQ20KdFJcF2yQQIa1Y
AQ0r7TzU6Nb5pkpvXo283U7vNYoGLFrCdeBDawsHNzLWfQMmD+PGuuwjISlO3+z0
r+YA2UA3l3qk/gEfMleb0y0R9XiI3qbwgIW6/jGqt1uEHNL2OdMGpgv4pDnz84Vc
TaC7aaOO/L9rdrPUtsSl4wHULY9X3BVKXgw3wEgtJdmJKf5OKHC3OoHJw4qe9nKm
u0Iy/SjyxoEoXvyQfb4wjRiQlWr5TYMk0QRykzFvRRJyncpFZmn/TpajP7PiC3ag
hhdPYM73pPnnNDKXIhVnvFxvUw0TilENcouGQ5lOFgiUX9DiTM+6tN76QspnqC9d
hYGFHBk5+nD+K9voZ/7E7UUDCRh/uDJMhg4FMgYSnj2FNPoVS2BQEgE7ATKJdLxU
Rv304g+Dva0x9wQB/00+b+BlYAWp93a+2F9Pa0/Jk+jbNCo600XLsyeF7wpj0tT9
AW4zyucAWXQDNEykkFHRmtpZNYXcdIAcKdSzcYN9d3pxl5oB/J/LYt9uu2kO6PZG
TRw8EbBqBFYwbzM5jkHa
=js8z
-----END PGP SIGNATURE-----

--gb/phn1tfmfgR5gt--
