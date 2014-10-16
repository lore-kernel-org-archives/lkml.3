Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaJPJdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:33:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58165 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbaJPJdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:33:04 -0400
Date: Thu, 16 Oct 2014 11:32:38 +0200
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org
Message-ID: <20141016093237.GA2200@sirena.org.uk>
References: <1413451390-22859-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1413451390-22859-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi/atmel: add support for runtime PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 16, 2014 at 05:23:10PM +0800, Wenyou Yang wrote:
> Drivers should put the device into low power states proactively whenever the
> device is not in use. Thus implement support for runtime PM and use the
> autosuspend feature to make sure that we can still perform well in case we see
> lots of SPI traffic within short period of time.

Applied, thanks.

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUP5CyAAoJECTWi3JdVIfQn80H/2bdx+dbNs7u2tee0XVBQjxy
L+lNkGTti2NG0RD4Qy7doUJisurwxZzwVA0/3kiq53W/q0i3ChSBvTpds9uxPjn1
i+/DFKwM1dPh3bHGwxVlCRPuEucvyR42WX6bVlxXa6MAyb+CY9MHC8fKteSoanP6
sLBhXJdrW7b7vCy6VU3mGQ/D/U/tkTaMjdnqtJBx88vOe20ul+GJc/DvzGtj/5zQ
2Vhs7sWYN4JPRkwxYUyIQo3oySmaIcSJHSDEnbVoTg9rutTZSuvYziocfn748w0n
J2olYSYkUbnN6ER1v6Nao1UQbGGAMg1aeAttoUzDE9DZBlSoUn4WWf+RyB3eClA=
=tLau
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
