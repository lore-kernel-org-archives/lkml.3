Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3GIKGO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:06:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34016 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3GIKGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:06:11 -0400
Date: Tue, 9 Jul 2013 11:05:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Sourav Poddar <sourav.poddar@ti.com>,
        spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130709100525.GR27646@sirena.org.uk>
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
 <1373290980-17883-3-git-send-email-sourav.poddar@ti.com>
 <20130708203330.GA28322@kahuna>
 <20130709065143.GC5552@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xuphU+ty49MprRdU"
Content-Disposition: inline
In-Reply-To: <20130709065143.GC5552@arwen.pp.htv.fi>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 2/3] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xuphU+ty49MprRdU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 09:51:43AM +0300, Felipe Balbi wrote:

> > Looks like a case to use regmap?
> > Dumb q: why cant we use regmap_spi? worst case, you should be able to

> read regmap-spi and you'll see why it can't be used in this case.

> regmap-spi is for SPI clients who want to read their register map
> through SPI commands. This is a driver for the SPI master which has its
> registers memory mapped.

Indeed, regmap-spi would be a client of this driver.  Though there is
regmap-mmio which may be helpful, on the other hand it's relatively
heavyweight and SPI can be a bit performance sensitive so perhaps it's
not awesome here.  Russell did mention the idea of some helpers along a
similar style though, they may be a good idea but nobody wrote them yet.

--xuphU+ty49MprRdU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2+BdAAoJELSic+t+oim9hAUP/jMKcQ5yJDkGq08a+NUKybbA
/1vzSBvFMwyZVeuludCMfL4JSlFNvuaW3+VJIowNwOdysIBAgT3NA23KrTE6iCap
OymJIwrldbiqnb0705DNw3OzJ/0jJyXgiRruhogwcH7e1TCV9zQcW5/inAKkkOL5
OKr42c1fs7bR/aKUee7OJXYwOgyAeHt4M0RAN3HLLoK6PX4c5nFd1/Pv2y1ortfZ
o3uO2GXQgbNbo0T2LBJN76XXqqlogBFbuxrQOx90yCRDGFmYswmwd6xQfR/UxE3c
+7jE+GpyWeZctMBrS23wqGQ1aFE7a03sv5tr3pUNNwQ/t2f1AmZ2HCjy0JFkOMNg
/Brn1Upr+FpgY7ZfGLr90ZuHpB4EyYOfy6gxn1ruTDUd7PVYV2Mt7pPtDiI/Z/d0
FyV/Dt9PRwdSJiY7DpCqD3WScTbdth2a+tgRVrJ/sQc8nGB6aaDz4PsSJhqJ6Lfo
L5p6lkj1ajHWNXQ8RCPkcClw3aQV+Oj2Gf0fXwlFuzernuUX24U928nxVABLG4FY
riiqAqpJtB3cF53w/g1IfHMrUO0azvZz9hr0GT73VUr7wFkva8C2MKXI9HK1aRuM
WVIaPaYt/hg5b7bIS8LWNIoOrKE6oW8ZxncacydT6h6Ql6NuEbbceqq6wXgSzJSZ
SxglcxwzGphJwUO5vHCI
=LHL1
-----END PGP SIGNATURE-----

--xuphU+ty49MprRdU--
