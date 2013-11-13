Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab3KMO5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:57:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59746 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792Ab3KMO5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:57:32 -0500
Date: Wed, 13 Nov 2013 14:57:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Gerlando Falauto <gerlando.falauto@keymile.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Message-ID: <20131113145702.GR878@sirena.org.uk>
References: <1384329748-2897-1-git-send-email-gerlando.falauto@keymile.com>
 <20131113133320.GL878@sirena.org.uk>
 <52838D9C.80500@keymile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bi+HF1AHjw0mn3zx"
Content-Disposition: inline
In-Reply-To: <52838D9C.80500@keymile.com>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.183.27
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: spi-gpio: Add check for cs-gpios dt property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bi+HF1AHjw0mn3zx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 13, 2013 at 03:33:00PM +0100, Gerlando Falauto wrote:

> How about an empty

> 	cs-gpios;

> property? To explicitly state we haven't just forgotten it -- we
> just know we don't have one instead. (There are plenty of empty
> "ranges;" properties in ARM DTSes -- I don't know if the use case is
> the same though).

That seems reasonable.

--Bi+HF1AHjw0mn3zx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSg5M7AAoJELSic+t+oim9SEsP/0kOlz5PZM6Pkw9BwrXm2rAR
96QoXTbNI1Ro7Hw4b3kWIfvbkN5IVOAxm88kNgUgp6r/Cmm39N00pFVXJ1cjZx8g
RviOSML3XBNnebLRxI/cVUMqLaYVqUHsal7t2eoBpexB1VYOWg9KS1AWIOsbGqrP
SpiByYTxbw4vpd7rp41rkZEKg/r2NsbPk3cZbcH99KHwLaZsBxTvHaqMxU4rD2tO
OAm6YAHWHl65YFJG2rs+J/GauP4G+IDPANqtpf88SriGcfrpacW5nsgYXy5vMnWH
rSRo74REijacOcG9Eto7QZIilFo2yGicc7UVPkCrAQAPClsTLn079iJ6qyZzbUXO
D1illhIylMc5Y4bP2fqIXD3FTF/ZKRG/JxQYJSP/suqRYPwh5878IwrtnmSdz47d
eR5MtxEltqVJYFdeyc2CBjmHEdNEOSvILV2lqyzA8iHhe6aaOvlQvBHCqXHPYmWC
1jKgP3NtZdU5/qlAySe6qO7GVTDRUEY2KquJbQ74LwM/vTqm1PuxxV90X6stpj31
OHfG8Q40suAqXTXju1Ekr4iM2WgLdo9KXC8MUVdRtejuK19k59p6nF79cN+SvOlw
w6PCI/F6I+AkfTOkmmZj9f0i/xmm2yTuIzBFSC2TqpUAm1qFaWnPqkoGYbqNJHfB
CNhn1V1XnvQr1d/WjVlX
=wYCk
-----END PGP SIGNATURE-----

--Bi+HF1AHjw0mn3zx--
