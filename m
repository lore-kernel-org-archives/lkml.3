Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbaKLOGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:06:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59429 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaKLOGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:06:43 -0500
Message-ID: <546367EE.3040600@ti.com>
Date: Wed, 12 Nov 2014 16:00:14 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Marek Belisko <marek@goldelico.com>, <grant.likely@linaro.org>
CC: <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <plagnioj@jcrosoft.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-fbdev@vger.kernel.org>,
        <hns@goldelico.com>
Subject: Re: [PATCH 2/4] Documentation: DT: Add documentation for ti,opa362
 bindings
References: <1415051968-4878-1-git-send-email-marek@goldelico.com> <1415051968-4878-3-git-send-email-marek@goldelico.com>
In-Reply-To: <1415051968-4878-3-git-send-email-marek@goldelico.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="X2ieMLxDB39d4REA0BmaIGN0G23iiAGBt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--X2ieMLxDB39d4REA0BmaIGN0G23iiAGBt
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 03/11/14 23:59, Marek Belisko wrote:
> Signed-off-by: Marek Belisko <marek@goldelico.com>
> ---
>  .../devicetree/bindings/video/ti,opa362.txt        | 38 ++++++++++++++=
++++++++
>  1 file changed, 38 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/video/ti,opa362.t=
xt
>=20
> diff --git a/Documentation/devicetree/bindings/video/ti,opa362.txt b/Do=
cumentation/devicetree/bindings/video/ti,opa362.txt
> new file mode 100644
> index 0000000..d7ed11a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/video/ti,opa362.txt
> @@ -0,0 +1,38 @@
> +OPA362 analog video amplifier
> +
> +Required properties:
> +- compatible: "ti,opa362"
> +- gpio: enable/disable output gpio
> +
> +Required node:
> +- Video port 0 for opa362 input
> +- Video port 1 for opa362 output
> +
> +Example:
> +
> +tv_amp: opa362 {
> +	 compatible =3D "ti,opa362";
> +	 gpios =3D <&gpio1 23 0>;  /* GPIO to enable video out amplifier */
> +	=20
> +	label =3D "opa362";

opa shouldn't have label property. label is meant for the
end-of-the-chain component, like the connector.

> +	 ports {

Hmm, I think there is extra space before 'ports', maybe below also.

 Tomi



--X2ieMLxDB39d4REA0BmaIGN0G23iiAGBt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUY2fuAAoJEPo9qoy8lh71pNUP/0eSYIW+IQOmh+wgPNEGQ9zl
dST/jabWPXr7FLF5e+inV6O4VMabcaB2y3tAT0trVZ9EBvU3M8KZ73Jlq86d3Tff
sbx1HI43117kppgwY24ly1LIMMbcI3rOSo6nXtRe53vKYM5/AZwK1za7/p53+11P
7U07JvB+FRn2QqfqjmI2gxARM3EVOJE7Pd+KpPO+9A+OVUWaX6Za1waSZ/FEp42Q
en7rwWCT6b4MoH12Hou96wxh290D3vraodP/prHkuHcfko0DMecouad7Br3L0uHt
yNt8eMSdUBFb8TMw1cgaYkMJVg70cJ1QcXWJdaaZkAAz1V5GSOnLEQRdspLTew7j
8gLUHCKdpqBIsKurFQWXt6XrOJ5+Y+vXAmDZdldlIKkI2WUswIzINCphz0wUK1Fz
79XzAsGZZjmyWJXc+AwX0v/Yhv77vDyKV07GEtcaFcEovYQmjJ/vZ2N2oj7j/dBa
zKTHpGeQlGdzhBUqf2gUxgvnNn7P6uJ7jfAud+Onn5Kc+mRmPcVUxMEhLb5uhGgo
kQo3srQhaO4/uqvpndIajXDF6x7QXfQL0EfxQ/TG03KAzmlYrat2rhhv7OBePj+7
6akNz+p3KKwrI7HcCjPNWGVKeRUxHrKF1KPewwHuM6m76fHNY2iKqpcdd6gQnz/j
YKeUkU1qk7zSDO29d911
=JojM
-----END PGP SIGNATURE-----

--X2ieMLxDB39d4REA0BmaIGN0G23iiAGBt--
