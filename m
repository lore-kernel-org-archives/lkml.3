Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaL2QGm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 11:06:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54321 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaL2QGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 11:06:38 -0500
Date: Mon, 29 Dec 2014 16:06:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Martin Oldfield <m@mjoldfield.com>, linux-kernel@vger.kernel.org
Message-ID: <20141229160615.GR17800@sirena.org.uk>
References: <1419842016-208334-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eL0RuSC1De0179CY"
Content-Disposition: inline
In-Reply-To: <1419842016-208334-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND] spi/pxa2xx: Clear cur_chip pointer before
 starting next message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eL0RuSC1De0179CY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 29, 2014 at 10:33:36AM +0200, Mika Westerberg wrote:
> Once the current message is finished, the driver notifies SPI core about
> this by calling spi_finalize_current_message(). This function queues next
> message to be transferred. If there are more messages in the queue, it is
> possible that the driver is asked to transfer the next message at this
> point.

Applied, thanks.

--eL0RuSC1De0179CY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoXv2AAoJECTWi3JdVIfQp78H/R1yP9VN//Cy6KRqxEHnESgE
b/pTDVvICyoQmW+yniiGmDSUhHlEI3KQLYHz/FV72Q6EU2hQKzll2qMwPsXVlgZi
+zM27DZpssHP/oKipvqfk+i+qVbJbpWE0R1PbSB2TZXxCUxez9pHp6EiW8BSm+nu
2W50gUWSCvWICWlPqemUeuNlYF/g19C7MI7ozUHSQUCgHLcDCv7k5S5Px5VI6VAL
YisgAICkztk87GMgkU+dUVkeqAQVNJ86AgTl15Fnbam0hDHX53vLJzU3xzCRSDR3
9OgpqO7KLeEXyDyqCIIb67D7afPBpos25QoRx9GTotRl4I7XHYzm8VwWqH1hlOw=
=PiFc
-----END PGP SIGNATURE-----

--eL0RuSC1De0179CY--
