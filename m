Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbbATUKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 15:10:12 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59827 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752075AbbATUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 15:10:10 -0500
Date: Tue, 20 Jan 2015 21:07:40 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Iain Paton <ipaton0@gmail.com>
Cc: linux-sunxi@googlegroups.com, Vishnu Patekar <vishnupatekar0510@gmail.com>,
        dmitry.torokhov@gmail.com, hdegoede@redhat.com,
        ijc+devicetree@hellion.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH v4 5/5] ARM: sunxi: dts: Add PS2 nodes for
 A20 lime2 board
Message-ID: <20150120200740.GY4367@lukather>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
 <1421417021-3247-6-git-send-email-vishnupatekar0510@gmail.com>
 <54BE8A0E.30604@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w+MAdceOglSEzbpc"
Content-Disposition: inline
In-Reply-To: <54BE8A0E.30604@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w+MAdceOglSEzbpc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2015 at 05:02:06PM +0000, Iain Paton wrote:
> On 16/01/15 14:03, Vishnu Patekar wrote:
> > Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> > ---
> >  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts |   12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >=20
> > diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm=
/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > index ed364d5..3365f12 100644
> > --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> > @@ -113,6 +113,18 @@
> >  			status =3D "okay";
> >  		};
> > =20
> > +		ps20: ps2@01c2a000 {
> > +			pinctrl-names =3D "default";
> > +			pinctrl-0 =3D <&ps20_pins_a>;
> > +			status =3D "okay";
> > +		};
> > +
> > +		ps21: ps2@01c2a400 {
> > +			pinctrl-names =3D "default";
> > +			pinctrl-0 =3D <&ps21_pins_a>;
> > +			status =3D "okay";
> > +		};
> > +
> >  		i2c0: i2c@01c2ac00 {
> >  			pinctrl-names =3D "default";
> >  			pinctrl-0 =3D <&i2c0_pins_a>;
> >=20
>=20
> As the Lime2 doesn't actually have any PS2 connectors on the board,=20
> I'd prefer that these are not enabled unconditionally. Doing so=20
> only makes it more difficult for people who want to use these pins=20
> for other functions.
>=20
> Device tree overlays seem to be close to being merged, perhaps we=20
> could leave enabling this to an overlay?

I already had the exact same reasoning, and this was even removed at
some point. For some reason, it was added back, and I don't really
know why.

Maxime


--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--w+MAdceOglSEzbpc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvrWMAAoJEBx+YmzsjxAgCZoQAKeSdHaeP+9pOqAe9WaoSy8L
QU3ednltVvIBGqR3plZ+Mut2iglVtpL9STfw4SbDu/zRNPQDttWS4lnWiOMnPnP0
72eOC2niovAffsyKDEWzXrVuTg2rnkD+RoJ1QgQweGPGRaeOiGtB3NXTFapxBOW/
xV33EoihrlM7WnO3dMUfkXLCxUGb1Wir3bVATif1Bb07PivLe31xczgdRQPaYxOZ
WPKbLFig37x1W0yv6B8bVGjLiz+CNf8jGwUVoSn4RQHbb48bgAhigvOYjFBx457C
6Moph/EswWTW26gPQ6MJYYgcPoJkPe0hKFDji+t3qJOzbRUqjDYG6mNc7hgqNdWN
ny2xYTwQgM2qg97SqQaF7zZKYOFb9rTa14ZTvHY9Gl19/mFU1fYvynpJ5ySR53dS
WwtjrTFhf8WWqcSiZIlDKPITG1NRn9gmsykTHGK6tM6U/4NdgyhXORncUwB13zNN
ai/kOopAymEZy2AIWWxYRdmm1cSQyO0YHx3NSPoMkG90d73papcOFO4A9AB3ILAU
3T7qPszDE6TSrch3Z5E5P0GWZQ1gHKAPSOvfFfJTxE7ELeJnhpQ6Na4y4qUfryKG
vLdRBEF1v7ONbXxBegpZYmos1kPcnoFrAeFx1AQOceleKnPJc3CFh33O06T5Aw5z
Vz2NKy3h4dbxrv0j5yzS
=xLGI
-----END PGP SIGNATURE-----

--w+MAdceOglSEzbpc--
