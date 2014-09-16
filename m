Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbaIPSey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:34:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45588 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbaIPSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:34:52 -0400
Date: Tue, 16 Sep 2014 11:34:31 -0700
From: Mark Brown <broonie@kernel.org>
To: Anders Berg <anders.berg@avagotech.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140916183431.GX7960@sirena.org.uk>
References: <1410781132-16223-1-git-send-email-anders.berg@avagotech.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J0QI3A+imHzF1NdR"
Content-Disposition: inline
In-Reply-To: <1410781132-16223-1-git-send-email-anders.berg@avagotech.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi: pl022: Add support for chip select extension
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J0QI3A+imHzF1NdR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 15, 2014 at 01:38:52PM +0200, Anders Berg wrote:

> v2:
>     - added constant to <linux/amba/bus.h>

Since you're editing the AMBA code you should also CC Russell so he can
review the AMBA part of the change.

--J0QI3A+imHzF1NdR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGIK2AAoJECTWi3JdVIfQPqkH/3q6cXYjOeFlqwJk1vqkIt34
O6mh8Lv0eVcdn32ZvzJvX0vnFARbkXhXxuX5viTrbAZ3DnY6J+OJtLqcP9qIv47x
eCSJikvZkSS8PEJKNRRw5ejxBwkjjDHC7BuCGT+jkCogR726e7uJPc1Ss2IsgaTH
uHHQ5xw3Y1qpQThrnAftY/07HCj9+0SGgQBf5Q2GE8nKRaURp58hSYeanOsNOBif
ch820E0ZVG7BMoXsN2q5Y7FP31CtB2fEzEzESaT+2Qg62u1E3ljANlccFh5CAbEB
iDOmDT96XS/syxcr2fl7U1TYvSxUOPZLoFAJ1lrXY89oJ3w4g8sTaaeg8U3f5/0=
=i9bF
-----END PGP SIGNATURE-----

--J0QI3A+imHzF1NdR--
