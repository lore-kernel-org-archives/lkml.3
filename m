Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161699Ab3DEJzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 05:55:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34405 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161625Ab3DEJzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 05:55:00 -0400
Date: Fri, 5 Apr 2013 10:54:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>
Subject: Re: [PATCH] regulator: core: don't require a supply when supply_name
 is specified
Message-ID: <20130405095457.GB6597@opensource.wolfsonmicro.com>
References: <1365114467-16357-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dc+cDN39EJAMEtIO"
Content-Disposition: inline
In-Reply-To: <1365114467-16357-1-git-send-email-abrestic@chromium.org>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dc+cDN39EJAMEtIO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 04, 2013 at 03:27:47PM -0700, Andrew Bresticker wrote:

> Regulator drivers may specify regulator_desc->supply_name which
> regulator_register() will use to find the supply node for a regulator.
> If no supply was specified in the device tree or the supply has yet
> to be registered regulator_register() will fail, deferring the probe
> of the regulator.  In the case where no supply node was specified in the
> device tree, there is no supply and it is pointless to try and find one
> later, so go ahead and add the regulator without the supply.

I'd call this a broken device tree to be honest, the regulators ought to
have a supply specified.  We should complain about it.  We probably
ought to be doing this though so I'll apply.

--dc+cDN39EJAMEtIO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRXp9eAAoJELSic+t+oim9FE4P/jj3TgvovG6Y7oofvoyCYtP3
Z00p51Er6qXcXLwQqaDM3GEMj32EM42aFF2164KZ18ufoGbRmQfGLOSzJ4XjvIrK
Q2lfuAQNmd6dhE9VhQAlLew6L+MuRKtWqaORwEGhTSpfbuI2tmrl9WqR5/FqFJnz
R7JNR3a1GYg9qETEIEGtWAP1OH/FAyqhsGmOjhdYm1os2i/COspPpuxPFzuLmm9x
XWtTIGtzzomM6z7I0FuiO2O/JQa2pKturJFJqhaNSABnZ5PR6KL3cZqLRtJUQNxO
LX/ZGv3HJb0Ud8BMMXtaPzsLPqyyFYJ2TaAMDah+Pq3cgcsqAA6LKla9l4TTKF5x
/TdTRA5NCH30NDGWxOf960/L43xBEQNQp8kGMLHW5FrgP+Dijvu00WUrsbqXONDk
3E3zm0XAqA8/p0Zg75gaRIRoP+A4DG1XQSvmQrwKkSwCWt6g1prGoUP4h4Q8TeOp
RuiB70T3eqGuIL3emEhSCIXVWCWabEXC3NxODfrku+mjj6tYDmF34avPiDb6kqS/
WiNQqYUbfTFuHGgPofaNm0lEwh/rnvu4Uy3p2gAhyi4ULE8xjkFMxYM/CjTRvAKT
j/uhl7Fgqjqwj32JXZgHGDFp9htJuKiRMONJzhqyZ7ve01Bi6YOwHLTLaLmBJcOC
4uRiYgcUrpaTtfoAxhFG
=nTPK
-----END PGP SIGNATURE-----

--dc+cDN39EJAMEtIO--
