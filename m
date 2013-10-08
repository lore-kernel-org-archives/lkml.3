Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3JHRrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 13:47:55 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38030 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753013Ab3JHRrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 13:47:53 -0400
Date: Tue, 8 Oct 2013 12:47:21 -0500
From: Felipe Balbi <balbi@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Nishanth Menon <nm@ti.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Felipe <balbi@ti.com>, Olof Johansson <olof@lixom.net>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: dts: omap3-beagle: use 3630 definitions
Message-ID: <20131008174721.GH13128@radagast>
Reply-To: <balbi@ti.com>
References: <523C9D8B.2000701@ti.com>
 <1381164584-4008-1-git-send-email-nm@ti.com>
 <1381164584-4008-3-git-send-email-nm@ti.com>
 <20131007192009.GA8949@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q59ABw34pTSIagmi"
Content-Disposition: inline
In-Reply-To: <20131007192009.GA8949@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Q59ABw34pTSIagmi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 07, 2013 at 12:20:09PM -0700, Tony Lindgren wrote:
> * Nishanth Menon <nm@ti.com> [131007 09:57]:
> > beagle-xm currently would matchup with ti,omap3 which invokes
> > omap3430_init_early instead of omap3630_init_early. So add
> > compatiblity for 3630 to allow match
> >=20
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> > ---
> >  arch/arm/boot/dts/omap3-beagle-xm.dts |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/=
omap3-beagle-xm.dts
> > index 0f7cfc5..2079e22 100644
> > --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> > +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> > @@ -11,7 +11,7 @@
> > =20
> >  / {
> >  	model =3D "TI OMAP3 BeagleBoard xM";
> > -	compatible =3D "ti,omap3-beagle-xm", "ti,omap3-beagle", "ti,omap3";
> > +	compatible =3D "ti,omap3-beagle-xm", "ti,omap363x", "ti,omap3-beagle"=
, "ti,omap3";
> > =20
> >  	cpus {
> >  		cpu@0 {
>=20
> This compatible string looks hacky.. How about just make it
>=20
> "ti,omap3-beagle-xm", "ti,omap363x", "ti,omap3";
>=20
> How about just leave out "ti,omap3-beagle" here?

ti,omap3-beagle was already part of the original file, we can definitely
remove but I'd expect us to maintain support for that string
indefinitely should anybody continue to use older dtbs.

--=20
balbi

--Q59ABw34pTSIagmi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSVEUpAAoJEIaOsuA1yqRE+e4P/iuHK5dZhvKv6lLuXQ2KVOz+
/IfwTBSGZ82mBCsZWXxvgvr95Px/3/Bn8jJ4dbVcmHhJgDfefbp0p4gm3d+lfdwK
4xB+bjFhHq3T3o1qsAyN5b44ZPXy1RG+C5TSu1ZIQYPJVTZYDaztvphpuAfXBtpw
AXokzaOBrlfrt1g7Qc0FAqyyjiYwMeLnhR6uCls+oWKN6M3GSvglcjOkeRX8wEzM
OmPYoPTKX3hPbwL9Ino9s4NjymlntsbXWTso2+6teUIVjr9hr0ckAOFBcte4FoE5
1rBztO9lyzfS1EyP91Qx1o1bVo7T5w2+QaKzXY+gccKfvsakaojO78rcxThGe7Uq
CbFzk+bhCPUxXFKXVT45bHSMsfPj/qPHJ5ZxxE2zEeGaxnni50RIAyo82oxc+8T+
709xSMuymK3qD/g8dw8C6MTwMsyZXU7rL6d3CKVsMzUnAkKn5GUNFelaztzTDs9c
BZ0zD/xTBthrTIevUaTzBSIY8aUkME2TPZmS0MILsOeJwfHXC7A8VG/+V4scHVYr
lOMFBe69RExzCE8Ifr8otMg88b08THdCuXO6/nR1tiVGNVOGUHgzFfwvsGbRSTmZ
rSD9EXCZbbPnOS27xGVJVbSWZgkkEirKKRLAX99N+AJlfaHlEJyoHTVQm1KAEEpa
EEGN+S5D3O7uo21UbuGS
=9rTN
-----END PGP SIGNATURE-----

--Q59ABw34pTSIagmi--
