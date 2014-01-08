Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164AbaAHRQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 12:16:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48785 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbaAHRQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 12:16:41 -0500
Date: Wed, 8 Jan 2014 17:16:36 +0000
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Balaji T K'" <balajitk@ti.com>, "'Nishanth Menon'" <nm@ti.com>
Message-ID: <20140108171636.GK31886@sirena.org.uk>
References: <002001cf0c0d$461abfa0$d2503ee0$%han@samsung.com>
 <002201cf0c0d$a0a7e6a0$e1f7b3e0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n92n8URPiFRfQgS7"
Content-Disposition: inline
In-Reply-To: <002201cf0c0d$a0a7e6a0$e1f7b3e0$%han@samsung.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: twl: Fix checkpatch issue
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n92n8URPiFRfQgS7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 08, 2014 at 10:04:48AM +0900, Jingoo Han wrote:
> Fix the following checkpatch warnings.
>=20
>   WARNING: please, no space before tabs
>   WARNING: space prohibited between function name and open parenthesis '('

Applied, thanks.

--n92n8URPiFRfQgS7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzYfxAAoJELSic+t+oim95HwP+gIRv9JG2Z3pExJRfComCkRg
mAGloWAskvxnK3KQbnkVklPLnOeoZUx7i76rc0bLVUbYbP0kq18dvd/mhMhMbiyI
tOSdtOTM4X/FjKncDWwScMw/dDnt0t7QW2nZAAMosCMSZyJJP3GdDPCTW9dy8zFb
PJLMU7WmGeY5qmooqmucQ2C9lopxKrLm1vuaZl38bR6hYuAmbbRLzXG+HHUjqpDF
2k+4y5iIN4LntU4CiTYSNxwTsej04U51ZiazjirNb9Kbp5/Mz5DmMM8cHTquWB3s
ShzK4FsPi4yVT7IjpzBRehH3ldAhaenV0zZfFHqgXiif84Z0+4JEsjzFNIgbIHEf
qx0IoRvH57NJ+I4sGhBLtxiT6twu3Hi1C0HpiowmkOZMeHFcTB7IT7sxWkUa8UN5
ceB/D46QsbukSRMntRnFQ86o+M8HIRKVrDPcqOzPSxB8HH/BV7r+3KP3gq9iCZqN
sbPROkq4ivOoVjzH1lpD36IfY5bQkEReTnDgBFPht1Bg6lbig2n9SghhFlQpPsES
5x0pj11vA5oBvtTWvPUL5Lx+mDtp/bnKxVFAv1NWWisBBqKiZoXAEQcSHS3wofw3
DZEnAuWe1IrTfjApav7BMb5JYTcFoiqEpoSrZrFk6D4vrSCcytTOWsad+pMoxpTI
293NXFvhtT/aXiRdbQE2
=mv8H
-----END PGP SIGNATURE-----

--n92n8URPiFRfQgS7--
