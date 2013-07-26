Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758588Ab3GZMXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 08:23:35 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:37550 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757141Ab3GZMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 08:23:34 -0400
Date: Fri, 26 Jul 2013 14:23:32 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, albert.u.boot@aribaud.net,
        Emilio Lopez <emilio@elopez.com.ar>, linux-kernel@vger.kernel.org,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 04/10] ARM: sun6i: Add restart code for the A31
Message-ID: <20130726122332.GB3056@lukather>
References: <1374618312-19001-1-git-send-email-maxime.ripard@free-electrons.com>
 <1374618312-19001-5-git-send-email-maxime.ripard@free-electrons.com>
 <20130726123559.66216580@skate>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i9LlY+UWpKt15+FH"
Content-Disposition: inline
In-Reply-To: <20130726123559.66216580@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i9LlY+UWpKt15+FH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Fri, Jul 26, 2013 at 12:35:59PM +0200, Thomas Petazzoni wrote:
> Dear Maxime Ripard,
>=20
> On Wed, 24 Jul 2013 00:25:06 +0200, Maxime Ripard wrote:
> > The Allwinner A31 has a sligthly different watchdog that requires a
> > different restart code.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  arch/arm/mach-sunxi/sunxi.c | 37 +++++++++++++++++++++++++++++++++++++
> >  1 file changed, 37 insertions(+)
> >=20
> > diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
> > index 11326d9..c18ef3a 100644
> > --- a/arch/arm/mach-sunxi/sunxi.c
> > +++ b/arch/arm/mach-sunxi/sunxi.c
> > @@ -32,6 +32,15 @@
> >  #define SUN4I_WATCHDOG_MODE_ENABLE		(1 << 0)
> >  #define SUN4I_WATCHDOG_MODE_RESET_ENABLE	(1 << 1)
> > =20
> > +#define SUN6I_WATCHDOG1_IRQ_REG		0x00
> > +#define SUN6I_WATCHDOG1_CTRL_REG	0x10
> > +#define SUN6I_WATCHDOG1_CTRL_RESTART		(1 << 0)
> > +#define SUN6I_WATCHDOG1_CONFIG_REG	0x14
> > +#define SUN6I_WATCHDOG1_CONFIG_RESTART		(1 << 0)
> > +#define SUN6I_WATCHDOG1_CONFIG_IRQ		(1 << 1)
> > +#define SUN6I_WATCHDOG1_MODE_REG	0x18
> > +#define SUN6I_WATCHDOG1_MODE_ENABLE		(1 << 0)
>=20
> Alignment is not nice, and the BIT() macro should be used.

Actually, the alignment is the one you would expect in the code.

Point taken for the BIT macro, I'll update it.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--i9LlY+UWpKt15+FH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8mpEAAoJEBx+YmzsjxAgujQP/2qHvw+7SivR6k9zIb8QZV0g
8vfzTAbHO80AZMttZP1UDcKXEtVHM0gN9EfzaB724lSpITd2i78CY/wgn4pZr6I9
mG2RIJNtCHbhYDodD5TwRfqPMMket6is8RQ0Kx+sE6fBGjclaQu/mnlkM1VoNrzE
b3hjfFEC3TKHuR/dNfbgGYESdPwm2p78MHzA0eMl0TAc+D/HqATjBmM3jqB4RIsz
cAVvD0pZ/aBfFmRlKsgBfDN9BrQx1e5Dphi0GZi1AX1Vr7BHDWC3+HaFsI4RAcV+
kIHZmehc6NNKPPuoCz9bL0CeC+7smu22aNcD4O4t7Wafruqvovwo4AMy74+n7Ipt
g0+JLtb32+e7TwTlwuuGFsXvQwiUUjvatvymaTpUpV2XwxXGfzzkaLjlA0t859lV
m5N83QlqiiSFIfyl21XS/qY8C0uReOElNNv1NYZqN/+FjrUK2YxwEJqEAXDiNtA7
lYYnN8I5kZ/bWnZyvpHrH+98OLSlxRUN6fJr2u91psoiMTiR7jl0ZDsNIeggao85
+Uxgjz0lkD8J5qAg23sIhAfi9NvCZ6+Y61F3TqSEXNZGFUg/Xan1FinxFW1/ofJ3
UQmFp87umUyv3iedTAJiupsttLBZVy4ARYNs9LO4gC6JyPxfYg77G2u8CUKIvx4y
rGINBqTBzU1T05Y5haAp
=oz27
-----END PGP SIGNATURE-----

--i9LlY+UWpKt15+FH--
