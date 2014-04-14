Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbaDNUBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:01:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32892 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaDNUBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:01:42 -0400
Date: Mon, 14 Apr 2014 21:01:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Harini Katakam <harinik@xilinx.com>
Cc: grant.likely@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, michals@xilinx.com
Message-ID: <20140414200121.GS25182@sirena.org.uk>
References: <1397466414-18368-1-git-send-email-harinik@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XCAZszJJXrQJLz3d"
Content-Disposition: inline
In-Reply-To: <1397466414-18368-1-git-send-email-harinik@xilinx.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/2] SPI: Add driver for Cadence SPI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XCAZszJJXrQJLz3d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 14, 2014 at 02:36:53PM +0530, Harini Katakam wrote:
> Add driver for Cadence SPI controller. This is used in Xilinx Zynq.

Applied both, thanks.  Please use subject lines consistent with the
style for the subsystem.

--XCAZszJJXrQJLz3d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTD6NAAoJELSic+t+oim93MwP/js3vU/5K363UHhqiHdUKx0e
NsKBmg8+jGzOGO7yTHkHI1ZHuciE8rrjK/opm32RzhJHDyGtH+7uqI9CWq4nm03E
zmJnVxhXCm2aVheioTB0t93KGXCvTxAOwsOtyXncZlWpFxNlxeuo+HS5U8TbHqJ5
J7qBxSVLqT5QZiOwmidUxbEwyvrNQ5Uti+iYjddR8KMfQw9/44pal2I6O1zsIMCs
wjQRgn5MEZ0ssuP0kDU1QHVMzp2tOLJMjnQDz8LOUUHHGhtOj/nZYgsTFBN+lQ6F
Uc7+LB6A4Tr6nGtp0STdesWrS7f22Ps8YEOg+aVRBdMQllisHwiyISPz4w0785JR
QBSl0BO8dVfKU+lSHUp7l66L3SESOEwaB/4QRRR3tSvWFOFc3h6jUC1IuOeEVFnw
nJTsSZYjMzNwSv/E9eV5uu9KRaJfRnz1r9rAHAc0fXgFGZ/zv0SRmY0S/unJrT9z
NxnK1UNQaIhOrnhm4jGx5/fWEPKm8UF/aH72dJvdl7u/up6npA0hmgxyK+GD6rgG
viqE3yO8DN/XZhfhETeMCeAVUWUylBDKfmlG1BRd+Vw5rK/KlBR1q+JDWKWmKC2k
4Iu8tt3HoSxrCQlGe3SIhnqLHPl83RkIfBSdm8Y/KV9ow+cGXGOxqtBMmqmKuZVd
4oO/hL7EYPrduJ8NSO6i
=Pabl
-----END PGP SIGNATURE-----

--XCAZszJJXrQJLz3d--
