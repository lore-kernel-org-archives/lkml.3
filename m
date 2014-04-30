Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbaD3SfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 14:35:20 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48860 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758836AbaD3SfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 14:35:18 -0400
Date: Wed, 30 Apr 2014 11:31:53 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-sunxi@googlegroups.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "arm@kernel.org" <arm@kernel.org>
Subject: Re: [PATCH 5/5] ARM: sunxi: Remove sun4i and sun7i machine
 definitions
Message-ID: <20140430183153.GG3000@lukather>
References: <1398265476-29373-1-git-send-email-maxime.ripard@free-electrons.com>
 <1398265476-29373-6-git-send-email-maxime.ripard@free-electrons.com>
 <1401022774.yKcHJAmPtb@wuerfel>
 <CAOesGMhgTJugKyfa3QB=Zk1O0bDX9EgBnr4i9KeCD5bBpZ9mVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tcC6YSqBgqqkz7Sb"
Content-Disposition: inline
In-Reply-To: <CAOesGMhgTJugKyfa3QB=Zk1O0bDX9EgBnr4i9KeCD5bBpZ9mVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tcC6YSqBgqqkz7Sb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 28, 2014 at 06:08:53PM -0700, Olof Johansson wrote:
> On Wed, Apr 23, 2014 at 9:02 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Wednesday 23 April 2014 17:04:36 Maxime Ripard wrote:
> >>
> >> -static void __init sunxi_dt_init(void)
> >> -{
> >> -       of_platform_populate(NULL, of_default_bus_match_table, NULL, N=
ULL);
> >> -}
> >> -
> >> -static const char * const sunxi_board_dt_compat[] =3D {
> >> -       "allwinner,sun4i-a10",
> >> -       "allwinner,sun5i-a10s",
> >> -       "allwinner,sun5i-a13",
> >> -       NULL,
> >> -};
> >> -
> >> -DT_MACHINE_START(SUNXI_DT, "Allwinner A1X (Device Tree)")
> >> -       .init_machine   =3D sunxi_dt_init,
> >> -       .dt_compat      =3D sunxi_board_dt_compat,
> >> -MACHINE_END
> >> -
> >>  static const char * const sun6i_board_dt_compat[] =3D {
> >>         "allwinner,sun6i-a31",
> >>         NULL,
> >
> > I'd like to hear more opinions on this. We could either rely
> > on the generic code, or we could keep the entry with just
> > the .dt_compat line and the name, so /proc/cpuinfo contains
> > a meaningful platform name.
> >
> > Either approach works for me, but I think we should do this
> > consistent across platforms. Olof, do you have an opinion?
>=20
> In reality, today, most platforms still need some out-of-tree stuff
> that usually goes into the mach directory on out of tree kernels. It
> also gives a place to stick the Kconfig entries, it's been nice to
> have them split out in per-platform Kconfigs instead of having them
> all modify and conflict the shared one.
>=20
> I know those aren't strong arguments to keep it, but given that all
> other things are more or less equal, it's a good a reason as any.

I guess the /proc/cpuinfo thing just tip the scales to keeping the
minimal machines. I'll update the patches.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tcC6YSqBgqqkz7Sb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTYUGZAAoJEBx+YmzsjxAgcDMP/3jn/SDNmUHvVv8iwM0xXz5+
d2N4UJ5jVn6GNGzLOsWoBrQiBmHd2Pyo1mQxal03bHtdiNUYjufUMRiRXU49mBNY
TWGaRjy5v8J9tOPat5PTfyC2xKQR/pOBFcwK6Y0nlNIL0M/f+XaRlfUjTL0y69Wl
x5EvR2m4fO8pzcfcHrW5VFUJ5/RQZ+Uk6qrIh1EyDe95DCHDVAe53JpVrEMDZOAp
Z8n2SORk/+UUKWyHR0QTNzKOI9HTZzKZQ6ZEEKqIrC2ReB4DVl5KjpkFgEqOvAa+
PlEwaWnU5Ea8gPLAZuEWe1xUzm21ioxtAL+2KFxnoPTRpqMd5wWpwOOLSTXs3eDq
MOvCHYniWkWD+gSnITwfjJW0uVGpBBGHOMaX3icQyyF/Yn5qdJNjP9V74ukdCeAO
79r6BDDy51oQ+LMzb12LM0TXWIP3q9lSOXJUVA/UDZDrtjJcGXilL1hYQrQ8Mmku
sCitwv4VvWHLt1c7W0gNdvImGPXP+MddjMj6kXi33rtzmsCwwptEjRZRlPQEWfNu
uu+9bmk+vlkzc035cOQEWPrGJNa+O2Mk1Y86vDfw5OWih5KFb8Om5QWiiQIKQAFM
ZGHJ0XamSko6Fw2otY932S0CMuik0PhvxjpU425pzxXCGt7QvE0ItOt9OaFhWpqe
T11W/o13Z68mAEhXwY0e
=5d+2
-----END PGP SIGNATURE-----

--tcC6YSqBgqqkz7Sb--
