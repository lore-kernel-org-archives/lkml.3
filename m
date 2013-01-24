Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab3AXLkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:40:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44335 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3AXLkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:40:00 -0500
Date: Thu, 24 Jan 2013 12:39:48 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, grundler@chromium.org,
        devicetree-discuss@lists.ozlabs.org, ben-linux@fluff.org,
        khali@linux-fr.org, naveen@chromium.org
Subject: Re: [PATCH 1/2] i2c-core: Add gpio based bus arbitration
 implementation
Message-ID: <20130124113948.GD12933@pengutronix.de>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
 <1355464254-12768-2-git-send-email-ch.naveen@samsung.com>
 <50CB4E99.9060506@wwwdotorg.org>
 <20121215142135.GB22033@opensource.wolfsonmicro.com>
 <20130124111329.GC12933@pengutronix.de>
 <20130124111845.GO4955@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <20130124111845.GO4955@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 24, 2013 at 07:18:47PM +0800, Mark Brown wrote:
> On Thu, Jan 24, 2013 at 12:13:29PM +0100, Wolfram Sang wrote:
> > On Sat, Dec 15, 2012 at 11:21:36PM +0900, Mark Brown wrote:
>=20
> > > also get things like read operations which appear as multiple
> > > transactions on the I2C bus so require something higher level than wh=
at
> > > multi-master provides.
>=20
> > I don't get what you mean here. Can you elaborate?
>=20
> A read is typically implemented as a write of the register address
> followed by a read of the value, usually with the ability to free the
> bus in between.  If two devices attempt to access the register map
> simultaneously this results in the address going wrong.

Could happen. But in what situations will one not use repeated start
here? Especially when designing a multi-master bus?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEBHYQACgkQD27XaX1/VRsAdQCdHPM40PqJBYznKnHAljriBDlU
XOsAnAkqEGcQ6Y34Ge9EqF0qt6/HfHEQ
=pzuW
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
