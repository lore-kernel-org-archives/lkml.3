Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaIFMyf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 08:54:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53256 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaIFMyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 08:54:32 -0400
Date: Sat, 6 Sep 2014 13:54:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: linaro-kernel@lists.linaro.org, Geoff Levand <geoff@infradead.org>,
        linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140906125412.GA32429@sirena.org.uk>
References: <1406748194-21094-1-git-send-email-broonie@kernel.org>
 <20140817170453.GE12769@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20140817170453.GE12769@titan.lakedaemon.net>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] irq: gic-v3: Tag all low level accessors __maybey_unused
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 17, 2014 at 01:04:53PM -0400, Jason Cooper wrote:
> On Wed, Jul 30, 2014 at 08:23:14PM +0100, Mark Brown wrote:
> > From: Mark Brown <broonie@linaro.org>

> > This is only really needed for gic_write_sgi1r in the !SMP case since it
> > is only referenced in the SMP initialisation code but it seems better to
> > have these functions all next to each other and declared consistently.

> > Signed-off-by: Mark Brown <broonie@linaro.org>
> > ---
> >  drivers/irqchip/irq-gic-v3.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)

> Applied to irqchip/urgent

This appears to have disappeared from -next and the warning is back.

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUCwPxAAoJECTWi3JdVIfQrmwH/ihvFx1AcFhW4tCX8TRFrIPW
ToHQ300JMOWOHo025F5+dGvIwKM4JZyaC2++NWUpwQnKFzlHcjZMftcbVoQT6JTp
79ew5Eq0bq/qyBWN86iu+x6t8+lO+VhdFnGW/Yye30M/8gREktWDkN8jgIDLtA1Y
uFomLCvQOMpJekCTV1uBq/JCcdGbpDIm/hVVo22/3vI/0ZMx/5uFHAo7eMPQSyto
wY/S7mUGa+gmbK5NaafUVZ4Pc4Qn3OmALfUJt3UPboHTEjFg8bEPjLy24npPLj5h
LwKugOGlOIL/oTqGJEies8u+lPd+u0kNSL3D5yMub6RHPVRl/oZCvBn0KfPzmf8=
=LkL2
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
