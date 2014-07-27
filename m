Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaG0SuM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 14:50:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58177 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbaG0SuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 14:50:10 -0400
Date: Sun, 27 Jul 2014 19:49:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "andriy.shevchenko@intel.com" <andriy.shevchenko@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhuzhenhua@allwinnertech.com" <zhuzhenhua@allwinnertech.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140727184942.GL17528@sirena.org.uk>
References: <1404134454-25513-1-git-send-email-maxime.ripard@free-electrons.com>
 <1404134454-25513-3-git-send-email-maxime.ripard@free-electrons.com>
 <20140630142054.GA8756@leverpostej>
 <20140630151906.GG28647@lukather>
 <20140630153305.GA28740@leverpostej>
 <20140701072119.GH28647@lukather>
 <20140701124852.GB6064@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AXeJgIDWTp8Ir+uz"
Content-Disposition: inline
In-Reply-To: <20140701124852.GB6064@leverpostej>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v10 2/2] dmaengine: sun6i: Add driver for the Allwinner
 A31 DMA controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AXeJgIDWTp8Ir+uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 01, 2014 at 01:48:52PM +0100, Mark Rutland wrote:
> On Tue, Jul 01, 2014 at 08:21:19AM +0100, Maxime Ripard wrote:

> > > It feels a little fragile to rely on the organisation of the clock tr=
ee
> > > and the naming thereof. If the IP block is ever reused on an SoC with=
 a
> > > different clock tree layout then we have to handle things differently.
> >=20
> > What do you suggest then?
>=20
> I will admit that I don't have a better suggestion.
>=20
> Without knowing which particular constraint on the mux parent clock we
> care about it's difficult to suggest anything useful.

There's supposed to be facilities appearing in the generic clock code
for specifying default clock tree configurations via the DT - it's quite
a common requirement after all.  It sounds like that should be able to
do the job here.  Not sure if these have gone in yet or not but there's
quite a bit of demand.

--AXeJgIDWTp8Ir+uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1UnCAAoJELSic+t+oim9N3oP/i6beBMt/NCUX4ZaoKBF9t4a
pS3jGYuKQ/bDJjImbO6+ZaYY/icCyxlo04YeVNDzR34lyvIEPO1jhLJb7PHDqZ24
NgkD8qhdBtySYzpryFisNSYEMOJfE/MJpd9sxGwfFzxB2OroeG58cL9bc57NqeJM
k5iKlScm5EIVQIKO5Oj6uWmzoSFX8UP3oH59eSWuvjHUipAYGUQmXIfsFfjUJUW0
R6NdQrdlt1XSXiiaXTwvL0KgG6XT3R6jrH939fOGr9Dapry0ltG4KHmwzEip5baU
ShA98jnbCbdfswLAAeRBCLDcz6vsTNw39VKDUVAKqPOgMM7jwzTXLWIyYbtDd95X
9357PgdvYojkhlUkHcWVl7BLLUFeADodUsnZXVuIMGMl8F3xvt+waFFAtmiO5Pf6
kIxhIj/onZHqSFLQz5Wuz4Qnvf0pjpYiRxatMx5k2sREB1Qn62dBitmamhy/mVwM
+7l+vZ94y7u38/u71c2FC4kUgTofCXcLC3a8M19ZFiCT5yZq723ze0tuDxVeaMZU
xa99mb/xY5mQ7F9spmAVmWH98BYmQ3CT6lX9GPm4D2UBdHYAIsoAbHtc4kSdhhfj
yMJEDkHhAKFR3dOCY6mpS4a0cnA9Kl5RGwXx3JjZGKwDmyikaNe9HYfeJa9cHFQj
oxd68yVvMKHxkCf7cWfb
=S2ML
-----END PGP SIGNATURE-----

--AXeJgIDWTp8Ir+uz--
