Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935061Ab3FSSVs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:21:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33940 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3FSSVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:21:47 -0400
Date: Wed, 19 Jun 2013 19:21:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Girish K S <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca
Message-ID: <20130619182121.GC1403@sirena.org.uk>
References: <1369032694-13183-1-git-send-email-ks.giri@samsung.com>
 <1369032694-13183-2-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bmO0DhbO8B5xO2aX"
Content-Disposition: inline
In-Reply-To: <1369032694-13183-2-git-send-email-ks.giri@samsung.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 1/3] spi: s3c64xx: added support for polling mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bmO0DhbO8B5xO2aX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 20, 2013 at 12:21:32PM +0530, Girish K S wrote:
> From: Girish K S <girishks2000@gmail.com>

> The 64xx spi driver supports partial polling mode.
> Only the last chunk of the transfer length is transferred
> or recieved in polling mode.

Applied, though I will send a followup since:

> +static u32 wait_for_timeout(struct s3c64xx_spi_driver_data *sdd,
> +					int timeout_ms)

...this function name is way too generic.

--bmO0DhbO8B5xO2aX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIbBAEBAgAGBQJRwfaeAAoJELSic+t+oim951IP+JEo+8Zqw/fhTNRCTOjM/y4a
9yuRc0Hm09jq3fUXm89ImE/XnckFdsYsHf/qiN/b4YRsl8sY+X8pMdocC+Jxf/5h
WTF7iwIxyvxQVrTrDw0z4mUw6RAUhHpOsyxje8KMlDnkrA0xKAX1wgwExHuSPK7f
7rwrZ211YRL4NHesbX6MlSzcE376PBxnoDLoHfAmijfF/R1y6kUnAcUseuZ81Tx0
Igy24nH1fOTU2PxwD++PlzIqOlgPZQqFbtGDychCSCFwz5smCrabJcYiOLrUFDvR
sJpQ/sshmndtYsBYlp3/jG0IelBI/UJTLu0i/2hDpN7d+G9QiqidRD1xgXfMUCbK
gz2GShUDyYCeSFZ+H7CR1Z1R/ftBUyMA1VOHAsDJCbI+bIzTbig/Mi4J0wWuBpon
OWupAhsrAR/uvFa9rIQSUIeGppttrZHnFFoEHOPXfL4anLFwQ4sIIiU41OHY9q/w
Bn1scm5p/gW0aT62wR+jHYgVNUl3iOSjb9TvCVIuw7G1x4LUp8OtEGUgDsKbAvfj
UyFqLqXZb6khHheWY67PGIMWFee5xlhpMs3Aw2CYF8GToAQ/NBn0Rf9fK+7+Mhtd
pL8zlEfx1VZp1wRKpjIUImZNNX95IKgXQ2XRiAMeEiT+S5L0/xMmdZlyenpN22Yr
IFvqF7iuw3OtL4DgqJk=
=/Frv
-----END PGP SIGNATURE-----

--bmO0DhbO8B5xO2aX--
