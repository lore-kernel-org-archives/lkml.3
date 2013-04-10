Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936542Ab3DJNrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:47:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39623 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936468Ab3DJNrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:47:46 -0400
Date: Wed, 10 Apr 2013 14:47:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Josef Ahmad <josef.ahmad@intel.com>
Cc: Daniel Mack <zonque@gmail.com>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi-gpio: init CS before spi_bitbang_setup()
Message-ID: <20130410134743.GC9243@opensource.wolfsonmicro.com>
References: <1365528334-3444-1-git-send-email-josef.ahmad@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nYjNOXWpwjVqWAsU"
Content-Disposition: inline
In-Reply-To: <1365528334-3444-1-git-send-email-josef.ahmad@intel.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nYjNOXWpwjVqWAsU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 09, 2013 at 06:25:34PM +0100, Josef Ahmad wrote:
> spi_bitbang_setup() deasserts the chip select line to initialise
> the device. The chip select GPIO line is obtained from
> spi_gpio->cs_gpios[] private data.

Applied, thanks.

--nYjNOXWpwjVqWAsU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZW11AAoJELSic+t+oim9p7AP/j3byWcoJ0lyTPEDKKJnu/o8
jCGgyc4Y5rDnndkODQncximzZzbZvqH9zcoFrPsT5YwDTtEA9lZKpauTuFoLVTgS
zSRXhrOWfwfyiuEPf7m4kriYT+0fmG0r5NldYGb9v2qpalR+A3capkp1CvWDZ5vX
Cjt6vPlmOIQLg3+UfU7idJ0T3P1IDi/ykHwWaDfX1f5O+zL6sxJYl4XP63H3oGkr
UMO+DnvFtWcB0r47wL8pZVCYyeP6ddV18hCXcXwLWoXCo/ArrBbl5xjSIX09sb2w
vbEhLYlkhFSZSQldy1tVknOpEBcSNqeKLOOOeBmsnkV9TLNejeAuPEbfTgkFApfn
8JNSIqGW00OCJTLltN08CbuU9EoiT+3dqL8iix1NyuQS+t1VFRgzSOahhQfJcVCM
QHYtwGDW3JZVeQPRYOpW0FRFu+86MqQlM4ATqROltfxaZk3X2EvLJn47b2e3EyWe
nCKEtycUnfPkzwWvVMik2InBZz+EPhu/ozXeFSQdl4qHCMO7V2htetXipIU1DVJL
GHqz0noo6IwRxOIHVG0+lMF6r3Bl2U9Rq8cAflGh1YTAG6jGnhYH6TUFNESFGQv3
LbOw7i+mcmt8YfAGlD7quUmZw7H3K3K72RmgtEi64205gIcUofO/pH1Na6mT8Qoh
NBbUkD7kZpaYM5rIwXS7
=5cGp
-----END PGP SIGNATURE-----

--nYjNOXWpwjVqWAsU--
