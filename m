Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299AbaGYQQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:16:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54784 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890AbaGYQQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:16:18 -0400
Date: Fri, 25 Jul 2014 17:15:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com
Message-ID: <20140725161555.GR17528@sirena.org.uk>
References: <1406299116-28492-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2W4Na7kn/Mq3HLmY"
Content-Disposition: inline
In-Reply-To: <1406299116-28492-1-git-send-email-acourbot@nvidia.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] gpio: add flags argument to gpiod_get*() functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2W4Na7kn/Mq3HLmY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 25, 2014 at 11:38:36PM +0900, Alexandre Courbot wrote:
> The huge majority of GPIOs have their direction and initial value set
> right after being obtained by one of the gpiod_get() functions. The
> integer GPIO API had gpio_request_one() that took a convenience flags
> parameter allowing to specify an direction and value applied to the
> returned GPIO. This feature greatly simplifies client code and ensures
> errors are always handled properly.

Reviewed-by: Mark Brown <broonie@linaro.org>

--2W4Na7kn/Mq3HLmY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT0oK3AAoJELSic+t+oim9T3sP/0TTyYze2HZRnEVxVXYLy3yT
kqlSflYqKJcZyx+dW0e51FLvSiOwgPQ+cYfwT/ODBEI/v4mr05gTux33ieOydBhe
uiEGAn0x9cHPShpxHFfwd/CIqaB/od/uS71pzRJgoLIXlkJYVqNBvZDtV9TqLgrZ
vICGaVlQgzziJpZDwoMSRe+w6KhGqOFs743l8u5PVpWIQSdA28hrZuVGDUHcOR4X
D5XQkslBeJximuS/hzMEuySda6WR3pZKVHuqQf0zRpcG/luvgvPWKDnQ2isrFcrz
ahvTKCkR3P7BC4RSn/MvQKAAaXhVxSUJnzcfHPzis4rdeAGyK7JdXjHLCZoce+lx
FB7ZjM93xfMjrzv8MKz9uWjarJ6MaHLJe9m5uuyQsRWLWwH6koWI5f1WGu1kgeEF
gL+zgj6G9WI4+87qzLmrcCglwiPqAdpsCuScCEP+0xpUhHRVSS6gKGAfIoW21XYc
f58K+VXF1ndtNCiRo/DbC85H8J5jZ4E2v3twAH6myvS1CGAyIBZXaxDiDtNncvSq
Vb16yc2yQ02e52VqJj9czS5hDw+5BEch445Ls3TG9w9RnwWfAITrGC1XpAm0MeCb
7HANzsVJ2VktioF4Ca3y3sSyNjh7iQ2jI3NpiZvU6VZLkt74ic4r4hGoQ/0OgqFZ
WcTR8Ib08sgOfqI4wibJ
=naC0
-----END PGP SIGNATURE-----

--2W4Na7kn/Mq3HLmY--
