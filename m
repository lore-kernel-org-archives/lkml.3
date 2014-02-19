Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbaBSNF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:05:29 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43058 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbaBSNFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:05:25 -0500
Date: Wed, 19 Feb 2014 21:17:56 +0900
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Lee Jones <lee.jones@linaro.org>, Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Message-ID: <20140219121756.GM2669@sirena.org.uk>
References: <cover.1392807832.git.michal.simek@xilinx.com>
 <fa3178534fcf4488fc45a9a24e44b2588acb38c6.1392807832.git.michal.simek@xilinx.com>
 <20140219114132.GC10504@lee--X1>
 <53049932.8020901@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9OBXiyLbHWeQuzfF"
Content-Disposition: inline
In-Reply-To: <53049932.8020901@monstr.eu>
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


--9OBXiyLbHWeQuzfF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 12:44:50PM +0100, Michal Simek wrote:
> On 02/19/2014 12:41 PM, Lee Jones wrote:

> > I believe you were waiting for Arnd and/or Mark to comment.

> yes on Arnd because Mark already applied that regmap part.
> But of course any input how to get this done will be helpful.

Like I said I've never seen the user you're adding for the regmap API so
I've no particular opinion on it.

--9OBXiyLbHWeQuzfF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBKDxAAoJELSic+t+oim9zz0P/19J7Z++YQgDYS77rZJoZ8bJ
3pPe9akSA8PuDQoenO1ZMiWSolmIPwBVJugqpT5GJZOs/pdc+nloWvp09RjpKPvq
Fi2Kav8El0qfqxfK/t7hzxOsvYuEN+24vpuw/vGy6bEXXN83rIacTLIBXoCTvOsh
wiDt1VCdwd7uuNr8DR0A4Iq+Ri5aouv7CrbHS7wQ0dHWdRBv7xlcPqDKK2VB05bK
1w56wNj1I0vTf2ILxeD+JAiOz9Pni149v7kITqosfWmQ8yYjIvojy8WgHk97kGWz
Wk6PEucQbb9e4QbX2tZey4BT8QX4uw2AyUwOYUcbEB6iscfQ6LQEpYIJNzrCd5v3
oYJJkzHHANqQ+FhSYjsqfKkbFdaoWD2xSUTW8eJDOibdcCnbPtfktsKqeWGPQPvi
32V6Yhvoq+I0rO5Ba0OonhxopjTBwlkrDfbkqUvnrgdvvAMvGjVEIIdTfXwsopBI
Y7hZNlypeCD3Tv9wZzKCIWHHDcuITvJw0/19VC0LTJNB2i59bSuDG9LVRoqNCndv
ixrbxCYBaAB8DPG3+BFudGU4kaV3a01kI0fsJbpUV9xyMPBcbJbgEAjFpc5uSSzA
5EirwozvajVbFvDMEhofTYmLxmd0CWVsQGiLehpFdkBnoPaS4f4KeGXRVgNk7bd4
7FhIeeC9xIG7GfzR3Sva
=IYdr
-----END PGP SIGNATURE-----

--9OBXiyLbHWeQuzfF--
