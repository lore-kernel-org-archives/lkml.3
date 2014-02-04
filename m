Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325AbaBDTkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:40:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35478 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286AbaBDTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:40:36 -0500
Date: Tue, 4 Feb 2014 19:40:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140204194018.GX22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
 <ae68394f080f0ea5acaf3377cb1d18f29e42c646.1391274628.git.moinejf@free.fr>
 <20140204133014.GA22609@sirena.org.uk>
 <20140204181605.5b837a70@armhf>
 <20140204175410.GL22609@sirena.org.uk>
 <20140204195921.5ace6163@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2UusUvefyJ2PB+/T"
Content-Disposition: inline
In-Reply-To: <20140204195921.5ace6163@armhf>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/5] ASoC: tda998x: add a codec driver for the TDA998x
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2UusUvefyJ2PB+/T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 07:59:21PM +0100, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > You shouldn't be representing this as a separate node in the DT unless
> > there really is a distinct and reusable IP, otherwise you're putting
> > Linux implementation details in there.  Describe the hardware, not the
> > implemementation.

> If there is no 'compatible' node for the tda998x CODEC in the DT, the
> simple-card is not usable, simply because you want the CODEC DAIs to be
> defined by 'phandle + index' instead of by DAI name.

This is a bit circular, though - it's only happening because you decided
to push everything onto a subnode in the DT.  If you just work with the
existing device this is no different to any other device.

> > > I don't understand. The tda CODEC can only be used with the TDA998x I2C
> > > driver. It might have been included in the tda998x source as well.

> > You shouldn't have the default settings there at all, that's not the
> > normal idiom for MFDs.  I'd also not expect to have to build the CODEC
> > driver just because I built the DRM component.

> As the tda998x handles audio in HDMI, it would be a pity if you should
> connect an other cable to your screen.

My screen doesn't have any speakers anyway :P (I'm writing this on a
computer with the monitor connected via HDMI).  Besides, this is more
about build coverage stuff than anything else.

> So, as I understand from your remarks, the CODEC should be included in
> the tda998x driver, and, then, as the simple-card cannot be used, there
> should be a Cubox specific audio card driver for the (kirkwood audio +
> tda998x HDMI + S/PDIF) set. Am I right?

No, it shouldn't be.

--2UusUvefyJ2PB+/T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8UIeAAoJELSic+t+oim9yXwQAI/JnoEa6hspEphr5gxFLTma
ANxAZ+TCxLtgWi+PLksrJcCglMCxrfAVyoAluHC8+Kn1P5FpN7nwpLx69iHk4Jrk
/GB8uI+gI8M5j6JzRtzAfIb4eVaia674NS2jrVysXd731W4LXGYE3UuCWTKYCJi7
EhqkrheOXRAuw7X+LviD+RWGgwNT2bjwa6zDHsCmA6t4CkYu0SEw/Fl2Tpv6WUqj
0+VFcgavLVo5P15hlZ1i0DTZIzFaS9BLaYzvgfoMAUyNWgTYzRB+bedxm6QK07lb
xppcDRn4Zinqx5kpvy22uWrX9HutUehJSf8PNBXen6KcHZBQyyDI70AbMH4LYE4L
YPHHYl5aPwfQ++99kGjNAQtsP47J9PVmmeDFEy5YLGceNhv+5aQUFYEqSXFW24ho
K5Bw5vODymthnPxIu9G3ZRkT9Nc/HqatpI1y0lt5Y7QVlVZCJRsk6pLQ8mQrOie/
h7YVN8NJ+1FcigqTUYw+AXJ0sxy2syH4f+Ngw3+jl+9fBE3wsCae0PQLlbswgm9O
i2vIOYBcYWK1ed/o5J7SZkJudLTiZf6AmTUMCqoWZUDkmIEpLDwVpYHHXRd/jbDp
IvfvjFoEa+KaTnKMx3m5VwLOx0vh4vZuBjrf2Jnn7lVLgxdnqFMk+Rk5bgco7OYu
T9JkPHx3aU3oPIMBfQt2
=1CVJ
-----END PGP SIGNATURE-----

--2UusUvefyJ2PB+/T--
