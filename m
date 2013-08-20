Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab3HTKoe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:44:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51963 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3HTKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:44:33 -0400
Date: Tue, 20 Aug 2013 11:44:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: grant.likely@linaro.org, swarren@wwwdotorg.org,
        spi-devel-general@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130820104427.GJ30073@sirena.org.uk>
References: <1368526032-31371-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FgWTvDHj0r903stt"
Content-Disposition: inline
In-Reply-To: <1368526032-31371-1-git-send-email-laurent.navet@gmail.com>
X-Cookie: There is a fly on your nose.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivers/spi/spi-tegra114.c clean use of
 devm_ioremap_resource()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FgWTvDHj0r903stt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 14, 2013 at 12:07:12PM +0200, Laurent Navet wrote:
> Check of 'r' and calls to dev_err are already done in devm_ioremap_resource,
> so no need to do them twice.

Applied, thanks.

--FgWTvDHj0r903stt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSE0iIAAoJELSic+t+oim90cAP/jgwvpA7n3C92Y1/ULcQHb84
samV9m0MchaPC7llFvdRhmnN5qdTn7R8y0hz+tjBQzWq1ys5qbV8e49srcUl86Ot
yYOXZNIWQKle30mfMfQXlOGozxCdawfNzqQvTJE4yikMaR4XMP4ggp6dV2IRuHAy
0QFUcZuRMVZs4eR7suyQ4x4mFg2Y2kIbzyVvz96QfBz3Ml/8D3NLEsM/fK5ezJwb
WfzkRHh1nwN+Tjp0tW0KNtzzkOQPibO2lYi+TfgJ02fWNL4XOTbnw7oc85ADlYXA
j293RZguP4M4wTE/4BWrVShi4udzuXZeQUx2GXLKUVlyFQ40664gQhG9p12nmvgv
sb1CYB8iBLvhhNRqkjfqt83Dtl33vhrKpLHESGaVHs0AofDmA4RA4ppunnhQuwaN
nYmxX9Wv+7Zo6R2JJz6GXxTHG1ecPest6naJkVqUihW0dZoSdcgDNRWMvqZ1LsXl
nyYjBIMjyagmo38nACQulkRD1xRe9exG5EfYCHCB0+ER7QRIrCWF804ADTSWLfVE
kMt2193YJV+HIGCQY9lUbjGq4BhQu5x+4RhC0r3iRR8QFrAV5Ub5GX0zR6w2/VQ3
E8ZX67cTHO2xVA9yOfreKS6OfqO5A289zrayoevVkVh47BNHc8RrxVWeaqTllF83
xbhsEktpvuwJBEz2vaqn
=OaPF
-----END PGP SIGNATURE-----

--FgWTvDHj0r903stt--
