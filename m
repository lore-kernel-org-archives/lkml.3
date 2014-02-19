Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbaBSOAK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 09:00:10 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44029 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaBSOAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 09:00:08 -0500
Date: Wed, 19 Feb 2014 22:59:38 +0900
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Lee Jones <lee.jones@linaro.org>, Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Message-ID: <20140219135938.GY2669@sirena.org.uk>
References: <cover.1392807832.git.michal.simek@xilinx.com>
 <fa3178534fcf4488fc45a9a24e44b2588acb38c6.1392807832.git.michal.simek@xilinx.com>
 <20140219114132.GC10504@lee--X1>
 <53049932.8020901@monstr.eu>
 <20140219121756.GM2669@sirena.org.uk>
 <5304B6E8.1090508@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NYU3Joii+X7L5SBl"
Content-Disposition: inline
In-Reply-To: <5304B6E8.1090508@monstr.eu>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2 1/2] mfd: syscon: Support early initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NYU3Joii+X7L5SBl
Content-Type: text/plain; charset=us-ascii
Content-Description: e
Content-Disposition: inline

On Wed, Feb 19, 2014 at 02:51:36PM +0100, Michal Simek wrote:
> On 02/19/2014 01:17 PM, Mark Brown wrote:

> > Like I said I've never seen the user you're adding for the regmap API so
> > I've no particular opinion on it.

> 2/2 is the code where I would like to use this when clk subsystem
> start to use better io helper functions then just static inline
> clk_readl/clk_writel.

> Then my 2/2 driver will be just nicer than current implementation.

OK, but I still haven't seen the code (or Lee's concerns for that
matter).

--NYU3Joii+X7L5SBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBLjGAAoJELSic+t+oim9uBMP/j5NhqgXiHdtu2xRMzpqHjfg
hA09jRgIijyW7jgy/1Zp2YRtuI7ryNNrQqfvwVdix+svmgEjcu8Nahvlh4+f7PDm
yIZrYIJNDP86HsOYKiRG0FgXhUY+EOl/cyp3SS4Id5767aruyrR/e8N0WOE/3iFL
b369/XKMr7h1s6n495pE3af3o69CifzUd+Agc6CtTpwrhuBoV01poDj7lObXx7wf
Ig/y/BwnY7qHcP4+k9aRB91K1tavybldXNGWvFjr8AP6Y51YCZk+aCDLQrmqK98h
19YayNhTnQ8Wt2s14FHuzER4fbTWyrAG73jlx44oiwhqPFu0PYBivgKE9HoYHqJP
tDsIXicfCMgrDoIXwxOqPeK5MuVw0V3y8ITqwnJ09Lgb1xFP5PSa4hP/JdpG3F+x
HhAPsFoXSN0l0Ac/fqRBKoICsEzWXJjusny/EiunuqDPGHgqhY/9JtjvecBmX20V
Cs4As2kaLY7/Wvx4zuaMlrC2ezE4ID5XfVKeL/+u/DqP2bw7w7CVGo56dQJh4ew8
esCKx62wDwYAW/zLMOJJdddVRMEFZvb5h2Y7nlpTtdydp6c2QOjSsZKjKniisJqA
6z1BoG2KmM4gNVrS7RKImH4fv48EKZ3cTn009DEp4iRcIp+Z7ihkyQpOb+pXXpr/
rmnDYL21HRb1M1jpVi7h
=KpQZ
-----END PGP SIGNATURE-----

--NYU3Joii+X7L5SBl--
