Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956Ab3LKLD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:03:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42433 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3LKLDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:03:21 -0500
Date: Wed, 11 Dec 2013 11:02:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Mark Rutland <Mark.Rutland@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Hanjun Guo <hanjun.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Message-ID: <20131211110243.GM11468@sirena.org.uk>
References: <1386088611-2801-1-git-send-email-hanjun.guo@linaro.org>
 <201312102100.20570.arnd@arndb.de>
 <20131210202323.GJ11468@sirena.org.uk>
 <201312110407.27848.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ybNbZnZ8tziJ7D6"
Content-Disposition: inline
In-Reply-To: <201312110407.27848.arnd@arndb.de>
X-Cookie: If your bread is stale, make toast.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Linaro-acpi] [RFC part1 PATCH 1/7] ACPI: Make ACPI core running
 without PCI on ARM64
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ybNbZnZ8tziJ7D6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 11, 2013 at 04:07:27AM +0100, Arnd Bergmann wrote:
> On Tuesday 10 December 2013, Mark Brown wrote:

> > That's not my experience especially once you get into phone type
> > hardware - there's not much complexity difference when gluing things
> > into the system and the fact that it's connected by the board increases
> > the amount of flexibility that has to be coped with.

> Yes, that is probably right. The only argument that one can make about
> the mobile phone case is that these devices are so complex that nobody
> even bothers any more running upstream kernels on them on any CPU
> architecture. If the kernel code is kept out of the mainline tree,
> it doesn't matter to us what they use, and the developers don't gain
> much by following any of the available firmware models either.

It's more of a commercial thing than a complexity thing (complexity adds
a barrier but it's not fundamental) - the designs for phones aren't
meaningfully different to those for tablets, and looking at both things
like the ARM Chromeboos and what the low power Haswell stuff is doing
laptops are looking an awful lot like tablets these days.

--4ybNbZnZ8tziJ7D6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqEZPAAoJELSic+t+oim9yEUP/3/W0aed0+9LYMaM+dC8WIbR
v32IXLlniBXID/6jPm+O0vBihCzLkiKYSMzwUpmaotXJpL0WwBwjI1zxsertcdVd
+juC71igWk0FA4MC7q3srEz5TMfsJMU/1M2NHtgHlvYPNURvOpo6QyvzLly9ZK6u
Wu5hWg7bVkRU1nxaVK0H2Dt8cpWlvmzWLK3XOMjsaVI1r1QOyupboQh/gNuR0c48
jZpGh+68t2HR9wFGC4OOWNq6e8caMaii3z0nLxsoSXPZv+Am3bEFn2sSmvnu3rHf
anmuhoW1UVJRBxg0DrcRHIbqGrzWqw4u19iqLCJ83kc8lDzs+naiNapU6hp7RCYW
r0jAuBImwkXBOsDkqpDqUO/1v7IPHc9TJb9jsJean+N7ari3IajfKLzxMYuhH3vf
JpCyDQ+TQKR49YVxeu8JWX5BuEIIwJipcMTWRYo35qHifnhL4sCzQO7ln8rzJwh3
aIFyPP46OJlLNaamWb1tgXvgpeLYdy0lCfgvUZJsXN67FBtEk5DAjmzVdKGUeNik
Y3fSxrEI+efodwk4NOHbEfX2rKXXfz3/p+GZC5q6+pQTfRS2jz3CyAEJNIDVpbbn
RrUA2epPtB6QxI19v9alkUStiZde1tXt3R8s/7FkvV9ji2dP2qjhzvv7QmlrjbwX
AuF/LSEAmsehKvp/U3LU
=dVe8
-----END PGP SIGNATURE-----

--4ybNbZnZ8tziJ7D6--
