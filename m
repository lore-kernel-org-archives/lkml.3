Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaDAMZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:25:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49889 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDAMZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:25:17 -0400
Date: Tue, 1 Apr 2014 13:24:54 +0100
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: Guenter Roeck <linux@roeck-us.net>, "wim@iguana.be" <wim@iguana.be>,
        "w.sang@pengutronix.de" <w.sang@pengutronix.de>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140401122454.GS2269@sirena.org.uk>
References: <1395800500-22655-1-git-send-email-Li.Xiubo@freescale.com>
 <1395800500-22655-3-git-send-email-Li.Xiubo@freescale.com>
 <5338E1E8.4030700@roeck-us.net>
 <28375308b05f4cf4bc7d1559f2524c1b@BY2PR03MB505.namprd03.prod.outlook.com>
 <533A1A4B.2090503@roeck-us.net>
 <1c79a81bbd7b4cc79689cb907e81e893@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v98/5hv2LQXhs+5A"
Content-Disposition: inline
In-Reply-To: <1c79a81bbd7b4cc79689cb907e81e893@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 2/2] watchdog: imx2_wdt: Add big-endian support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v98/5hv2LQXhs+5A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 01, 2014 at 02:24:12AM +0000, Li.Xiubo@freescale.com wrote:

> Yes, I do think so too and there has already regmap-mmio version patch
> Series about the IMX2 Watchdog driver, but those regmap patches for
> supporting the 16-bit values are in Mark's tree and the IMX2 Watchdog
> will depend on them.

> How to deal with this situation ?

Well, anything that's already applied went to Linus already so is in
-rc1.  Anything else we can either do a cross tree merge or I can apply
the driver.

--v98/5hv2LQXhs+5A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTOrATAAoJELSic+t+oim9fQQP/0eYY8J+plgQNDMK0m8VW4mq
8EUIYrQegO1CHtTNGd/GWw1WgzQ6MOiTHmwNzx2A0u9jO8DFuPGqJRHTJ8BDdsXu
byGfpsP55jaDxBA6XVQR4uKKVByLyMGtL4O9bA/22yRDYvcagB7rLki7J/SZDro8
nkw3Ot+85TnAnaZ96CbwQjHCqP8GiyWSeSsg0R5NAe1MdGuyYZeVROfwaXFNGQoW
S8VF3aVs6LH+4lH9umfnVTKYWr1gqQJy0/a8RzsR+Q+2i0kxtQGXY2/axZsY4xFE
bC6abn01S4zpklhF5GkR1fwp7+LE5l/mYMaLB7XTo9hB5mqlZro3iJOI+QIeIH/n
Cf4m0uVT3SOoR+s9vucIsyY+Op7II8fMbAok2pRKh6uab70C4ehdOGxH6E+aRvQ5
/L9Okfn/v1qSgCxWSNN3lDqkVmrjZ9OhBs6IAblqtYz/ZU4c6xXPk4U2U8UAmiEk
6nLpbQ9wAhYeLPRgfMhFft0tD+Cb74Ht7hWHvuAnwwvgI+eIoVsDVM3YHxJodpAJ
xO5p9itQp4osc4qPcn4D5LidfRJFJCPPvjosm0jnenjEAVbxegRqeJr/Bk20Wifb
77EG6OxBhn4GAx76p36mRkymNFEK9jHyLDhaLr0pRaXgG4rlLE2cSXTHS/gG0HG5
eGJy0WZXvVBJUJ6fx+hR
=CHmZ
-----END PGP SIGNATURE-----

--v98/5hv2LQXhs+5A--
