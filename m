Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaHROaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 10:30:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52917 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751572AbaHROaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 10:30:04 -0400
Date: Mon, 18 Aug 2014 16:27:37 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] ARM: dts: sun8i: Add i2c controller nodes
Message-ID: <20140818142737.GC15297@lukather>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
 <1408247538-16950-12-git-send-email-wens@csie.org>
 <20140817080204.GY15297@lukather>
 <CAGb2v67NwsJORoFrgEECDtexXGtF5qOx7NX1PVpZHkjVs-mG2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uLm21ivgZj9Xvi41"
Content-Disposition: inline
In-Reply-To: <CAGb2v67NwsJORoFrgEECDtexXGtF5qOx7NX1PVpZHkjVs-mG2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uLm21ivgZj9Xvi41
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 17, 2014 at 11:20:44PM +0800, Chen-Yu Tsai wrote:
> Hi,
>=20
> On Sun, Aug 17, 2014 at 4:02 PM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi,
> >
> > On Sun, Aug 17, 2014 at 11:52:17AM +0800, Chen-Yu Tsai wrote:
> >> Add nodes for the 3 i2c controllers found on A23 SoCs to the sun8i DTS=
I.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  arch/arm/boot/dts/sun8i-a23.dtsi | 36 +++++++++++++++++++++++++++++++=
+++++
> >>  1 file changed, 36 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8=
i-a23.dtsi
> >> index 4658998..53ef350 100644
> >> --- a/arch/arm/boot/dts/sun8i-a23.dtsi
> >> +++ b/arch/arm/boot/dts/sun8i-a23.dtsi
> >> @@ -387,6 +387,42 @@
> >>                       status =3D "disabled";
> >>               };
> >>
> >> +             i2c0: i2c@01c2ac00 {
> >> +                     compatible =3D "allwinner,sun6i-a31-i2c";
> >> +                     reg =3D <0x01c2ac00 0x400>;
> >> +                     interrupts =3D <0 6 4>;
> >> +                     clocks =3D <&apb2_gates 0>;
> >> +                     clock-frequency =3D <100000>;
> >
> > It's the default, you don't need to set it.
>=20
> Ah, just checked the driver, it is indeed the default.
> All the other sunxi dtsi have it though. Do we want to be consistent?

Yep, it's usually a good thing :)

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--uLm21ivgZj9Xvi41
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT8g1ZAAoJEBx+YmzsjxAgyacP/3/ko9bcKsX5wzsmI3eSB+mD
ZXDMvs7HU6LiZsM9F/bwGU7n1+XdAnu6zLPtYaPsfyqzQv4SL09WObo/CDvzdbYR
QTmUsqW/f+l5dEa59XhpO7kRWzCwsRlhMy6yr7+w1dLUeSLplt82u7WsdaluINre
ED5eGvHpwXNU/qPyA8nFBGEt30VsGHrww+sSxcg2GRNdME8gmnvmeSbbltx0Ji/u
5aYR60ImJifDDF/In0ZA9k3Of7NFBtNbBRZ8wBIv0/hF/Q4xuaT6ZeED+/niHsuU
7D5f7zaF6kYcx2yV2nmAC5YnRE/gtyFFE703j8g/nRGBieGd4AugWPDMoq0l2ZDv
gX9vvF2exiWIxBEA+Xyl6J6j3m3Y2wyKZ/7/imiZ5bRkgq3todugKRue9h3gNmyf
JVnYr2bCXFZ1gUuyEALz+3bSvL9T+5G6sTk3HKysVuxCfBAQRo7RZYzMrR2f37IK
2i5UNBZXgh/tQ6RCZ9fBJUwNdHXK4VNpCeQ59gN/shL1bJK2U23QSXRQQxM1tf8b
EPrC0fDYvKH0SOU3JT81G3TBhYjJaLKYoPYLSCaV0GeWSXYH4getHy9rw8S38t4T
xEIbZ9PquZ8dI8FtvZtlAz4kY9bwH0QLNE4KNxivOrPaMLwHjqJjOPYUD3yNFT8Q
Bnh65Ufi7IxTi3acBts6
=JASe
-----END PGP SIGNATURE-----

--uLm21ivgZj9Xvi41--
