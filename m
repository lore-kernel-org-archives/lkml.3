Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965008Ab3FTCiB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:38:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55074 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935506Ab3FTCh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:37:59 -0400
Message-ID: <51C26AFB.20401@ti.com>
Date: Wed, 19 Jun 2013 22:37:47 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V6 29/30] ARM: dts: Add device tree node for exynos5440
 TMU controller
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-30-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-30-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2CLAHIQLOVAQTJBJNSRWU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2CLAHIQLOVAQTJBJNSRWU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> This patch adds device node for TMU controller. There are 3
> instances of the controllers so 3 nodes are created.
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>

Reviewed-by: Eduardo Valentin <eduardo.valentin@ti.com>

> ---
>  arch/arm/boot/dts/exynos5440.dtsi |   30 +++++++++++++++++++++++++++++=
+
>  1 files changed, 30 insertions(+), 0 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/exynos5440.dtsi b/arch/arm/boot/dts/exyn=
os5440.dtsi
> index f6b1c89..716e90c 100644
> --- a/arch/arm/boot/dts/exynos5440.dtsi
> +++ b/arch/arm/boot/dts/exynos5440.dtsi
> @@ -16,6 +16,12 @@
> =20
>  	interrupt-parent =3D <&gic>;
> =20
> +	aliases {
> +		tmuctrl0 =3D &tmuctrl_0;
> +		tmuctrl1 =3D &tmuctrl_1;
> +		tmuctrl2 =3D &tmuctrl_2;
> +	};
> +
>  	clock: clock-controller@0x160000 {
>  		compatible =3D "samsung,exynos5440-clock";
>  		reg =3D <0x160000 0x1000>;
> @@ -216,4 +222,28 @@
>  		clock-names =3D "rtc";
>  		status =3D "disabled";
>  	};
> +
> +	tmuctrl_0: tmuctrl@160118 {
> +		compatible =3D "samsung,exynos5440-tmu";
> +		reg =3D <0x160118 0x230>, <0x160368 0x10>;
> +		interrupts =3D <0 58 0>;
> +		clocks =3D <&clock 21>;
> +		clock-names =3D "tmu_apbif";
> +	};
> +
> +	tmuctrl_1: tmuctrl@16011C {
> +		compatible =3D "samsung,exynos5440-tmu";
> +		reg =3D <0x16011C 0x230>, <0x160368 0x10>;
> +		interrupts =3D <0 58 0>;
> +		clocks =3D <&clock 21>;
> +		clock-names =3D "tmu_apbif";
> +	};
> +
> +	tmuctrl_2: tmuctrl@160120 {
> +		compatible =3D "samsung,exynos5440-tmu";
> +		reg =3D <0x160120 0x230>, <0x160368 0x10>;
> +		interrupts =3D <0 58 0>;
> +		clocks =3D <&clock 21>;
> +		clock-names =3D "tmu_apbif";
> +	};
>  };
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2CLAHIQLOVAQTJBJNSRWU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCavsACgkQCXcVR3XQvP1oWAD/dXQOKsEP7lAzXPzdoUAkiD+/
28uYZ/WCVP6QKfN9/pYBAN44Zf1OzdEJ+og5SOP/nPoNEbbc4hdvrZqyDuZWqP3M
=e4he
-----END PGP SIGNATURE-----

------enig2CLAHIQLOVAQTJBJNSRWU--
