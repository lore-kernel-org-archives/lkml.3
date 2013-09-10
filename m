Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab3IJRG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:06:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44919 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab3IJRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:06:25 -0400
Date: Tue, 10 Sep 2013 18:05:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Wei Ni <wni@nvidia.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130910170540.GT29403@sirena.org.uk>
References: <1378722552-10357-1-git-send-email-wni@nvidia.com>
 <1378722552-10357-2-git-send-email-wni@nvidia.com>
 <20130909111242.GW29403@sirena.org.uk>
 <522DB253.6000707@roeck-us.net>
 <20130909135022.GZ29403@sirena.org.uk>
 <20130909155043.GA18975@roeck-us.net>
 <522E9059.3070305@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2vG6APDQ7NqBaH1c"
Content-Disposition: inline
In-Reply-To: <522E9059.3070305@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 1/2] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2vG6APDQ7NqBaH1c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 11:22:01AM +0800, Wei Ni wrote:

> Mark, do you mean you have patches for regulator_get_optional() and
> regulator_get()?

Not yet but they'll be there by the time the next merge window comes.

--2vG6APDQ7NqBaH1c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSL1FhAAoJELSic+t+oim9LcUP/iwD6w1qhA8jrlOHLbT6a5cv
210KPvGc5ErkR5UgmJKFDJj6yLx+997Cf49y2H5mshAxetKuW1FVPDPps/sbjL/g
hFFJEROmSqS6cAygR8FO4BVORJdK+F7HTXrCKBU++kpVJG5PSZG4/albJnhpPhA+
bQ+gvabaTOtBxgblL59BHM0l+Z7ZkFCoiaWxnN2P0gZnnbf0IwOmiGFl3/pCMfKd
Ifw7maj8cIIZkbQtv8ns4H8l4Yf4HhA0OXkWFiZA3PTEPpmKuVHqPIuBWwBC3+/4
/DP4vMY8D0iyP7hTmSQPmuWhMtoUCJRwbr4s1Tu5JXKv8TIYzn3v1bemlidP+DGH
R5NDI4kTgwyeV/sllVfUOCA2Co6Ae7H+2TDZVMiTaGFCKSXdvDd2SV+saVd+lHl2
vc6RvM0g2LEK0y9Y7SmGUxHfWMgUoWUZbH1xJi1wWbEgrBxsy62+ZekZigZjqPDo
5DFK3ySXzGOhVyRfuWRagI1dRDTBzajsJhJEC2bdS6MF8xnDw760O4H1SVoaOaxE
vcn/S78kKE4rqV6dQGZvx1YpWXkstobgLUBz0cChZwC6rexr+71dUZEQtp+m2MWe
6nAw6wD1tq3jAPn3IRlMyUxGW6YZAw41esq4mc3wvarD56EDGFOwJEfaN/t7OvY6
NNpTAAUWR8yahcCrDBHS
=cd1p
-----END PGP SIGNATURE-----

--2vG6APDQ7NqBaH1c--
