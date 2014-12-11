Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbaLKVUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 16:20:21 -0500
Received: from down.free-electrons.com ([37.187.137.238]:46777 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759091AbaLKVUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 16:20:20 -0500
Date: Thu, 11 Dec 2014 22:15:50 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vishnu Patekar <vishnupatekar0510@gmail.com>
Cc: linux-sunxi@googlegroups.com, dmitry.torokhov@gmail.com,
        linux@arm.linux.org.uk, leafy.myeh@newbietech.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        vishnupatekar <VishnuPatekar0510@gmail.com>
Subject: Re: [PATCHv2 3/3] ARM:dts:sunxi:ps2 dt nodes for A10/A20 PS2
 controller.
Message-ID: <20141211211550.GJ8739@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6AFz5yWxU/FsGPwt"
Content-Disposition: inline
In-Reply-To: <CAEzqOZu49Z99B4DWvuD=E2BKs7ihSVAunshheUn=Z-VAqivUxA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6AFz5yWxU/FsGPwt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Please keep the Cc list.

On Wed, Dec 10, 2014 at 01:39:52AM +0530, Vishnu Patekar wrote:
> > > --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > > +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > > @@ -112,6 +112,19 @@
> > >                       pinctrl-0 =3D <&uart0_pins_a>;
> > >                       status =3D "okay";
> > >               };
> > > +             /* PS2 0 and PS2 1 are disabled by default
> > > +             To enable PS2 0 and PS2 1 uncomment below ps20 and ps21
> > nodes
> > > +             Please note that ps20 pins conflict with HDMI on Lime2
> > Board*/
> > > +             /*ps20: ps2@0x01c2a000 {
> > > +                     pinctrl-names =3D "default";
> > > +                     pinctrl-0 =3D <&ps2_0_pins>;
> > > +                     status =3D "okay";
> > > +             };
> > > +             ps21: ps2@0x01c2a400 {
> > > +                     pinctrl-names =3D "default";
> > > +                     pinctrl-0 =3D <&ps2_1_pins>;
> > > +                     status =3D "okay";
> > > +             };*/
> >
> > Hmmm, no, no comments in the DTS.
> >
> > Especially when it's that trivial to enable.
>
> Okie, I'll just keep ps20 and ps21 nodes commented.

No, the comments themselves were great. But the nodes themselves
shouldn't be there in the first place.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--6AFz5yWxU/FsGPwt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUigmGAAoJEBx+YmzsjxAg0HAQAIafhNQ4y1Vars45OJRlffwZ
J+Qizn7uGVqtCze/17O0c729+fOCJYqR89XeFV7Oka+EH78SF7EyMcAbLuWy8jQv
V2hS6gtXVV5AK9LdJhB8dATSGwCglVkTmcn5zqES36ULqIPQguNfhDCxeHqoidva
zBGB1ycIQ6eXcP+OPfNh/eMkLoEoXZEUme5Xm2mlBNPYHTYPRga8yvDeV4/Hn7a/
KO0OWFk5Mu9CUG7BJtbs5B7fVNzJYTLMo2jkkN6tl0OUCTx0u/hWXbnhOv+0riv3
RGC/cgF0DewYzrj45phYxlD5GJlTArDxzyVGqMKJhsJgqRvUBjWTs90cGD2OxTaz
XtFrGJ4qYWMqxMujYLU7XU4OicnoQjEx/QrBMdvHqGL8G22bkae84BxNxgLFxwuj
E0FiUmBz+OwBKlbs2r+/wDtT9mEzTaocuMJmQaxKStGzlFyi3hpOju+igbTrvn/W
Z/E+6eqzbObnJEzQkzUqbwD1gMQH40KvHH0jx4Ttg4W+erJVixmI5h7Ak0rYTelx
70fDM/iZrv6dQq3ff80pDtfum587D9KUWo9A7oxShp5MzY8fz8w5FfP/MwR0N3b/
mX1IPbJGd//q1wjJcTgKp8g5pTnHvE2TlRvlqrJejHeiogCkT6nFwefieAwjT1j1
0i5ZT3FkEkdaoQCe/KnJ
=F6bF
-----END PGP SIGNATURE-----

--6AFz5yWxU/FsGPwt--
