Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109AbaIJLqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 07:46:07 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60887 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaIJLqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 07:46:04 -0400
Date: Wed, 10 Sep 2014 12:45:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, marex@denx.de, shawn.guo@linaro.org,
        Frank.Li@freescale.com
Message-ID: <20140910114530.GD7960@sirena.org.uk>
References: <1410312604-31949-1-git-send-email-b38343@freescale.com>
 <20140910102105.GR2601@sirena.org.uk>
 <20140910112258.GA30794@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Content-Disposition: inline
In-Reply-To: <20140910112258.GA30794@Robin-OptiPlex-780>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.132.226.177
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5] spi: spi-imx: add DMA support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2014 at 07:22:59PM +0800, Robin Gong wrote:
> On Wed, Sep 10, 2014 at 11:21:05AM +0100, Mark Brown wrote:

> > This isn't going to work, anything that looks at the usedma flag will
> > see the result of the last thing that was checked which may or may not
> > be the transfer that it's handling.  The driver should check to see if
> > the core mapped the transfer for DMA.

> Yes, you're right. I should use "transfer->tx_sg->sgl == NULL" or
> "transfer->rx_sg->sgl == NULL" instead of usedma flag in driver, right?

Right.

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEDnZAAoJECTWi3JdVIfQUScH/387Cp1Y8r1kKvVGGJamy69G
GMXCh0iSsSkU0/gCJ9MxRE43cuzxwaknjUupiOTPqlnXYlOwuruljboxe+a+2jfG
UojB7690yUYs1BSNauj3x9N9KEQcOXP5cZ9vYarjqdIW1i+LT8c3wiSQ70rBfHBC
QpHEWYju9gJrYdVLGVTp5V3wpD9CvGSS8I7MnV6WRAdM4dccj4tIbC3Ule3q5yKy
ShNgVfzS+wPMDXAsTcyH+MEMxDj7FZe0WZgZszH/S4zcRxggExbwI9PYhXbM/tC3
rRtSlzgB7YdvCENs4T+TNeCHqj/z8z8dSIn+z9d0tBXOhdWZ6SV6tcUoE4o9IDI=
=RYuO
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
