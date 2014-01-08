Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704AbaAHMum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 07:50:42 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48694 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008AbaAHMuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:50:39 -0500
Date: Wed, 8 Jan 2014 12:50:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: shawn.guo@linaro.org, anson.huang@freescale.com,
        linux-kernel@vger.kernel.org, festevam@gmail.com
Message-ID: <20140108125032.GB31886@sirena.org.uk>
References: <1389011348-3145-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PYBl0+y1hUeJ0kGI"
Content-Disposition: inline
In-Reply-To: <1389011348-3145-1-git-send-email-fabio.estevam@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] regulator: anatop-regulator: Remove unneeded memset()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PYBl0+y1hUeJ0kGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2014 at 10:29:08AM -0200, Fabio Estevam wrote:
> sreg is allocated via devm_kzalloc(), so there is no need to explicitly zero out
> rdesc via memset().

Applied, thanks.

--PYBl0+y1hUeJ0kGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzUmVAAoJELSic+t+oim9V+oP/j+7BIF6n9Q2bzjAY6YegZAm
m519uthcRxwHJ+T8TrUGV0mY4RYIQz2tkGaeGP40s+BNImHGmoW/kHSG/7xdTFB1
BRrmCE+9QWiyusuhNd+MMhkL349kpx8JOb+kbo4wRIfFehfOzVrP/yIfO2eQQXDZ
MFvPqGN7H2/Gsb0X4rPXVR1sJg3OFAdZuZQfrAySW6KFJyFJfhROitdcD9YLpk9o
JwyW9eZXHF4Xu+vUxuZ+aBG4HvntSY3T2T7k6hzcYnvRKmVpCBLgdw/LGI3J7kHj
gblbLmTm7kRAYoOhAcU5EYY1QdjaKS1+/IEqYUVuWuE0oG9g6uJCYcz03M47xxKu
2ZYt2+75DgQbrFFWTKsBt26nYT4geEzYhRXqlCQ27c7lxqU3R9UFMKSweI7DNp7A
pmRB5yHfU41l4TFqeEFnsjaD1FnVMWwSKdBNlaMoFcVvRTtgVKoRvLrbq7Sc7Pnf
QCq/sLHzkVPUQVapMYXBjVNLsyWWrsjz6mU9uYl/xRv3sWkh0RX+NTH0sNXS1ddx
6pdIxJbKc1IuC2it5WHCZaF1+7AqN4tI5Rmaz/7HvUdM8MzwgJo6U4HGwf6X0WpK
ap9KLG1SM8Mw2F4GYJcTjA51R1oZ5v2S7GPSvutyClaW4DMv/e7CQErg4GpY+FU5
b/T4ihnxp0wBLDvLltzn
=8ZeD
-----END PGP SIGNATURE-----

--PYBl0+y1hUeJ0kGI--
