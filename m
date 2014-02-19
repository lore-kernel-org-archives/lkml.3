Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaBSXUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:20:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36330 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaBSXUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:20:38 -0500
Date: Thu, 20 Feb 2014 01:47:47 +0900
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140219164747.GB2669@sirena.org.uk>
References: <201402191637.s1JGb4t9017699@swsrvapps-02.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mech2hSDWJXuRHhb"
Content-Disposition: inline
In-Reply-To: <201402191637.s1JGb4t9017699@swsrvapps-02.lan>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 113.32.54.66
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1 3/3] REGULATOR: da9052: Add new DA9053 BC chip variant
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mech2hSDWJXuRHhb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 04:32:47PM +0000, Opensource [Anthony Olech] wrote:
> Add support for a new BC variant of the DA9053 PMIC.

Acked-by: Mark Brown <broonie@linaro.org>

> There is one difference between it and the AA, BA and BB.

Which is...?  :)

--mech2hSDWJXuRHhb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBOAwAAoJELSic+t+oim9l5sP/2WNMoOLZpYb9Ns6AMZxKh/j
BoYc5ao7N+c3X37mjteo7y6S6u26AagulDxVYkzSQ24fikvMfnwEAg4UJ6iZmSM3
N0SaCBZY7WOT+rz2v5IwCpbQNUyP53tZNI2Re/jscnnBQsf6eMwaUWCpX5tvnneZ
u03T13Ufg1rxIa9HsX04njqHVCcl/AkXp/DnhDAnr9MoowxohG0d58BnHc0ZmToi
qF18wOiR9ECmMCJjyzhHIZouBQLi6wxN1dNQkIEDmh7KHIq4CCONswwjWFhmMb/C
C8cx2KmBRUQm9tI51SPnQcfQUWygyNZInRpVRofsQmY/FJP3iT2h0dUBVb+4GiDB
0+VVDsegFGhPtOFyxRj567iGNCtDS8ugH3goaJmqUct3QaXBWKYkuYenwRERxJqF
F8cKxmCswfyLlwi40xjmmZRKx3cCNYrPZqmljB8j90+8sDVZKDVG1MUx7U9U6od+
BEuR929jR8fTePOcRtWGU5jV/3GBOmLGZecw5cx1w1zgBO7sPzHLcsNBOxJV9XoL
SVJrQRhMiyFDdmzVJBxKIUJhhj3pTvvv9KfF/WHyiE1naLJRwBa2e76bZlTxTd3X
lQTl16xD6l0db/FtP0QBrvxI0ZcjzGDNcrujxR7tJJwQDw6zUpzgUPqRxFqRhU73
9XUTSLr4FAbBh1YDb7Xi
=sNJI
-----END PGP SIGNATURE-----

--mech2hSDWJXuRHhb--
