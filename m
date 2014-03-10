Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaCJKYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:24:54 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55897 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaCJKYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:24:52 -0400
Date: Mon, 10 Mar 2014 10:24:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310102446.GS28112@sirena.org.uk>
References: <1394444812-16086-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YAtIlCcyqLEoH4m3"
Content-Disposition: inline
In-Reply-To: <1394444812-16086-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max1586: Don't allocate memory for
 regulator_dev pointers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YAtIlCcyqLEoH4m3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 10:46:52AM +0100, Krzysztof Kozlowski wrote:
> Do not allocate memory for 'struct regulator_dev *' since it was removed
> from state container (values returned by devm_regulator_register() are
> not used outside of probe).

Applied, thanks.

--YAtIlCcyqLEoH4m3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHZLqAAoJELSic+t+oim9eFIP/34R7P2dQwMQ8VZVwUxxC42t
SNiaEsbH3eTXtDJ43NO+p/BTXetzedk1Vuh9b3drihFwEgA+INyEQTn/z0yaPVAS
VhS22yvcU6QZg5110HyvdZjWkMvqwJKAaDKPv07iyDkKFijUaFOuSu4Km7eHIk+x
MeSM6xHscN1jVPJ6bfw2sBPa6QYiv6+uI+17ExFb4LaO5SsyLCQoEcU4ZmkiR1LG
D7XI3oJpDD48yfSmKWGEkuV5vdbwqq+EXB7RrZxZeRhKFs3UFKJ3a9Am5MvvnnEd
R8ZFv/Y25wO02sJyLrJ82zz2MFADhAdkKwQzJNIMDjg5xjF4uJLlXUxUxcAQw5yC
8PzSvP0ej8gVSjFgTy5jO/Ax2rg+R8YWJZSLKdfrAQmYojjhX/4yGupDivMiNbjE
qM8Ruuc9dcZnKq0abR65W0QRT9WZ1WRzggtQzFJdLHHMyzQYQfE44O9r8C/Gx+zm
T+EWRRts/w6x8uRXaBOTGYUjtFrWMldt5aC3KvJPDUBs+sz8WsvaBpWB6KE4nnXI
cqz1wWfYa/vvp7LK2Bt8gS+LGbovdLgWVcb1WV9Cx284IrcsEBrRD1ZjCuZZjjPI
bf1PboE30z/4zr5WZKPMM1iKAULiwIXHadd3wTBjxPUXP759I+5QSYa+EWLInWB6
x00A7FHsGmSSrHFqmsf3
=JMrh
-----END PGP SIGNATURE-----

--YAtIlCcyqLEoH4m3--
