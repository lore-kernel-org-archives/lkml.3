Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3AXLNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:13:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49192 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab3AXLNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:13:39 -0500
Date: Thu, 24 Jan 2013 12:13:29 +0100
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
Message-ID: <20130124111329.GC12933@pengutronix.de>
References: <1355464254-12768-1-git-send-email-ch.naveen@samsung.com>
 <1355464254-12768-2-git-send-email-ch.naveen@samsung.com>
 <50CB4E99.9060506@wwwdotorg.org>
 <20121215142135.GB22033@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zdv2QT/q3FMhpsV"
Content-Disposition: inline
In-Reply-To: <20121215142135.GB22033@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6zdv2QT/q3FMhpsV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Dec 15, 2012 at 11:21:36PM +0900, Mark Brown wrote:
> On Fri, Dec 14, 2012 at 09:06:49AM -0700, Stephen Warren wrote:
> > On 12/13/2012 10:50 PM, Naveen Krishna Chatradhi wrote:
>=20
> > > +The first should be an output, and is used to claim the I2C bus,
> > > +the second should be an input, and signals that the other side (Clie=
nt)
> > > +wants to claim the bus. This allows two masters to share the same I2=
C bus.
>=20
> > I'm confused why this is even needed; the I2C protocol itself defines
> > how multi-master is supposed to work, just using the regular SCL/SDA li=
nes.
>=20
> Practically speaking essentially no systems actually do that - mostly
> Linux will treat failure to get the bus as an error for example.

It is true that Linux currently does not have proper multi-master
support. It is worth a look what is missing and how far we can get with
the I2C specified arbitration IMO.

> also get things like read operations which appear as multiple
> transactions on the I2C bus so require something higher level than what
> multi-master provides.

I don't get what you mean here. Can you elaborate?

That being said. Grant's design was the most promising one.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--6zdv2QT/q3FMhpsV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEBF1kACgkQD27XaX1/VRullQCePgYzSfFOMBAK94oXjHZnLFtt
TYIAoMQogd0XfDbXQpVnMGySY0AW5KEI
=Zzsm
-----END PGP SIGNATURE-----

--6zdv2QT/q3FMhpsV--
