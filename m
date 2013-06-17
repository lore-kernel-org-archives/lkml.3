Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab3FQQQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:16:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45346 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab3FQQQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:16:44 -0400
Date: Mon, 17 Jun 2013 17:16:15 +0100
From: Mark Brown <broonie@kernel.org>
To: J Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, ldewangan@nvidia.com, sameo@linux.intel.com,
        grant.likely@secretlab.ca, swarren@nvidia.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        gg@slimlogic.co.uk
Message-ID: <20130617161615.GH1403@sirena.org.uk>
References: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
 <1371470954-9124-2-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e400VJpV0WKd7yPD"
Content-Disposition: inline
In-Reply-To: <1371470954-9124-2-git-send-email-j-keerthy@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] MFD: Palmas: Add Interrupt feature
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e400VJpV0WKd7yPD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 17, 2013 at 05:39:11PM +0530, J Keerthy wrote:

> Palmas PMICs have an INT line. This line is one single
> Interrupt line to the application processor. The interrupt
> feature enables to selectively request irq for only those
> specific chips which have INT line connected to a valid
> IRQ line of the application processor.

Does the support for the interrupt line need to be explicitly flagged
like this or can the driver not simply support an interrupt line not
being configured?  That would also support cases where the hardware has
an interrupt line but the system integrator has opeted not to connect it
for some reason which seems generally more flexible than doing things on
a chip ID basis.

> +/**
> + * DOC: Palmas PMIC feature types
> + *

Is "DOC: " normal kerneldoc?

--e400VJpV0WKd7yPD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvzZMAAoJELSic+t+oim9XLIP/icg6KMcilsysuuLYKlrwyfd
J5e2y1QtL+wkiQF8jqXQFVxRzYOaBrjSITYGC+OQN0lvTXXKhCtuZ+4ptCjRPb6H
hc8/IJDdX9vTVyr72bcwcZ7BqCPCcRiYW7KGjspveApcX9w6ex3pJQelC5wMoXcx
XKds3Nk0uKj1nZrV/g1H//GoO15w4THw3SDoX8tmUsGwyCKkFp9YnO1Wzy0pcm0y
iTqrhH1hq0VqX6xAWGPHpE4cIm+Sy8YPRYcOAIoHaU8/6XAuKAVduTJmLMf42KM7
WJn5m7I1U5Q1si8/V2AM8s5JSqA8/QvU3C6epGNVSIXBHwmx394an2PUvSmCZIEr
RqyHSGCzE+OppHp07cLmerbxflQCp4BtKYf6NkrRbp4vPmpVQhq+G76J2/a11NO0
HMFty1mZ4t4To3nm3qz2u15wWj2O1oS8+BacNI2DmwRTn0Dz/Q4oVZ17yyle0a1z
gsKjPBdUCErqhw4Am4UjXb+kU5M383BaUKEz1p3cl+jS3qoaWMmhtthttnqwQvTg
eAeim6ZV+yHDYUTm73+7y2R9vKeEjRsmFQHF5sf7+E/jcoBAjJK74BCuJMyvUoLi
/eWzwnkTNDLE7dQ9OJntPJ3H7CMe/apZs8esmYj1dOumHT+GQAUfbN/oNufwJQdQ
JZUuFH8OoNmU9KuLOKiB
=DKcL
-----END PGP SIGNATURE-----

--e400VJpV0WKd7yPD--
