Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbaHVOp4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:45:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45787 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbaHVOpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:45:54 -0400
Date: Fri, 22 Aug 2014 09:45:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Murphy, Dan" <dmurphy@ti.com>
CC: "Balbi, Felipe" <balbi@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] doc: dt/bindings: input: Fix drv260x binding document
Message-ID: <20140822144524.GE22707@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408716741-1163-1-git-send-email-dmurphy@ti.com>
 <20140822141532.GC22707@saruman.home>
 <00FC9A978A94B7418C33AFAE8A35ED49DF1F66@DFLE09.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tVmo9FyGdCe4F4YN"
Content-Disposition: inline
In-Reply-To: <00FC9A978A94B7418C33AFAE8A35ED49DF1F66@DFLE09.ent.ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tVmo9FyGdCe4F4YN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 22, 2014 at 09:25:13AM -0500, Murphy, Dan wrote:
> Felipe
>=20
> On 08/22/2014 09:15 AM, Balbi, Felipe wrote:
> > On Fri, Aug 22, 2014 at 09:12:21AM -0500, Dan Murphy wrote:
> >> Update the drv260x dt binding document:
> >> - Change the node name to the devices function not the
> >> device name.
> >> - Add vbat-supply to the example.
> >> - Fix indentation of the example.
> >>
> >> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> >> ---
> >>  .../devicetree/bindings/input/ti,drv260x.txt       |   19 ++++++++++-=
--------
> >>  1 file changed, 10 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/=
Documentation/devicetree/bindings/input/ti,drv260x.txt
> >> index a9c8519..214e25d 100644
> >> --- a/Documentation/devicetree/bindings/input/ti,drv260x.txt
> >> +++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
> >> @@ -37,15 +37,16 @@ Optional properties:
> >>  			  3.2 v.
> >>  Example:
> >> =20
> >> -drv2605l: drv2605l@5a {
> >> -		compatible =3D "ti,drv2605l";
> >> -		reg =3D <0x5a>;
> >> -		enable-gpio =3D <&gpio1 28 GPIO_ACTIVE_HIGH>;
> >> -		mode =3D <DRV260X_LRA_MODE>;
> >> -		library-sel =3D <DRV260X_LIB_LRA>;
> >> -		vib-rated-mv =3D <3200>;
> >> -		vib-overdriver-mv =3D <3200>;
> >> -};
> >> +haptics:@5a {
> >=20
> > haptics: haptics@5a ??
> >=20
>=20
> I found both types of entries in the bindings docs.
> There is no consistency within the input bindings documentation.

I could swear neither two types have a colon character between node name
and its base address.

--=20
balbi

--tVmo9FyGdCe4F4YN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT91eEAAoJEIaOsuA1yqREgTMP/2XZfPMVWzPigJNrDNaDlQQy
Y1VSHx/Dzv9kEzh/mj2z1oeAMXdROz12bqzLBJ1DvWbQlq4dHv0Ya+oww0gbYo2g
pvuCE1NDthHpmIXUZ0wIIsb2k2GRACutSmk9eOD4ZVQ0+TTv0EVJVe0NbTKRK2TV
1dLENOTKC1e6l/oCXmRNSCgogqdzwDrA2uD4QqlmbcWXeMTjaxDObcwDn1h2mYlh
n5+UPtFDPuJ30c3XfP7/qKue+mUSFf1/5GvnRyPI5QFxdy1r38U80VQLba2Sdi5g
77IqjP4t/RDHyJfUWm6f04D6ZBV5QA9kwbKeFo+tI6pG/3b0mu37EVKVA7l/Xx+W
s8VggWofFr5GdDZY/n2qfJcHUxAvIcIHhEjMpGtiq4Y9XK6lVKWeH+2tW8ksis+l
jZFG2KRqZFk1qwImYWJ4BwcMiRIjVCuxN/k0k8S19RMx6t26weRrbmHmD6xBJPrX
kqowW7CCwa9yeAO/SABWPvhvz0DCA3tFonG/rrmn+HVslkyfuGUCpDfABYsHQPG0
Gn4Jdyrb+jgUnBCSJM/s20Uki38t7QAyx3x2pygxvw0wm+TPKtndHBsZ0DpX1BRG
DxB1K4c9paruUQzLhrB/TlJjnjVzZ+eNHIBWv8pG7A5RF7cHbHw6YGBTxMIHAQ2A
BdJX5qtbb0hAy9Pic+Rz
=cAvk
-----END PGP SIGNATURE-----

--tVmo9FyGdCe4F4YN--
