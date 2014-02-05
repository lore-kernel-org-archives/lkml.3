Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaBEKfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:35:16 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33712 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751388AbaBEKfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:35:14 -0500
Date: Wed, 5 Feb 2014 11:32:18 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 8/8] ARM: dts: sun7i: Add ethernet alias for GMAC
Message-ID: <20140205103218.GB3192@lukather>
References: <1391398346-5094-1-git-send-email-wens@csie.org>
 <1391398346-5094-9-git-send-email-wens@csie.org>
 <20140203193802.GE25625@lukather>
 <CAGb2v659T_QTLChB0NRS0seQvwDBCmTAH6UBEghZng9Ac6uL4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <CAGb2v659T_QTLChB0NRS0seQvwDBCmTAH6UBEghZng9Ac6uL4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2014 at 12:43:18PM +0800, Chen-Yu Tsai wrote:
> On Tue, Feb 4, 2014 at 3:38 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Mon, Feb 03, 2014 at 11:32:26AM +0800, Chen-Yu Tsai wrote:
> >> U-Boot will insert MAC address into the device tree image.
> >> It looks up ethernet[0-5] aliases to find the ethernet nodes.
> >> Alias GMAC as ethernet0, as it is the only ethernet controller used.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  arch/arm/boot/dts/sun7i-a20.dtsi | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7=
i-a20.dtsi
> >> index 65fb8d0..c48fb11 100644
> >> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> >> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> >> @@ -17,7 +17,7 @@
> >>       interrupt-parent =3D <&gic>;
> >>
> >>       aliases {
> >> -             ethernet0 =3D &emac;
> >> +             ethernet0 =3D &gmac;
> >>       };
> >
> > I'm not very fond of this patch.
> >
> > People might rely on the fact that ethernet0 is actually the emac, and
> > are expecting u-boot to fill the ethaddr variable to the emac, and not
> > the gmac.
> >
> > Since u-boot is totally able to deal with several ethernet addresses,
> > please add it as ethernet1.
>=20
> Actually I think we should override this in the board dts.
> The boards we currently support can only use emac or gmac,
> and in our u-boot tree, they have been converted to using
> gmac. If any future boards support both emac and gmac, we
> can address the ordering then. And the ordering should
> match u-boot.
>=20
> What do you think?

That what u-boot does is not a good argument (especially when it's not
even mainline u-boot we're talking about). Otherwise, I can just cook
up a bootloader of my own, do crazy stuff in it, and use that as an
argument to get crazy things in the kernel.

And you can set eth1addr just fine in u-boot.

But thinking a bit more about your patch, I guess that this patch
makes some kind of sense anyway..

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS8hMyAAoJEBx+YmzsjxAg4LgP/jvwMnQXfRYx/L6y8+EiFNXL
5V+xhq0FJfhaUGBiyB1MjOU3fgiSMN3x0o9/iZtthY0TY10mXqfv5C8RQAEnFioW
i6JfzL6BEEc4ygfrPnuAmVG1BY7b723adWh+c8A3mYCI0CJXt96+4ZiciH7VnPkq
lRuYEjA7ElEFyJiujmXxwRKFyNyyuDVfwkLuYG+RsOdugC+Cpsf1cI6C6oIlusQo
4D8F/h8RlMgN4U7plGyCoiJrnwtuHB3dspqm0NfTTZMuB8lu2EtkNHyFwDNwdjp3
GOgw3P5yHVSowKyiOdrql8SvekS8Aov/RU+GKhkRMX/LroWiOu9daJjF/7W5Jd+E
y7K+7ZX7sm1GLnlzq48QzuQMA0p5V4TEmJWSWkp0Z9aleVS9ehSMSeOTN67OrimA
Mq6XYfRKLx32DQQjRqGpiIothp6+MBR3rRYlhHj15++YgUOPx93imx5nbHNB+Bsy
ygRz+egVhWArqy5Y+0H0qn+gbcKj6nRhUYrG3CnNA9QgxE85LFkx04P5OJDdAcRX
z4Wit+Pt19b8kVczqq1kUFFWUbj/DqoTzLGocTA3opHzev3GROBxYxk5WskyrYBL
WcxBGFL2NjpZFtW4emKH//7XIlke+PQlflmrZDAIxov3YSvqGmgyxiNyhjdIvk70
LQw5uoKUW6H3jjsiIJ3M
=Tt+P
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
