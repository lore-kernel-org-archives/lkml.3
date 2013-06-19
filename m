Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951Ab3FSXp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 19:45:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34412 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934170Ab3FSXp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 19:45:26 -0400
Message-ID: <51C2428C.4070102@ti.com>
Date: Wed, 19 Jun 2013 19:45:16 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>, Lukasz Majewski <l.majewski@samsung.com>
Subject: Re: [PATCH V6 21/30] ARM: dts: thermal: exynos4: Add documentation
 for Exynos SoC thermal bindings
References: <1371451599-31035-1-git-send-email-amit.daniel@samsung.com> <1371451599-31035-22-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1371451599-31035-22-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2SVIKFRVXOPUXLFBAPXGR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2SVIKFRVXOPUXLFBAPXGR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 17-06-2013 02:46, Amit Daniel Kachhap wrote:
> From: Lukasz Majewski <l.majewski@samsung.com>
>=20
> Proper description for Exynos4 bindings added to Documentation/devicetr=
ee/
> bindings
>=20
> Acked-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  .../devicetree/bindings/thermal/exynos-thermal.txt |   25 ++++++++++++=
++++++++
>  1 files changed, 25 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/thermal/exynos-th=
ermal.txt
>=20
> diff --git a/Documentation/devicetree/bindings/thermal/exynos-thermal.t=
xt b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> new file mode 100644
> index 0000000..535fd0e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/thermal/exynos-thermal.txt
> @@ -0,0 +1,25 @@
> +* Exynos Thermal Management Unit (TMU)
> +
> +** Required properties:
> +
> +- compatible : One of the following:
> +	       "samsung,exynos4412-tmu"
> +	       "samsung,exynos4210-tmu"
> +	       "samsung,exynos5250-tmu"
> +- interrupt-parent : The phandle for the interrupt controller
> +- reg : Address range of the thermal registers
> +- interrupts : Should contain interrupt for thermal system
> +- clocks : The main clock for TMU device
> +- clock-names : Thermal system clock name

Should this include the documentation on the alias needed by patch 18?
tmuctrl?


> +
> +Example:
> +
> +	tmu@100C0000 {
> +		compatible =3D "samsung,exynos4412-tmu";
> +		interrupt-parent =3D <&combiner>;
> +		reg =3D <0x100C0000 0x100>;
> +		interrupts =3D <2 4>;
> +		clocks =3D <&clock 383>;
> +		clock-names =3D "tmu_apbif";
> +		status =3D "disabled";
> +	};
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2SVIKFRVXOPUXLFBAPXGR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHCQowACgkQCXcVR3XQvP2nHQD/do1AGK94lCHqjs+H7jbf5RU8
YGPgYR2+eaEB9lyjXZUA/3ghhs7cbuJRLxGw6CS3PEMZFRxRrISAIMpRnUDQiCfl
=iyHB
-----END PGP SIGNATURE-----

------enig2SVIKFRVXOPUXLFBAPXGR--
