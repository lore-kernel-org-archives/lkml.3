Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaE0PGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 11:06:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44457 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaE0PGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 11:06:46 -0400
Date: Tue, 27 May 2014 16:06:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, arnd@arndb.de, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140527150629.GV12304@sirena.org.uk>
References: <1401192010-5443-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r7EjqmaqAzgmdU35"
Content-Disposition: inline
In-Reply-To: <1401192010-5443-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND] regulator: arizona-ldo1: add missing #include
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r7EjqmaqAzgmdU35
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 01:00:10PM +0100, Charles Keepax wrote:

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> Cc: Mark Brown <broonie@linaro.org>

> I think this patch got missed when Arnd Bergmann sent it in,
> I hope no one minds me resending it to make sure it gets
> applied.

I can't apply this since you haven't signed it off.  Arnd, let me once
again remind you to send patches to maintainers.

--r7EjqmaqAzgmdU35
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThKnyAAoJELSic+t+oim960IP/32yX0h2NXQgxwVO9CzecTEe
OPR+JsNDh5NB/gQGBkiLsWnCr2KjD7KcJc9cTDGe96WuvwBtpVVXbM7RSbHCHXgj
jlIorkNocX6bhDURI+3OxohzrrcwSg3ioWeX5+xxNN3Jxqquhu+B+XQYClccKU05
D4yFa3UHQgpfxwWRlwAFNqLAFYIKEDRvWGu1DaKo0ddnXApfj7p7Tuizl/TO8xvx
nsuS1GtCuKDTRA007yjeLl7QFFOCPM+/cPCj4gq+NvbL71Mx8DYRgE+TxB3SVhwD
w+RtQsTIvccCK8tJx6XUcpXwEFOnuE9QLpjsN0k7OG8b2lRuteU9wbw+n0wX9vdd
B7ySX02sKnLT7C6SqQD3n7mBgfONUO1533YqjrxqdhGj6eJbO/fn3Mk6YgYEUvcl
BJPCCsejcVt7MYAZQjBOGxsVOh0I5wbfTSlWTYdZ1xrKItFRr626L3i6D4rCe1my
o8V/ek4kKN2JRunC+SVMxA83vEyiU3a0H7fhKDZ7E2GeCFqSWcqHrXTYewBEjTTq
qv5YT9WnJAKkLN7Ul7Xxs0LwALbAnqVN51RKdDs7e8giuvHZEaNnJvjihIv9rKdF
/6d1GUqUw5utzcYzYkQLLRcmR+zQd7mnQa4gtv4qCkZFbDmgkSuxO0aW8BXIKO1x
OpUwDtZ7QI0W9ttliHdL
=v4aX
-----END PGP SIGNATURE-----

--r7EjqmaqAzgmdU35--
