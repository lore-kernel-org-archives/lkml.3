Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbaHVVp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:45:57 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55886 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaHVVp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:45:56 -0400
Date: Fri, 22 Aug 2014 16:45:46 -0500
From: Mark Brown <broonie@kernel.org>
To: atull@opensource.altera.com
Cc: linux@roeck-us.net, jdelvare@suse.de, lm-sensors@lm-sensors.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Message-ID: <20140822214546.GD24407@sirena.org.uk>
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com>
 <1408741894-24879-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rgqXlh/A5ZVYK4yt"
Content-Disposition: inline
In-Reply-To: <1408741894-24879-3-git-send-email-atull@opensource.altera.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/2] pmbus: ltc2978: add regulator gating
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rgqXlh/A5ZVYK4yt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 04:11:34PM -0500, atull@opensource.altera.com wrote:
> From: Alan Tull <atull@opensource.altera.com>
>=20
> Add regulator with support for enabling or disabling all
> supplies.

Reviwed-by: Mark Brown <broonie@linaro.org>

though it still looks like you should be able to create generic
functions for the operations.

--rgqXlh/A5ZVYK4yt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT97oHAAoJELSic+t+oim9Jc4QAJkRwMPl4yQQvPD+5fBmfQPf
UVDLPZdBSIkpa1E4mXCh8J7POVGUP+L9s1nemF79e/1lIj2HNSI4gK6Hn2vJGJ4I
D1zTU4/IdYadHpfYmk083vHYWnkZDEQbjcHRl+lSSGhpVPRgjGx+3BuG5xERTxJF
17dZ5z64edOk+1BMue2a3GQvGdKLse6e4QxmFmu1K2nBP1jG9c2v2lwlmiLwPPkj
XzMwt5G0lpvJ7Xe2aH8bdP2tiPvF4CyfKAV+tNIrtt+w04ygZO6P8QMUctHHLEH2
jFosBxdFpZSxRM2eDh+a8P/PqhYHnfsJc/p3zAyruCNdExU+IyaW8KnL/7pGMvkH
VndaPywP5KpmmGxVHbGD15XfcjFVAduKS+ojfsAq8QhOnFYPkQvs4wvDmd/jbi3o
uHPyp58jZJ7h+whlfIEBNPKWkblL5HvLVIuLf0IJyBxhibkYJwrpV94qXLc9I2rW
kBHp9/bgZLO/9earmwKZ0fMOp2RDCNvMZ8feY9hVMGjYcfBgpyGCaK8/tz4U177g
/4VkGXf4haqoLAvAV8dwpFM5AIROBdgsUiENwlhS0yhNqnxnt4i1MKMY+5gGuzuR
0AaKSSEhplQygfbAO/QvVqE2he2+o2j80kTcqcR7g76X2PLnTAtwmsxMNeKzyRSU
tOo8oGWgM8JL/IfjuSm3
=xVAF
-----END PGP SIGNATURE-----

--rgqXlh/A5ZVYK4yt--
