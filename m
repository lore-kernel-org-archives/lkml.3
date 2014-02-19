Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbaBSPLH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:11:07 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49021 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaBSPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:11:05 -0500
Date: Thu, 20 Feb 2014 00:10:40 +0900
From: Mark Brown <broonie@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Russell King <linux@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Message-ID: <20140219151040.GH2669@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
 <1391529538-21685-7-git-send-email-ulf.hansson@linaro.org>
 <CAPDyKFombL2-Rt46QpXPNWe5PeGQnOGmQQNfYd5MdYdEePn-4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4FPEP2OQoJToMU+c"
Content-Disposition: inline
In-Reply-To: <CAPDyKFombL2-Rt46QpXPNWe5PeGQnOGmQQNfYd5MdYdEePn-4w@mail.gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/17] spi: pl022: Let runtime PM callbacks be available
 for CONFIG_PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4FPEP2OQoJToMU+c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 19, 2014 at 03:20:07PM +0100, Ulf Hansson wrote:

> Also note that, Russell has already applied the corresponding part in
> the amba bus (patch 1)

Why would this depend on an AMBA patch and if it does surely the two
need to be merged together somehow?

--4FPEP2OQoJToMU+c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBMltAAoJELSic+t+oim99zkP/j/xXWSCyg6KeVYXGT17LNZl
Ahj9b7lhCX9OQ+Ck3pUTLZPIcna7v/6nTjYRh1cW/nPj6vyjqmidlATEQqy6Lz+n
TmfxUIPy9pVFYfHF+nJTZa2LJa57COlwShCOwTqiws3H+zaX8+VBNRC72ockUoH/
6t58ir29hbingGybeKL9K/cM3Gq4juAQ9BsJhGuUrntNRSdQfeNpYJZc6igmz6TD
rw/uQ0uaHDleSs+LlRf87VqxfRYYXFEIAKunHctLV61PQoKcWxGMgOIKwBcA+gVh
MBji3dJS2zT5OhokKd51y+e8E2a9mFeohudxHBHFSk4lAXLGTRMf5GcnlsySuHud
8RkyH2B/fwVdmVjF7x4qlhPfQs5MvDhghPXpTYyB4kOurtJ01qrXW7lj6Nos6Yfn
4LZqjwoQRmyjdWXVFjXq5bc2CHzM096PYuqsR5m85aYHKwyMCWFbHx/MEgsfeKcr
jLD3RYaxMVHCUhy7wzSi+FONpawa0YW7WXPsdIWiwW/ei7jzZNJENNVtAX5QBT1g
WLOShXyX6npWKTgvR4ektWEAWlMFiZeYJIq7s9Kwz+v8bhXVTcTTAQhKZKl5U8gi
3DUvUZR6ml/l4dB82NU6j3zN0kiKwJJM9cza0tu+5EBP//J8h6y+KlVAdBYOYfSi
ULKfGg33W/QJxcFMkVpt
=Cboj
-----END PGP SIGNATURE-----

--4FPEP2OQoJToMU+c--
