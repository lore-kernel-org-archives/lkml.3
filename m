Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaBOKJw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:09:52 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60643 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaBOKJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:09:50 -0500
Date: Fri, 14 Feb 2014 20:30:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        kernel@pengutronix.de
Message-ID: <20140214203053.GO4451@sirena.org.uk>
References: <1392126225-7017-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AKkMM/tm2Mk6Yn/s"
Content-Disposition: inline
In-Reply-To: <1392126225-7017-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] regulator: anatop: Add power gating support to
 digital LDOs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AKkMM/tm2Mk6Yn/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 11, 2014 at 02:43:44PM +0100, Philipp Zabel wrote:
> The ARM, PU, and SOC LDOs in the i.MX6 PMU can completely gate
> their power output. Since power gating is configured by writing
> zero to the voltage target bitfield,, store a copy of the
> voltage selector to be restored when reenabling the regulator.

Applied both, thanks.

--AKkMM/tm2Mk6Yn/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/nz6AAoJELSic+t+oim97o8P/iyggjXDu/T6vQDA3w2RIPjw
5k661r6t0ZySYCn5alEWwBoAYSX59iF6Y/yMu+yaSNT61WCJaUCSWEh/kyc00X7T
pgkoJvGx/WV2FagvKrSOw7BqMnA46T4g9n7AhT43aS/SLdBGZUWmOOp+VcmAjFT2
F6TF2UIv1vsFicPEdi4innQ6lg0lRhfPF74afQvivauDeM3ZURGz1BKSGoOpRGKK
+Kny6rn2H+QjRBG44C4whlk3S4pasdg0CPm/XHaxC8Hb3tCOd5gSzpslljVuGDcX
hAlioYxHj+hV7Ah868ZFkWtClvRoyOuAh5dHfkTDgSTGId0m2lKrf+UOPJip5NPi
+sinzcf9PKHGOKuspVs9JQqMOBf/cvg+fUmhJU1qazzP/XhUV6aNSBdzYpI7bS8G
qOJvFjSaGLYIMEeu+ULBRMKN+0J+5X95eT9ZEBKE/U4OouDRkwlYMNYkhZAZuW2U
2GSJlnMKvSMi2vc044dx/RyxpWo3by45o1QR9WnEGtbjyMDAmyQzQfwxudjptYFf
bCVF0rdMdELkQYK4uNYYtVa6d3xSqFMSXWkI5+PQ58Ivt1MRpW6yFSYO8V23Lsex
vUgLBccxXufQeTZZNYOWN7bcIkoSO0aet9jWLQdcEVIeqm4Lua/amMEAnnyJDXDU
ohgRVEOX8+e61kyuFjZG
=813D
-----END PGP SIGNATURE-----

--AKkMM/tm2Mk6Yn/s--
