Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab3JCMxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 08:53:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51271 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab3JCMxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 08:53:09 -0400
Date: Thu, 3 Oct 2013 13:53:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20131003125302.GM27287@sirena.org.uk>
References: <1380292469-17347-1-git-send-email-lars@metafoo.de>
 <1380292469-17347-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2OzUYMsT4j3Kc+NU"
Content-Disposition: inline
In-Reply-To: <1380292469-17347-2-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] hwmon: (adt7310) Use spi_w8r16be() instead
 spi_w8r16()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2OzUYMsT4j3Kc+NU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2013 at 04:34:28PM +0200, Lars-Peter Clausen wrote:
> Using spi_w8r16be() instead of spi_w8r16() in this driver makes a code a bit
> shorter and cleaner.

Applied, thanks.

--2OzUYMsT4j3Kc+NU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTWirAAoJELSic+t+oim9SZ0QAI0ZHtcvBBLbH3e8y7cijW3L
DipKdZHYLlZcw4c19RS8FcBjorEchoQkXHOqGGFO9IQ61meh0Ne6BuaK2Dxf8+80
QCQCClttGHTp6+471XKnnqwaq2zRYKnaGZzYe5vmhfm4dj2yVeqnre8j9P7smCP6
5MPCdF43zbiQOykB52v0Jgkbu1pCCuN1nmu8DCKxn82w/2PBEijgV3/U1cki/b1o
D7WcabBNmxJfwl8u8U2dJyUVpKAMVyR2xT7qoGIWfRiMw1EAYcnMTsSQZ2cOhI2T
rZi4xDRhngN5gvkCq45hS4tQpTKUbJJK1BFyK9peR2YNXuvm+wCmXMEGcMst9rE3
FOf/iAyu8vspRNs5WAQdStBjGQS55yVWTlEI3YrD6u43RpZWlpp53tBGJ2PB5ZVq
pWBs87qGw5cvhi9CkD1rSPMQA/Rck2M0mrUrZIecW+bIr5LlQEW6hKqrcFKXRt7z
s7PeLBjQkXnqr7f9Rjc98zF227eiEeuQnSE9Czz0kkUi70VZ38+KejfwtbhStR6s
HF/pYzEWfGY1WxGFxxGWQsHoKHnTkXWXR03sNpMevkWUZ5wK3FGnC1s22THWFC44
Hq+t/j0USF7kfzZ1+MxASV95iZZ3nJJ1kuPnJHkFenaEJlLwP3buepLU76IERS0R
UQwS1zNXMBKxx/7+9wz2
=Czjv
-----END PGP SIGNATURE-----

--2OzUYMsT4j3Kc+NU--
