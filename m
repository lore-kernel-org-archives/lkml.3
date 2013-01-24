Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3AXExM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 23:53:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43113 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab3AXExI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 23:53:08 -0500
Date: Thu, 24 Jan 2013 12:52:52 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: AnilKumar Ch <anilkumar@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: tps65217: Fix using wrong dev argument
 for calling of_regulator_match
Message-ID: <20130124045246.GA4955@opensource.wolfsonmicro.com>
References: <1358994450.20257.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <1358994450.20257.1.camel@phoenix>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 24, 2013 at 10:27:30AM +0800, Axel Lin wrote:

> -	count = of_regulator_match(pdev->dev.parent, regs,
> -				reg_matches, TPS65217_NUM_REGULATOR);
> +	count = of_regulator_match(&pdev->dev, regs, reg_matches,
> +				   TPS65217_NUM_REGULATOR);

This will break the OF bindings for these regulators as the platform
device doesn't appear in the DT.

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAL0FAAoJELSic+t+oim9GGEP/RWfICvLg8WmpqMwUWlJcoBB
TbaA2KtGaYMpFHMguLr0UyW8OtLW82Eh200eMMrHwZ3kwovBdck0Ucei5ALaVKis
zLQj5GRLG5IFqGuxc/BCWhCx1rjOOwKxptO2aw0FkMv6LgQhfb4UjBqjKxz04d/c
RWCjhZcjCoiH8ixlNG2hVTZyx52YnpH56kXO0Ztu16L0mbQsukSFS9azzbYcvnKz
sCwheUdypJQnC03GuSQkTT68bjW4Wq49IGuBN4RXzky49ZCAmLExN/AjG/ygEAc2
PuqHUVGYfA1vJChVbnWS72JsXiOXYMxmTXBEIsEB7r6nDR+UYPv+DoLeqGL5DbJe
QZa9WW3XbJQt4tb4Yy8tMkbNj5L4tfwStTbjdBkeFXDeoTLuRkIqnR5TQvxSK6L3
6zd3CvCvfcyDcEgGjClczPFv7V7L1hJoNJSLXWFQiN8GlUYghrfbLVER00uiWs+s
T+zL4P44vUQNotfJlxhIVWTtnchaFa+AX7/j8ofevbWb5qNYMWIoYIAptHSzAEAi
C6ac11LgS3A3s0LI8fPPjFKszhxyeQftdSl39AUNd+dsl4g4XFyAeHob9NBxmuwG
AOLTREhWhf8uiuP1aCbhT4NB34g8axf+QNaBi4Wp1qVy6/9tG9/Jz3VnKJ0b3fuu
nZC/SzSaCS7XroZpLwRy
=Fsf9
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
