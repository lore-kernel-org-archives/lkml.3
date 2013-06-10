Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab3FJSCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:02:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48313 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3FJSCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:02:20 -0400
Date: Mon, 10 Jun 2013 19:01:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, devicetree-discuss@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <20130610180150.GQ1403@sirena.org.uk>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
 <1369246717-4167-2-git-send-email-nm@ti.com>
 <20130610103131.GR31367@sirena.org.uk>
 <CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
 <20130610164905.GJ1403@sirena.org.uk>
 <CAGo_u6ov=yaCwt8apbvW57ErAvhgUBHHw9gwADBC1fJUrfucUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vsi50HYs5tPfr+1I"
Content-Disposition: inline
In-Reply-To: <CAGo_u6ov=yaCwt8apbvW57ErAvhgUBHHw9gwADBC1fJUrfucUQ@mail.gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vsi50HYs5tPfr+1I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 12:51:42PM -0500, Nishanth Menon wrote:

> a) Tegra seems to use Lookup Table for sending predefinied voltage
> values to PMIC. OMAP has no concept of lookup table.

They seem to be doing basically the same thing here, you've got a linear
map of selector to voltage too AFAICT.

> b) Tegra and OMAP h/w blocks seem to use I2C - that is good.
> c) How about the i2c slave and register addresses, slew rates, start,
> end voltages, max voltages that SoC can support etc, I am yet to
> understand those.
> d) OMAP has 3 modules - AVS (SmartReflex), Voltage Processor(VP),
> Voltage Controller(VC) - I am not yet sure about the Tegra hardware
> blocks involved.

This all seems like it's at the implementation detail level - the bit
that seems like we should be able to share it is the big picture bit for
how we describe how the AP side stuff and PMIC are hooked up without
having to have a bunch of completely non-framework stuff for things
like describing the PMIC.

--Vsi50HYs5tPfr+1I
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRthSLAAoJELSic+t+oim9GT0P+wUSGDd0n0pZGxF3nrCfxkh0
2K1JFJmA/qqah6iv/pT/HNSUjxlKUCWDgQMEwEEYCcbUtDEGYXhFGMNCMl2nDBD6
Oa05MIUSyJYTQW5KiFXc0vzGg8rHYwSG6ScLst59bhsJTXnif8Oa2JAhARFZyjVD
Y18F0sn9RGmI3jnAssuqDdMhH+s3+sFdnJ6y/7h/r5rQs/+zQ+R64Bdfwb6ER2VI
Zlp9ogu06xE1K4+xFeFiv3HudJQhLlB9IpW8uoe3hHRXuczUgeFSh/4un5jaG9J9
/UR0DiJTio1AlH0KUAnl5yV9NI2rDgk/2GbtswXsp1U/P3z5Rjqeu33dTHR4JnYm
ehhm8G+PBRwFtoIE41Ell/jqb0FBBI22jcVjm7SBeCvhhmnS6cTxTI3kopVUbme7
TVsqeZbIXh4V9sMkPGOGi1OeD8Dd6U7CIUmLQuRDUd/O1tK7K+ZBfMeOw1TLzDAV
bPS6JrfpOUpY7cygDD+2CIyc9vToCMAOlwWZLS2Bfx2nZc0a4MmEQRi5DfebiFOJ
JtH8VnXzl6wRoq+zPk6ZxjQRSfrwwUNsUi4mHxJDuQhw2XvaJLQblZiHMfzK8jVr
fkj8xqRnnJ7tf60aQhsfvHqscuwcS7xwWGKuxICo8sfSvYnxhV0J0YxS4Hvx/Lbi
VWV7oBdkm6gTba2xrmT4
=iQkI
-----END PGP SIGNATURE-----

--Vsi50HYs5tPfr+1I--
