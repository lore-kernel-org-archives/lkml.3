Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbbAUMZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:25:15 -0500
Received: from down.free-electrons.com ([37.187.137.238]:36223 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752266AbbAUMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:25:04 -0500
Date: Wed, 21 Jan 2015 13:23:29 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vishnu Patekar <vishnupatekar0510@gmail.com>
Cc: Iain Paton <ipaton0@gmail.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [linux-sunxi] [PATCH v4 5/5] ARM: sunxi: dts: Add PS2 nodes for
 A20 lime2 board
Message-ID: <20150121122329.GG4367@lukather>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
 <1421417021-3247-6-git-send-email-vishnupatekar0510@gmail.com>
 <54BE8A0E.30604@gmail.com>
 <20150120200740.GY4367@lukather>
 <CAEzqOZsWYQ+Aep6HBZXVtKGEJgKYAKJU2b0=nGvP0jPKECxn7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0EIE/3F9PxFGTcfe"
Content-Disposition: inline
In-Reply-To: <CAEzqOZsWYQ+Aep6HBZXVtKGEJgKYAKJU2b0=nGvP0jPKECxn7g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0EIE/3F9PxFGTcfe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2015 at 04:34:45PM +0530, Vishnu Patekar wrote:
> Hello,
>=20
> On Wed, Jan 21, 2015 at 1:37 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> >
> > On Tue, Jan 20, 2015 at 05:02:06PM +0000, Iain Paton wrote:
> > > On 16/01/15 14:03, Vishnu Patekar wrote:
> > > > Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> > > > ---
> > > >  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts |   12 ++++++++++++
> > > >  1 file changed, 12 insertions(+)
> > > >
> > > > diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch=
/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > > > index ed364d5..3365f12 100644
> > > > --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > > > +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > > > @@ -113,6 +113,18 @@
> > > >                     status =3D "okay";
> > > >             };
> > > >
> > > > +           ps20: ps2@01c2a000 {
> > > > +                   pinctrl-names =3D "default";
> > > > +                   pinctrl-0 =3D <&ps20_pins_a>;
> > > > +                   status =3D "okay";
> > > > +           };
> > > > +
> > > > +           ps21: ps2@01c2a400 {
> > > > +                   pinctrl-names =3D "default";
> > > > +                   pinctrl-0 =3D <&ps21_pins_a>;
> > > > +                   status =3D "okay";
> > > > +           };
> > > > +
> > > >             i2c0: i2c@01c2ac00 {
> > > >                     pinctrl-names =3D "default";
> > > >                     pinctrl-0 =3D <&i2c0_pins_a>;
> > > >
> > >
> > > As the Lime2 doesn't actually have any PS2 connectors on the board,
> > > I'd prefer that these are not enabled unconditionally. Doing so
> > > only makes it more difficult for people who want to use these pins
> > > for other functions.
> > >
> > > Device tree overlays seem to be close to being merged, perhaps we
> > > could leave enabling this to an overlay?
> >
> > I already had the exact same reasoning, and this was even removed at
> > some point. For some reason, it was added back, and I don't really
> > know why.
> This was removed in consideration that these pins conflict with HDMI,
> however, these is not conflict.
>=20
> It was kept there as an example. But, as there is no ps2 connector on
> board, I've no problem to remove these nodes from Lime2 dts file.

Yet, probing a driver for a device connected to floating lines sounds
like a pretty bad idea.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--0EIE/3F9PxFGTcfe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUv5pBAAoJEBx+YmzsjxAgc48P/j+pPis8VZcc25MTZOC3WDDl
DNoAl9oFxrvEqvgzXKWrSF+Gulc+stTqimzSK/TCfB20TECLVuwcbmoQzGhFNCCZ
pA9lT2STK/1btARRjf00loADuxu/Hi+RzQRUgGNW5aUxqE0jUIWxs+KCUuG/Doss
9y/CjMPgHp0THuqM5YNvFi7f9hI+tDrNE4kzHGiRY3zOjIJ59/qlNkX0gXeJVjrY
QwLvWfCR5xJT0AOoKtjpzEjCRUJs50wDU1IRvki4ufthPA7uuRv0fi9taCoiHw+m
r+5fVKVli22FUTOdBISUH/Yu3EtWYN8m3Uagw0EJ0QLvpcnDJbWG1xxYXBdyUdNj
+b6297CUplbLOeZxCgsDNa/T0mIwfyArmQwW30kDVYZnxCtgNlxBD4cUFNJ3/+Oq
mZbGwmOo6oGAcGUeIntTk0q3zfr23K4hFoktB16tdyX7GglUgnFN8aoj5LlJRVMk
eHuAiuMIiv8xkU0ST0xQ914mRmWJH1ZcNf0Zzh/zNFixBy0MJKzF1cR6cR4jw2Xa
6FQPAibqZRv6Nreb9fPkOUuFQSYyOscnkhK+f4McKTwUtZsm6vgJcDNUtaLfhdxb
+a4DtuM5b92kIl50AZc7qDEUMNCoPbQewLyR/pJt+L3rDPgxnGli9J2xrVGuRmTk
IkehO7r9WW8GQPH52hdD
=HMWJ
-----END PGP SIGNATURE-----

--0EIE/3F9PxFGTcfe--
