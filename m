Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaEZPz1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:55:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43395 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaEZPz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:55:26 -0400
Date: Mon, 26 May 2014 16:54:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Alban Bedel <alban.bedel@avionic-design.de>, linux-kernel@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Message-ID: <20140526155444.GC22111@sirena.org.uk>
References: <1400580843-29484-1-git-send-email-alban.bedel@avionic-design.de>
 <1400580843-29484-2-git-send-email-alban.bedel@avionic-design.de>
 <20140520121439.GK24991@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EJL1rln6Q1OoiO/y"
Content-Disposition: inline
In-Reply-To: <20140520121439.GK24991@lee--X1>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.185
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] regulator: tps6586x: Add support for the TPS658640
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EJL1rln6Q1OoiO/y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 20, 2014 at 01:14:39PM +0100, Lee Jones wrote:

> MFD parts look okay to me.

> Mark can you tag the branch and ping it over to me please?

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git regulator-tps658640

for you to fetch changes up to 6c46ccc8bb0660c1805f6662d4646eb5405dcb2d:

  regulator: tps6586x: Add support for the TPS658640 (2014-05-26 16:48:02 +0100)

----------------------------------------------------------------
regulator: Support newer revisions of tps658640

There are two different variants of the tps658640 with slightly
different feature sets.

----------------------------------------------------------------
Alban Bedel (2):
      regulator: tps6586x: Prepare supporting fixed regulators
      regulator: tps6586x: Add support for the TPS658640

 drivers/mfd/tps6586x.c                 |  4 +++
 drivers/regulator/tps6586x-regulator.c | 63 +++++++++++++++++++++++++++++++---
 include/linux/mfd/tps6586x.h           |  2 ++
 3 files changed, 64 insertions(+), 5 deletions(-)

--EJL1rln6Q1OoiO/y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTg2PBAAoJELSic+t+oim9+IcP/2syPls0g1sKhhfCzNagPqxC
98zaZDsakRtM5ppZ/W8wdDcRlACBshNDfitxC38Tgbt1uL2ojXhCfoRqfKkLeCqx
/xByK6rD1h7HJ2dGSE2zfehUGUiOGjuGzMgxEluzUwKMK6zkj3jTINWzMQ1yjTvJ
qwEBq3EpKO6Xh6AfgJYb6mWOqlgP0hy74upShfbHqYWGEersbJbTsTDn3LdZd3D0
lNgJOciJo4UVCF7jltBMifbc8A1SX/TUKURXPD+kTz+AFWukKCbpXwEcoipfaYpy
alj+Iw4kuEwyN+ykDkWPZzp5cNsJ6rybHyAtsAeNdFEZy2WuznhapAHgPtuewcFH
65pFXXsrcXIaEd7bWPkYRs+dJ1/KEXaPi5CENWAoZYClCPa8f53JwRDOPgQSIf+C
3ZR14f32sEdofvfnCglOJQZy4frAntAbIH+/qzAHkKILstJoD5ZU8nltFCfcTquN
rm3r0s6oWI5cxMvf7wru7tSlnabdtVHj0BGdCItUbBwTGJKYC+1EIeA6xXj1jlc+
ZNg4LUuw/fMXT86unWteVVVCemtSrsA+Cfa5+xH3D6szjj4+/E6F12MsbYZcL4ZT
cz031ZWThj9UwvCqZxoXs8VDRaDh2tay/ZIUQbshJeMTJ9j4zlgNRpJ0tEw+9yWv
B6ZtDpd/mg/nz2W0+H5x
=MNus
-----END PGP SIGNATURE-----

--EJL1rln6Q1OoiO/y--
