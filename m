Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966AbaDIPUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:20:21 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33381 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933256AbaDIPUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:20:16 -0400
Date: Wed, 9 Apr 2014 17:17:47 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 00/15] ARM: sunxi: add A31 PL pins support
Message-ID: <20140409151747.GH28585@lukather>
References: <1397051478-4113-1-git-send-email-boris.brezillon@free-electrons.com>
 <CAGb2v66XCN2ar1wj+a1+ZwdcdJ3gzJ+nDiO9bu52OwK+mBB_Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyqLL/JqMvClXZi1"
Content-Disposition: inline
In-Reply-To: <CAGb2v66XCN2ar1wj+a1+ZwdcdJ3gzJ+nDiO9bu52OwK+mBB_Hg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyqLL/JqMvClXZi1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2014 at 10:53:13PM +0800, Chen-Yu Tsai wrote:
> Hi Boris,
>=20
> On Wed, Apr 9, 2014 at 9:51 PM, Boris BREZILLON
> <boris.brezillon@free-electrons.com> wrote:
> > Hello,
> >
> > This series rework the sunxi pinctrl driver to support the PLx pins
> > available on the A31 SoC.
>=20
> Thanks for working on this. I mentioned to Maxime on IRC yesterday that
> we have complete pinctrl drivers for both A31 and A23, based on our curre=
nt
> pinctrl-sunxi driver, in the A23 SDK. These have the complete pin mapping.
>=20
> > It also add missing A31 reset controller DT bindings documentation.
> >
> > I need those PL pins (actually I only need PL0 and PL1) to support
> > the P2WI bus, which in turn is used to communicate with the AXP221
> > PMIC.
>=20
> If you could, please add all the PL and PM pins.
> As I said, you can find complete definitions in the A23 SDK.

We have no idea what these PM pins are for the A31. And this code only
is of interest for the A31 for the moment. Let's not take into account
the A23 for now as far as the pin definitions are concerned.

> > Let me know if these changes are too intrusive.
>=20
> I wonder if we should do a separate driver for the new PIO controller.
> Clearly it's a separate IP block, with it's own clock and reset controls.

It's been merged together in the A23, hence why we did it like that.

> Allwinner sources list this block as "R_PIO". I suggest using this name.
> Clearly "pioL" does not cover all the functionality.

I'd agree with that.


> I have started to document the PRCM block: http://linux-sunxi.org/PRCM

It's quite different on the A31 and on the A23 actually :(

You don't have any of the audio thing for example, but you have the
CPUs power clamp controls, that have been moved to the=20

Maxime


--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--oyqLL/JqMvClXZi1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTRWSbAAoJEBx+YmzsjxAgaS8P/AvHsanJb4u55kOaO+vmdsfD
j2fGdLdSnRChg3yVXb0eqNweh0+P9Bdfk+s+YiQyDjgKA1k9XOJXpvFNLQMQSkpx
P8enwK4pjv7SrRdTw8hU2eKpsXkXWCFJcRBrF4tESU/uZ4Co4U8hmtf8Zm6McJ5c
Rb4T+6FIqtYuatZSgVxZL1UByKsPBRpNJighh/r5OYmFlctPYFpMHhlusaZ53GUE
8O7h4HFawsSKmDiQ3af+tpjwVGU9VcaBqRvDh6XtmQ9RDuJ8BL9LLWYbegzzBDgK
f5AXCS/9CYj5XCkJ6RDRqcAT2nOzaeJ+dXmlxT7r14paKHlSBaVsjoUeJz5tTiku
nef6Wpzc4ixlsn3ZGOh6QZRo8v+lWEkEOPMbFZ0gQG1ePRaV9/jYp6Hr5kKPi/eO
MBH4Cbqo5je+JVfAGzkFroV4KgTAOVKeApT793ZYQRjqLqb8jkCvVxuiQNpAUeXs
rWwHRjHkX1DrmhwE/SYYx4Hgf8MfJXYcGLvM/5lWDjmUKKZ3LEnVObAwWEneAbkD
9huJWxCqlqWCuKtrOyni/U8K2JUtR30mfFcUpN6vHnKu+V9w8iKb/PZyD175/YRS
mc42Pn+4EjZcTjATazGc5hIBF4U5Y7Dlp7MvX5d/qkmIWDzurXavphAY7mwUEXp7
hDLB2Cibr2+rgaC5sO9t
=8kjP
-----END PGP SIGNATURE-----

--oyqLL/JqMvClXZi1--
