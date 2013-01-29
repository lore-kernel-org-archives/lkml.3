Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab3A2Dp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:45:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47094 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166Ab3A2DpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:45:25 -0500
Date: Tue, 29 Jan 2013 11:45:12 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: andrey.smirnov@convergeddevices.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] regmap: Add "no-bus" option for regmap API
Message-ID: <20130129034508.GC6878@opensource.wolfsonmicro.com>
References: <1359312545-4159-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DSayHWYpDlRfCAAQ"
Content-Disposition: inline
In-Reply-To: <1359312545-4159-1-git-send-email-andrew.smirnov@gmail.com>
X-Cookie: Make a wish, it might come true.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DSayHWYpDlRfCAAQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 27, 2013 at 10:49:05AM -0800, Andrey Smirnov wrote:
> This commit adds provision for "no-bus" usage of the regmap API. In
> this configuration user can provide API with two callbacks 'reg_read'
> and 'reg_write' which are to be called when reads and writes to one of
> device's registers is performed. This is useful for devices that
> expose registers but whose register access sequence does not fit the 'bus'
> abstraction.

Great, thanks for doing this work - I've applied this now.

--DSayHWYpDlRfCAAQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRB0W+AAoJELSic+t+oim9p6YP+waob/N085kDBCyGuYeINn0R
dYhiyHE+cruWQWoClLxzG4+r3FVm/EUYO3A0e2OEb4SW5x/t5Mko3poyrl7Xd8MV
uvZ1LByfpFsFkbkNA6N51FgeWrtYl9PSRKC3PfCUYyN1fDmyLlWVwOUkbmrEJtwv
l488gIVNFd6pWmBROnUPl8x32w7bPE7aIWZq9im4mfvYdOurHKg1dghOj7ikn6+6
VhgTfVXJYK/I1cuNCbwXq4aEWzseVPKN3mOEuweWzw90ewr6PkwHlPY+a8TUz6KN
fdN3STSjZiMztMnyFFEAn+rMC8jrKnFFrPMZHM3BOL/uImISV5/ZtSaK3KdpBjQG
K3NaklzO/1W/CXXP3Xh0kV1G1bUnjNl6jgmStf77P5lu1zU/PIMNoqC/Fu/RZ7tV
Co2PM73h39NpiEi1b/SfQ5LyVG2o1Vtnpu8WMt271432wXFQUJU0AOYUGn80B4yi
Tmt/rklFBceYTQdgzeN96P99lU/pv4eva4r7OLRD8hj3BKuy+85O/gSyNqIoBdEE
hXH8rj1h6EVjZd2Slb8DgZ+qOE6Ks+VAjGPZRxz0PlX/kSauZxuNt/Ow+qrSLjm8
2APV0Afbp4K8rsrS2Yb1XA5UWKk7CAAYjRH4OOc6lqj8NJ/IRJ1L25V/FCy0Zony
b6+q19GBrtiD37vWUDua
=/8Po
-----END PGP SIGNATURE-----

--DSayHWYpDlRfCAAQ--
