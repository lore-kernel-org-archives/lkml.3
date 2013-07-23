Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934185Ab3GWTjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:39:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54831 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599Ab3GWTjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:39:04 -0400
Date: Tue, 23 Jul 2013 20:39:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130723193901.GR9858@sirena.org.uk>
References: <1374506153-10092-1-git-send-email-p.zabel@pengutronix.de>
 <1374506153-10092-2-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UJa/EwID5cajRbIm"
Content-Disposition: inline
In-Reply-To: <1374506153-10092-2-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regmap: irq: document mask/wake_invert, make them
 bool for consistency
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UJa/EwID5cajRbIm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 22, 2013 at 05:15:53PM +0200, Philipp Zabel wrote:

> -	unsigned int mask_invert;
> -	unsigned int wake_invert;
> +	bool mask_invert;
> +	bool wake_invert;

Actually we should probably make these bitfields and convert the other
booleans to bitfields, sadly the C bool type is equivalent to an int not
a bitfield so is more wasteful.

You shouldn't have mixed this in with the documentation fix...

--UJa/EwID5cajRbIm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7tvSAAoJELSic+t+oim9xwEP/32UPE8fJeaQShkbtSR9fc0m
H6ubr9BQPrY9oVFPNoJGHS03XFB2MWDPq7bm/xFOBDk0WZrUmCjcvk3EIYstim14
NMcbo70rMi/I6L6GVlZ1E7O4UK08B8jTSNH/tEEHOW8bHryW94rpwj+cyV/8D5zK
MNAoTxrorH6fA4HPGqAZxJ+aVoiJ+8mLlZq0X5cyJ7PQYBliBFyBlM2sQCt9fEN4
0PY5F5xDuq67gfnGnlzX5koWtJ2+1qsn2+chLMxSdb0rcDSaUqiyWkgf4JsBMWJw
9FAybaz0xJ4fWOCGqmKuXcXEnSKyjDuKinhaBsUWGC2rLY/A6GKL6fUavywhFWMk
o7Gd81NHtAQurKf/ssPtrpxQYSZbSccDJb1oItERnJuQdjS1vbVJYZF3bwXfB3JS
e/auNNphFTdkWQBns4JLubdTUhGAdtY1nV69ZJE9xD9ud6/UKf1q/bz8Ut2rNHGe
rDmpoC+avt9Yp+JBnIFd7vyohjTpjssjl5V2YaQxlx8SpIRXPILoeOai3W0VUh/o
QkomM/flJRQ2zqrOVMnPtG0fCBfhDpOWBiOU5l8ylOLEbURJ+cNp9rospRI2MN6J
w3mngMBgfheBPY0UiBt9kCweCBe8KZGLKNcJG3cZDzjjgFgE5bbSOaGoyTyRbZqK
p2dC71IlMa4uQGx8iRPL
=PoNZ
-----END PGP SIGNATURE-----

--UJa/EwID5cajRbIm--
