Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab3FRUQ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:16:58 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50065 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932861Ab3FRUQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:16:57 -0400
Message-ID: <51C0C014.2000402@ti.com>
Date: Tue, 18 Jun 2013 16:16:20 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vz?= =?UTF-8?B?c29u?= <b-cousson@ti.com>
CC: <tony@atomide.com>, <grant.likely@linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/6] arm: dts: add bandgap entry for OMAP4460 devices
References: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com> <1370637968-23299-5-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1370637968-23299-5-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2EGWVGQWNWKXECIBWKDIG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2EGWVGQWNWKXECIBWKDIG
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Benoit

On 07-06-2013 16:46, Eduardo Valentin wrote:
> Include bandgap devices for OMAP4460 devices.
>=20
> Cc: "Beno=C3=AEt Cousson" <b-cousson@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: linux-omap@vger.kernel.org
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
> ---

Could you please have a look on patch 3 and 4 of this series? I have
changed this one accordingly to your recommendation on v2. If nothing
else, please let me know if they can still be queued for 3.11.

I would need to rebase patch 01 to refresh on top of the thermal tree.

Thanks.

>  arch/arm/boot/dts/omap4460.dtsi | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/omap4460.dtsi b/arch/arm/boot/dts/omap44=
60.dtsi
> index 2cf227c..ea97201 100644
> --- a/arch/arm/boot/dts/omap4460.dtsi
> +++ b/arch/arm/boot/dts/omap4460.dtsi
> @@ -29,4 +29,13 @@
>  			     <0 55 0x4>;
>  		ti,hwmods =3D "debugss";
>  	};
> +
> +	bandgap {
> +		reg =3D <0x4a002260 0x4
> +			0x4a00232C 0x4
> +			0x4a002378 0x18>;
> +		compatible =3D "ti,omap4460-bandgap";
> +		interrupts =3D <0 126 4>; /* talert */
> +		gpios =3D <&gpio3 22 0>; /* tshut */
> +	};
>  };
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2EGWVGQWNWKXECIBWKDIG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHAwBQACgkQCXcVR3XQvP0BJwD+Mx5tt0vnYlm2Bb08tk+iKoHn
Q3seGGl2L1Ux6ExQh2ABAOB0gY8FbCOqomDjdGkSTlGRjliTdSTETdKSDlHDSHnn
=LASY
-----END PGP SIGNATURE-----

------enig2EGWVGQWNWKXECIBWKDIG--
