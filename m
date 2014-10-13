Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249AbaJMOth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 10:49:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51168 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbaJMOtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 10:49:35 -0400
Date: Mon, 13 Oct 2014 16:49:24 +0200
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Message-ID: <20141013144924.GL27755@sirena.org.uk>
References: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
 <1412776028-15655-2-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HD0kALpPMdLSLfnf"
Content-Disposition: inline
In-Reply-To: <1412776028-15655-2-git-send-email-mpa@pengutronix.de>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/4] regulator: Add ena_gpio_initialized to
 regulator_config
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HD0kALpPMdLSLfnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 03:47:05PM +0200, Markus Pargmann wrote:
> Most drivers do not set the ena_gpio field of struct regulator_config
> before passing it to the regulator core. This is fine as long as the
> gpio identifier that is passed is a positive integer. But the gpio
> identifier 0 is also valid. So we are not able to decide wether we got a
> real gpio identifier or not based on a 0 in ena_gpio.

Applied, thanks.

--HD0kALpPMdLSLfnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO+ZzAAoJECTWi3JdVIfQQp8H/2DSMcrfN4n2iH1RYNceMrgM
4F3X21Iq0sKtwRBZwPdCgkXF3wzXXA3evdf8vJr0ymTmt23MM9cArHcQLHHVx1UV
uIk0lBp+XHss2UPaD5nFqj+mcDqZveO88RzC1nxXBZxp0Jf5MFEHE9IJCjEqs/Wp
jPSQiNBdcUkvaI3JSSZGjCa+Ls9GrWCjO/hDPbbBEWJ27Ytwbw8+MJfuGzPWgiGp
vmTX1eHFfFvqNSG0Q3zewAXOlQl/CFDPXNu/cYrP31iidH5/6RYLVoF53LQN3GXE
KfPEl26S6pTBSHGG4UnGcN5EjUZDr9FidfyhZyVHW1PD4Xh8Y65i8yd743nI2Xw=
=LXdl
-----END PGP SIGNATURE-----

--HD0kALpPMdLSLfnf--
