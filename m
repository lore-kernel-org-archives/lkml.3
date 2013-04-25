Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757344Ab3DYKuN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 06:50:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50824 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596Ab3DYKuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 06:50:11 -0400
Date: Thu, 25 Apr 2013 11:50:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Matt Sealey <matt@genesi-usa.com>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: mc13892: Use regulator_map_voltage_ascend for
 mc13892_sw_regulator_ops
Message-ID: <20130425105010.GL5019@opensource.wolfsonmicro.com>
References: <1366807349.16547.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNftq4k6NuHCGvy8"
Content-Disposition: inline
In-Reply-To: <1366807349.16547.1.camel@phoenix>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNftq4k6NuHCGvy8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 24, 2013 at 08:42:29PM +0800, Axel Lin wrote:
> Both mc13892_sw1 and mc13892_sw voltage table have ascendant voltage list.
> Use regulator_map_voltage_ascend for them.

Applied, thanks.

--PNftq4k6NuHCGvy8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJReQpYAAoJELSic+t+oim9nq4P/2qvwG6eR+2nW0NIVy3n5tP7
a1mgbL0/FrSPEfaVBk/+caVECl0O5tfUVUErWnLN3fqe7xHaSXzcvzqJ8KbsGTRS
0nLeImUYYuRnRGPIgCUd+pTnJbA4SuSHUxxM8/fZjjbuX6KgL1miSFtjUxURNG3p
ufziCcoyEptZEHsn9O+4Oq+0cTcTuUNiAwYFvTXsNk3L8vkVaobL4rM4pggToj5c
yFzaH20ZZ5eAJDoD9gpy7OewdAidcYjMUYyj6RisVNljAcxTv5W/rLzJ7a+ZCRJw
pOzRPvpFIiLYyoyGKg6XPqFTIMvnviPXLqxotK3Mhav5Pu/2kxGhU7k/Zi4KSWh2
ZNaOMwjldOcf9AhirucGSCZjRpekNYyvI16tBNVLPYud+/Obo08RIhjAOYT/0xfX
tw8mtIfCAhbpk2RwkgP9ZEfUWggzTLAOBi4BnpgGe3sT+SmqS0I/ofBSButpCWB/
OVBZV9a4mf+0GhwwM7bZDtyW+Sj5WiOUnRU7zPkWpgj1Z9Pwf65rNJiHyukXZxXa
SSKf0pnf0EdLJ0UzLSMYVU5d5fvIZwbKj2O8nsHVsU4JlEJg0wWJ3tQEJhWv8S67
0v4qzTM43ZAgJXVqJNYj6uRJZFWKIYJXgKyQcwvNTK5BYvjLfYGHSfUdiUvSuW9y
V7AOGJdcZEkTsZr95KT7
=oseJ
-----END PGP SIGNATURE-----

--PNftq4k6NuHCGvy8--
