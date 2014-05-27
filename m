Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaE0IfS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 04:35:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41800 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795AbaE0IfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 04:35:07 -0400
Date: Tue, 27 May 2014 10:34:50 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 19/22] ARM: sunxi: Add earlyprintk support using R_UART
 (sun6i/sun8i)
Message-ID: <20140527083450.GG4730@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-20-git-send-email-wens@csie.org>
 <20140525184636.GN10768@lukather>
 <CAGb2v66jL5-rmSy0W38og6bLiNkGu0wekEZfOuh0Fn2oOsJpaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kjpMrWxdCilgNbo1"
Content-Disposition: inline
In-Reply-To: <CAGb2v66jL5-rmSy0W38og6bLiNkGu0wekEZfOuh0Fn2oOsJpaQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kjpMrWxdCilgNbo1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 26, 2014 at 05:25:43PM +0800, Chen-Yu Tsai wrote:
> On Mon, May 26, 2014 at 2:46 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi,
> >
> > On Fri, May 23, 2014 at 03:51:22PM +0800, Chen-Yu Tsai wrote:
> >> sun6i/sun8i have a UART in the RTC block group, which can be used
> >> as an early console. This is most useful on sun8i as UART0 is muxed
> >> with MMC0, which is not available if we boot from MMC.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  arch/arm/Kconfig.debug | 10 ++++++++++
> >>  1 file changed, 10 insertions(+)
> >>
> >> diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
> >> index eab8ecb..9e22708 100644
> >> --- a/arch/arm/Kconfig.debug
> >> +++ b/arch/arm/Kconfig.debug
> >> @@ -694,6 +694,14 @@ choice
> >>                 Say Y here if you want kernel low-level debugging supp=
ort
> >>                 on Allwinner A1X based platforms on the UART1.
> >>
> >> +     config DEBUG_SUNXI_R_UART
> >> +             bool "Kernel low-level debugging messages via sunXi R_UA=
RT"
> >> +             depends on ARCH_SUNXI
> >
> > It should rather depend on MACH_SUN8I.
>=20
> I assume no sun6i devices would use it, or have pads available for
> it?  If so, then MACH_SUN8I makes sense.

Then a depends on MACH_SUN6I || MACH_SUN8I.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--kjpMrWxdCilgNbo1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJThE4pAAoJEBx+YmzsjxAg9bgQAJ6wN7wClFZJeI8Pr/dLovxw
CptfI8BcsIBGJ5m2D+MrySJoPSvHqNRrDCwVBSM27CkpUAOQ3zejZRuPDympYD6j
1DbuF5C/6d73VO07NIdeImFyeqvUVQU+foACehvJOhN5gyLkkDOCD57dwNdjtMbZ
XKW5g8XdMMZTjWGhzxxJ2FVnO51PTehwJpFuCr05WBFaR5ubsigJD5f6OJADXda1
/bO5RiZLS5rfHJCVI0gWuE/rXsbl1ywt8J0dF4JRGas0a3h5VPmobcGCoSLkeTaZ
nBVtGNFWUrEL+zB1mG4MbFHbiut6c+eAAq920VticCFQBvPx6nfxeNTE1uUH9VVs
jEw/0GVIWZEbxeZrtJ8WVuXCXclDsMfvGF4r8TKAwawRKxSES+CxqEcdh3aMJZpM
yFpMDmg0pK/jBZKnVjm/FN58eD+YmbAAVGOThXJSh6Lh4EjGWwsLJuXptvSQrm6q
N23FSagrclXYYW9K6EoZojHoOrJJHWmFPfwVG3I55vz3pSPy/7dw453JIM35CB/G
sVp27Ukd3xSRrxW0c0k8zCccxvOPzvgH0b6w/Y00tGWfUnRbE+noLZyFt1N1mIRC
hUWH4tQiWKkzaWmtSutk5GuWvOOfY7FzMaF5DfRDJ/7uFNvyYTZDwwdCvXOBTbcV
Y0tFqeRS3MjFBiQzYArA
=4UfM
-----END PGP SIGNATURE-----

--kjpMrWxdCilgNbo1--
