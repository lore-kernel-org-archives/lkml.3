Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaLHMOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:14:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51994 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaLHMOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:14:09 -0500
Date: Mon, 8 Dec 2014 12:13:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Lee Jones <lee.jones@linaro.org>
Message-ID: <20141208121342.GW11764@sirena.org.uk>
References: <20141208230517.13ebfe4f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8R/sMIKPJVD0CT2D"
Content-Disposition: inline
In-Reply-To: <20141208230517.13ebfe4f@canb.auug.org.au>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the spi tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8R/sMIKPJVD0CT2D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 08, 2014 at 11:05:17PM +1100, Stephen Rothwell wrote:

> Caused by commit cf9e9c98fa8c ("spi: Add new driver for
> STMicroelectronics' SPI Controller").

> To me COMPILE_TEST means "this builds everywhere, make sure it doesn't
> break" ... not "lets set this and see if Stephen finds anything" :-)

> I reverted both commits for today.

I've dropped both from my tree too.

--8R/sMIKPJVD0CT2D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhZX1AAoJECTWi3JdVIfQkQEH/3+wucZbumeo+0/XaofRSaTP
TH35VFxE5thQf77CnXJrib93MxZyBHYawnBSAiwDGGB8cF1sffwhaOmOvRjcYttR
A7eORNk/L4eK9vUT2evbKsFZCCp67ZrVE6yB1E5qitjTlxJ2WI3jwPRKtOvDhmyY
mr7tqbyhK7OLwZzb/gyzNThWy4xcQgpF7CFYK7kLQfia6Ga1QF+z2gkKQzfsUhh0
ulRj0h3fzsruxXFgVtF1ODoguAlydc9loiLJezIPjLpboq3fRU41dA1OQ9uS8/so
fhg2X/wN76fUvBGa0pZZWAUkRF8bcASpljRCJ+tPXp5wkLkucrOwwCXiE8yEk4M=
=QBWY
-----END PGP SIGNATURE-----

--8R/sMIKPJVD0CT2D--
