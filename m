Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaHVOQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 10:16:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34634 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099AbaHVOQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 10:16:02 -0400
Date: Fri, 22 Aug 2014 09:15:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dan Murphy <dmurphy@ti.com>
CC: <devicetree@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <dmitry.torokhov@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] doc: dt/bindings: input: Fix drv260x binding document
Message-ID: <20140822141532.GC22707@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408716741-1163-1-git-send-email-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eHhjakXzOLJAF9wJ"
Content-Disposition: inline
In-Reply-To: <1408716741-1163-1-git-send-email-dmurphy@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eHhjakXzOLJAF9wJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 09:12:21AM -0500, Dan Murphy wrote:
> Update the drv260x dt binding document:
> - Change the node name to the devices function not the
> device name.
> - Add vbat-supply to the example.
> - Fix indentation of the example.
>=20
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/input/ti,drv260x.txt       |   19 ++++++++++----=
-----
>  1 file changed, 10 insertions(+), 9 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/input/ti,drv260x.txt b/Doc=
umentation/devicetree/bindings/input/ti,drv260x.txt
> index a9c8519..214e25d 100644
> --- a/Documentation/devicetree/bindings/input/ti,drv260x.txt
> +++ b/Documentation/devicetree/bindings/input/ti,drv260x.txt
> @@ -37,15 +37,16 @@ Optional properties:
>  			  3.2 v.
>  Example:
> =20
> -drv2605l: drv2605l@5a {
> -		compatible =3D "ti,drv2605l";
> -		reg =3D <0x5a>;
> -		enable-gpio =3D <&gpio1 28 GPIO_ACTIVE_HIGH>;
> -		mode =3D <DRV260X_LRA_MODE>;
> -		library-sel =3D <DRV260X_LIB_LRA>;
> -		vib-rated-mv =3D <3200>;
> -		vib-overdriver-mv =3D <3200>;
> -};
> +haptics:@5a {

haptics: haptics@5a ??

--=20
balbi

--eHhjakXzOLJAF9wJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT91CEAAoJEIaOsuA1yqREVoUP/jmwHkb95lpDGx4fGJZmrNfU
NUb2lmCZyDm0nMCpaRnoBQgsebrGh86U9RVossh9+PBmYQIFs9hSN03JQceA3j1C
8tDOxwV1TjQ/8ZknAq41FyRXL1L5q2iBq1fSLaH6D8q5Vt+ti9vQ15J5Q6uJYfi1
WYPaaqGbn5ezunHczsQiIl3C9ZeLVNDM+OzcLY0YTsXblsKiUt+pDj6vDYI0JzJ4
Hr5wbLEj48AefGeE7+wRIuUxNj1w9xbn2nfsmSiFJ1K0TOezqfSE7pAAUjs6mxVE
9CFgsoHZAEsg5V6eaE4FEbuGAwzjJO9Phl1ZqMrstru2pU8z8bhwz0fzrPoguvmZ
qe13jMq5uu5IuHLIS3XLtxAQZWo2PldjIV8y3xOgtRH6sUC2xeNjik4A5p+ZKVZE
7fXYmYhZVUI5Pk8uI1pi1vIvM4ZvKXT6ejTndGJxnL3zoBTcB6o6ADO62sxl2k74
HkdcMHSVIAJbqwWKYGy4hjWikfJihiX6/gJyMuX9z43wLpH3778Pgq9z9WIIj5CI
BWWjuBncEIc/94BtfOmVMJ4qCZe0lLyTlFLg7m+dUG38kpQUEl3tCA8u1OEKxco6
glTzUuVbhf1k4CDqswl4sbVkB0uWbvIzWT9R0LeTCkc9fK3vD63pUrRT+qjrPVcR
235zgYafGO7OwoYxW5lI
=5zzd
-----END PGP SIGNATURE-----

--eHhjakXzOLJAF9wJ--
