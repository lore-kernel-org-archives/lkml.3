Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbaBDTzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:55:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35487 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbaBDTy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:54:56 -0500
Date: Tue, 4 Feb 2014 19:54:47 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140204195447.GY22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
 <8e4231b7a55802f58a14dd07ac5cd8b0babb1dce.1391274628.git.moinejf@free.fr>
 <20140204181213.GO22609@sirena.org.uk>
 <20140204200239.1baf309b@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aV+nM5O4EiZgYTzs"
Content-Disposition: inline
In-Reply-To: <20140204200239.1baf309b@armhf>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/5] ASoC: tda998x: add DT documentation of the
 tda998x CODEC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aV+nM5O4EiZgYTzs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 08:02:39PM +0100, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > On Sat, Feb 01, 2014 at 05:48:49PM +0100, Jean-Francois Moine wrote:

> > > +	- compatible: must be "nxp,tda998x-codec".

> > It's not clear to me why there's a separate compatible here - as far as
> > I can see this can only appear as part of one of these devices and
> > there's no addressing or other information that'd account for chip
> > variation so I'd not expect to need to bind this independently of the
> > parent.

> If there is no 'compatible', the CODEC module is not loaded, and, when
> the module is in the core, no CODEC device can be created from the DT.

You're confusing implementation details with device tree specification
here.  We can easily handle loading a subdriver without having to put
anything in the device tree, just create a platform device like we do
with MFDs.

--aV+nM5O4EiZgYTzs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8UWEAAoJELSic+t+oim9mBoP/iOWL3+ui3vOiZmu1ytj1RLR
frT3ePQ+8wF2mTaDx23u8i8ijG6ZlgAslVFwZb1/jKu/2H4paCF9YGVqv0ilRGLw
PtbEgXScTxC+M1DJyIf4b4F5h0d7PBXaBVMTRx2Hs1Mz/7/Z9TwbLslXT/txGX/G
RfAqppgYkg6aj/DQeShW1GjzW13nG+lV5j6ShjJJ/2qkpdT536/berUmOahdgvlV
CzbsyPYoyY07vkptX+UJDuBc495cSrdKJlNDY9CheIV+X+V8Y6sL7bn0Zv8aERXw
GxrfF7PDiSwvCk29zFqIVTXyDktl6UuPuuG+oYm3wT8ZFY3c3hZnIT40rHOapMH7
apjvfwK2N2d10YUsWKPlLf2ouMX/xcgxCnHwV6X30Y6SN3QrT9sfEEFoTE2Z+s9p
Zdzv5ZfP9OwezpzdiSz4kJ4dRPbk//9QKwXmymb8MIguD0xHphbKk/u27CIEzHkb
fhuOigpW2YGQ0I8kfxdD+V6WkwqksTi6c2Y2LxdVMac2DidieBJIMeDUMf84+mYp
3OJfk1637Cmy99SD0NgS58lo7Fc83K9KJyoRzRSS381mjJvjdQcUEuHuKPz0hq8t
TP/lPCHExlk55ps/pzQktTZcrJa8YRsd682RX6SUdnlf5m+WfhibDFu53J3dQLnj
ZU3j8MOYw8Lh46UyIQbO
=vhoH
-----END PGP SIGNATURE-----

--aV+nM5O4EiZgYTzs--
