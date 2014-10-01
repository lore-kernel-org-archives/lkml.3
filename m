Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbaJAJfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:35:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33155 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750782AbaJAJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:35:05 -0400
Date: Wed, 1 Oct 2014 11:33:14 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Shuge <shuge@allwinnertech.com>, Meng Zhang <kevin@allwinnertech.com>,
        ctl <ctl@merrii.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 1/7] ARM: sunxi: Introduce Allwinner A80 support
Message-ID: <20141001093314.GI6884@lukather>
References: <1411570141-29960-1-git-send-email-wens@csie.org>
 <1411570141-29960-2-git-send-email-wens@csie.org>
 <20140925132527.GF15315@lukather>
 <CAGb2v64LwgEZkiuej2KKi+CUU3OkUZaBKJ3ZZn_Y64tDD+LRwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oplxJGu+Ee5xywIT"
Content-Disposition: inline
In-Reply-To: <CAGb2v64LwgEZkiuej2KKi+CUU3OkUZaBKJ3ZZn_Y64tDD+LRwg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oplxJGu+Ee5xywIT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2014 at 09:16:02PM +0800, Chen-Yu Tsai wrote:
> On Thu, Sep 25, 2014 at 9:25 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Wed, Sep 24, 2014 at 10:48:55PM +0800, Chen-Yu Tsai wrote:
> >> The Allwinner A80 is a new Cortex octo-core A7/A15 big.LITTLE SoC.
> >> While it's processor cores and interconnecting bus are new, it
> >> re-uses many peripherals found in earlier Allwinner SoCs.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  arch/arm/mach-sunxi/Kconfig | 5 +++++
> >>  arch/arm/mach-sunxi/sunxi.c | 9 +++++++++
> >>  2 files changed, 14 insertions(+)
> >>
> >> diff --git a/arch/arm/mach-sunxi/Kconfig b/arch/arm/mach-sunxi/Kconfig
> >> index 1aaa1e1..72f222b 100644
> >> --- a/arch/arm/mach-sunxi/Kconfig
> >> +++ b/arch/arm/mach-sunxi/Kconfig
> >> @@ -42,4 +42,9 @@ config MACH_SUN8I
> >>       select MFD_SUN6I_PRCM
> >>       select RESET_CONTROLLER
> >>
> >> +config MACH_SUN9I
> >> +     bool "Allwinner A80 (sun9i) SoCs support"
> >
> > With the new naming scheme, I wonder wether it makes sense to have the
> > A80 displayed here and in the machine definition.
>=20
> I expect anything that falls under sun9i to be compatible, or a trimmed
> down version. But that's just me.

Well, compatible is a rather vague notion. They will be different for
sure. Maybe not that different, but still.

> We know that Allwinner has released the A33, which should be compatible
> with the A23, sun8i.

Except that it would not be straight forward for an A33 user for
example that he needs to enable the A23 support.

> And the A83 has been announced, which looks like a trimmed down
> version of the A80. The next SoC should be arm64, and would not
> matter here.
>=20
> Kevin, Shuge, could you provide us with the codenames for the A33 and
> A83, and what earlier SoC they are based on?

Even though it would be nice to know, it's not really the issue here.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--oplxJGu+Ee5xywIT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUK8paAAoJEBx+YmzsjxAgcuIQAI35HYdQGC+G0Jdhr5PraAOv
1tYFZKcFUHgs85coG3G8Kp+PyA2bW7hPgiLyZwU3u6XvBIiqJQ4SSlBXuBxBS0nV
Toa2r1xhy/UJpJMMe4JUwdPC3r9ggqPpIVSP3wl7a4rraJA+v/GEZPDSuqW4XyF8
ZxtAokKJwl+D93Ctu+L+fOJLkAl8WrEGqeO7qzaMBwkzkZRg+wDbMlKQD9rvM/c+
Ld6hxzAE9YadqGT8BZFeqr0DyBqC2mqn98aS80diqWvFDqlBpbSXJ8UyyjtMzhe1
vjmXU8dSCn+F3xZEafByxqnaRivJObwEJHTYBbMXSjlEJhQOxxfl2mJwiQvUuruK
oSQD8F6ogDEr2F/pbX/3jdwcUKx4gMy9gXkDzozGrzYOy/wylY09SX+RhDEEzoyg
AgyaH80ue1WiLYbYZw/3CsIHyyIByYPNWgR3CLbh9CH/5dLAR7b1fKEDYQNMeJpR
Z2ln9BPhfFxjNdy0AzNPpq1Y8juUKB0LUC8gM4n1c8SoJ+PrK4Anx1uCzGOhit11
YLcPeBTR2saGEG3iUf6awLaLX9isJFISv3ac7hQpjzN8iorYji/QLH10aPr/0b89
up4oS20NXoJHRuXfJzAFX8LGHjFe6ZYSaQoly6fRyO6sE+vOurIeV40LPIWus5Cb
z/Lb8j8D/+N6SFL3LLwx
=9S38
-----END PGP SIGNATURE-----

--oplxJGu+Ee5xywIT--
