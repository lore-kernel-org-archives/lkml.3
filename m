Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab3K0Q3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 11:29:33 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50306 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103Ab3K0Q3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 11:29:30 -0500
Date: Wed, 27 Nov 2013 16:28:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131127162859.GD14725@sirena.org.uk>
References: <1385559982-32039-1-git-send-email-k.kozlowski@samsung.com>
 <20131127152042.GY14725@sirena.org.uk>
 <20131127152358.GP3296@lee--X1>
 <20131127154221.GZ14725@sirena.org.uk>
 <20131127161323.GS3296@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGdfKiBebYi9ts3p"
Content-Disposition: inline
In-Reply-To: <20131127161323.GS3296@lee--X1>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/2] regulator: max14577: Add regulator driver for
 Maxim 14577
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGdfKiBebYi9ts3p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 27, 2013 at 04:13:23PM +0000, Lee Jones wrote:
> On Wed, 27 Nov 2013, Mark Brown wrote:

> > The usual thing to do is of_get_child_by_name() on the parent to get the
> > container to search in.

> What do you mean when you say 'usual thing'? Only the max8998 does
> this currently. IMHO the better way to do it for MFD devices is
> provide a compatible string and let the framework does the rest for
> you.

No, as3722, Palmas and three of the TPS chips do the same thing.  If it
were a purely Linux-internal thing I'd probably agree with you but as it
is we'd just be adding compatible strings in everyone's DTs to save one
line of code in the kernel.

--MGdfKiBebYi9ts3p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlh3IAAoJELSic+t+oim9jCgP/Rbo7ANSJJWvI2oXkvZ1vibK
t+WmTuBchJFKeRWCfQOQEUesSCAffhBNaqEAutiY2ibrK6Zbht5J3R7JpEMTi1jP
l+F5a/brULQ/LLRZm8CVCVixujRbYqpG/7VvjXR4M16sdc+XiVEYdzvAU8fU3tmU
gYv8qL0Ke1PCSLVYZf6GM7G+tSJTkhbRi96jQ0i6u+YBw3rTimlzWMkgOCZdtUQd
DrI/I0lpIx2Hn0KcDp0n5A0jy9f2jJpsg9cQJi+mNlOtoWJE7oDFp57EtN5k5pJp
QD0mQbnR9cTzYzraCoFm4hIb1dSDaQa2pUfuIhGKyopqMOz5eWmeHci1NsBMKJBe
gp0yBse9tZH5LmYXCHAkFy9TNKL5rwcdArHosQ6VvUaUCa0WLNH82LQDD6c0cKtz
bFO3Sv6Oe/cyD4FbsJz/qS7adVMZb/YqW5TRZ8JNKL+YKLgF6yQw7bMQ4/uup1k8
YDhhKTvxGCojLL9ooe9e+LZrsuSdC6OXVREFqvI+FY8HHj4ZlD6oULicrLXgqeN5
mq3x07cPjn63miZyo/GmpORofZ3T4zbgxhwOA6ZK77SQZyBrVACwUWJjtmlag9s7
4bi59yTWMm+sUpGQdL/6XT3uwHQB3/DyF74Yu3GFqfkhwOY/7+tOCmxeJv5nafQz
Qx/bcnL3Q9zU9k9pbunp
=EIXQ
-----END PGP SIGNATURE-----

--MGdfKiBebYi9ts3p--
