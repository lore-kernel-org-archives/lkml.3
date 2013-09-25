Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3IYLbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 07:31:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36280 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3IYLbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 07:31:07 -0400
Date: Wed, 25 Sep 2013 12:31:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Message-ID: <20130925113103.GN3226@sirena.org.uk>
References: <1379960073-23245-1-git-send-email-broonie@kernel.org>
 <1379960073-23245-2-git-send-email-broonie@kernel.org>
 <20130925111954.GG5132@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o+ZCuNqY+dEAKBWl"
Content-Disposition: inline
In-Reply-To: <20130925111954.GG5132@lee--X1>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] mfd: mc13xxx: Move SPI erratum workaround into SPI
 I/O function
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o+ZCuNqY+dEAKBWl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 25, 2013 at 12:19:54PM +0100, Lee Jones wrote:

> I assume this is okay to go in via the MFD tree.

> I've applied it until you say otherwise.

Can you please put it on a branch I can pull into ASoC in case we manage
to get rid of all the other users this cycle?

--o+ZCuNqY+dEAKBWl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQsl0AAoJELSic+t+oim9ZtIP/1I6ytcttm8Vceu5BU8ZbDCn
CLqVG04DCEP0fcKivqZph+5vxLgCzGJ/adZKi3EDgDiyOgMKsDHLvBHPg2KTcFci
YMlVHyBYOIvDhYrUTR9Ib5LmJl/JXy7m1N8yUMOJRvA+iakkSEvCfvqAxYu3Nofp
+JXKXINcij9kSt0DBLMTRU8qia9n7Kt8pKRLHXIyxWXzKQCim+6P0M4mzO+r1Lnk
uoVDUPqYeS3OG15ru8O9AWZFi9sCJiIf1+KllbYzce4B2l++/8b34LGt83zctilV
7FjLNxkxccof5itlm3cHyyaJejiUuoWmrPdp6yUR8AxdH4cs5jF0wgkicN8tCVkA
t8kTfC1ErtF7TN1ng5w7K9Hw2nOTjI0Lhxnmy2/om9TGjV9LJMSd2S/QjeqTLIrb
wMQ9YD6xV6a7pEYdR1p1tDZJprHgYgKDzyl/I/TwMFP0F3/uhP6YRqI4h6Pm3EJl
oG9sQbBzf4CPTS3RY/02vaDcgx5rGfVkgJ58a7lPOx054qMTghojGWUJZ2ATGY+S
qnJDtWQyx2K/mYWqccRNhE4DIdHsRkwgp3Kk5xuHtmpi0LEWnfKDHh9Rw4XPPxxX
IvGUxeNm8mIra76dCjXyigpB9rbE2KmK/gT3uWb8UuA2PkotN7VaI8k43QhpK+H3
a+eOROx2FRAcdRUrZUbF
=MCe5
-----END PGP SIGNATURE-----

--o+ZCuNqY+dEAKBWl--
