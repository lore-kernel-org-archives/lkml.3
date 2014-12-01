Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224AbaLATmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:42:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45385 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbaLATmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:42:20 -0500
Date: Mon, 1 Dec 2014 19:41:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Timur Tabi <timur@tabi.org>, Markus Pargmann <mpa@pengutronix.de>,
        Jiada Wang <jiada_wang@mentor.com>, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com, tiwai@suse.de, Li.Xiubo@freescale.com,
        nicoleotsuka@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141201194147.GP7712@sirena.org.uk>
References: <1417402251-6596-1-git-send-email-jiada_wang@mentor.com>
 <20141201065046.GB27289@pengutronix.de>
 <547C9C34.9080602@metafoo.de>
 <547CB817.10806@tabi.org>
 <547CC407.30308@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A4pi7p1avD4z6Uqy"
Content-Disposition: inline
In-Reply-To: <547CC407.30308@metafoo.de>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl_ssi: free irq before
 irq_dispose_mapping()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A4pi7p1avD4z6Uqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 01, 2014 at 08:39:51PM +0100, Lars-Peter Clausen wrote:
> On 12/01/2014 07:48 PM, Timur Tabi wrote:

> >A quick grep shows the following drivers that call both functions:

> Most of these drivers will probably work fine without irq_of_parse_and_map().

I'd also note that quite a few of these drivers look pretty legacy - a
very large proportion are for old PowerPC hardware, though by no means
all.

--A4pi7p1avD4z6Uqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfMR7AAoJECTWi3JdVIfQxC4H/Rw91cGM/GoVnm+lMlkCjMT8
b0OZH4hfeGQfs5roSNkjab0foHUwXfKEmOcUnh4eHUiO3OJdAuLA2s4LWWKwf7Tp
I8+oYR268oi/uf4bhiREBOzrbj3+I8gqZmE7C9lXi3VVqjJm+/CgsoK+C+ntcf0N
LSJMaOMPQtu5CAAQNlSJCsaGbCdAdhEKOBTRyxaPHrR9HVnBI3nwXqthtqhntZDw
JMIlHh/v5rJsFW4oWuX6ym/g0VHQ2jvdmJJ9doJrrHdODdJrW16CYAU8ATY9iIY1
D+MMxQqoPYYfATRC7i6IkD+pKXxRm9PEg6efhPR89m0sndwXDTrCvzNBQRvdbgs=
=DYcS
-----END PGP SIGNATURE-----

--A4pi7p1avD4z6Uqy--
