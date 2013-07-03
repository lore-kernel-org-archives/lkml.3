Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964783Ab3GCSWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:22:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40672 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3GCSWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:22:03 -0400
Date: Wed, 3 Jul 2013 19:21:45 +0100
From: Mark Brown <broonie@kernel.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net,
        Ryan Mallon <rmallon@gmail.com>, mika.westerberg@iki.fi,
        grant.likely@linaro.org, hsweeten@visionengravers.com
Message-ID: <20130703182145.GA27646@sirena.org.uk>
References: <201307021006.26694.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GUipDDFi6+9KiMah"
Content-Disposition: inline
In-Reply-To: <201307021006.26694.hartleys@visionengravers.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 02/11] spi: spi-ep93xx: use read,write instead of
 __raw_* variants
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GUipDDFi6+9KiMah
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 02, 2013 at 10:06:26AM -0700, H Hartley Sweeten wrote:
> The memory resource used by this driver is ioremap()'d and the normal
> read,write calls can be used instead of the __raw_* variants.

Applied, thanks.

--GUipDDFi6+9KiMah
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1Gu2AAoJELSic+t+oim9KG0P/iAKjWhU5EhkyfgSP20LCUC3
ZMbGvhS8wKwd8cU/NtJZc78x6W26co60ciMBfZJX/FrtsdH5GHPwx1aukuhrAgFT
TpxGRkfISSF0XQ07ucovl410OgX1oWeJr/ZDN6W/vwAelM1gUmeFdCGbY/zaDk+e
aisxZImCSwzYM9j9vL+5b3/DimGH49HNnS+4oXsYw+1OLULSBMmLU5+5mxjclD89
J0DthrXa8qiUxa1wJvpmSnWkPlv4eNjPtYEh344oa9PonKCpKs03tw+zw3LO9Gbf
kX3E3Tod5NqH0DsrYV392ZV2SFp412uMDyAywijdjGk2tUAhjTJHxS4WOii6x5VP
2pEuF355eGMk2bcBrF0493ngCZfh/Ebdr7BgBFVt9z2GttFuAZptiw7rMVW2mJQj
0pn3XJXgQWsIldbtp40RIKOKKtQKUMqkvmmYQyf01QexURXkPALF/NcF5Qy+Ef24
z3P8EJ+tn8S+C+j0zKqP1C4tWhckxEswCvv6lEsuI3FHRwuwtB7In0qVwxDgutOm
Ue/vb27jCk1qfRWlzy0V/McSwoViXYxK0wMCqEdbL6G8Bv24/lxSctjpdfGFCRst
I0h9cWC7eOJOKREbYyhdfZex77sduMpTOaK1GFCamGmObi9jA6bkQBjN5M8nYSYS
i1/Dhsny6qsO26PEh7Ew
=GKRI
-----END PGP SIGNATURE-----

--GUipDDFi6+9KiMah--
