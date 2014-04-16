Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbaDPVF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:05:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35409 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbaDPVFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:05:55 -0400
Date: Wed, 16 Apr 2014 22:05:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Jane Wan <Jane.Wan@gainspeed.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, Emilian.Medve@Freescale.com,
        b48286@Freescale.com, jg1.han@samsung.com, sr@denx.de,
        insop.song@gainspeed.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Message-ID: <20140416210528.GB12304@sirena.org.uk>
References: <1397678979-7655-1-git-send-email-Jane.Wan@gainspeed.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="upHqgONuYbTeMWr5"
Content-Disposition: inline
In-Reply-To: <1397678979-7655-1-git-send-email-Jane.Wan@gainspeed.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Configure FSL eSPI CSBEF and CSAFT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--upHqgONuYbTeMWr5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 01:09:39PM -0700, Jane Wan wrote:
> Make FSL eSPI CSnBEF and CSnAFT fields in ESPI_SPMODEn registers
> (n=0,1,2,3) configurable through device tree.

Applied, thanks.

--upHqgONuYbTeMWr5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTvCVAAoJELSic+t+oim956sP/0RFWCq+s8VfcmaasODaTNU+
sjoBmhK7/xcbn7jFfgDtLD9tMpS+3UNNkumDagepvU1VSfjbSUvYS9/5MkCxPYIG
S+6hG8PI04wLV5Fgs59ZmX1pIKcQXq2zfLrylv8hynVjSC6+MTZTpLhOkE2uUoz4
A/EyS6z4KN+jcGeqNkl2mAXBBxg8pk5GubwtJc7Dnx2c7QnsiH4jNbKejs+OWqr8
QalKP6DN7kuvrrS8ZalUNJRJ7k8yTywS/FrHqVGwhjbUrOSGC60KyPWZPG2Yq9Cf
f/n+mO2fmWlRDXsINOGW2nHrha8TBRpkg0llyMvu4ItLHkUCEUQVVloDIAUz/5s9
+h75wHqhL+ztjp+OAZZMiS4HQChk4P7ImWejW1RvqE+mYUqcd6xxJaR3VPVo1AKM
vuR7kVE+HAsAHybdBv9A0kENxB6Yo76jjVOKIwFIv+50Y+OO+eYlSSPJHYKc4Afe
dTBZLXQFo6e+QDWx2jDOJX6YxLhOY1iFKou1LfDW2vTxfp0bmHNbqHx+6z99tLW6
cs6JtRLQfXqbaK2xK3okJDieoK2a7fFY5k0S5TKkV8SWOlU9L3BjAlpEsRpjccz6
yiM5O/RAXzaRbbeAQgcVQSioxdjI3itK9zOYRywtJHA6/EGX1myoQFFBJ2BnlDx4
Z6GUkQ7Qx74ZWGL2X0ki
=QfXr
-----END PGP SIGNATURE-----

--upHqgONuYbTeMWr5--
