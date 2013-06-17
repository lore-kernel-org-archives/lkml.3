Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab3FQDFr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:05:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33619 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab3FQDFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:05:46 -0400
Message-ID: <51BE7CFB.6020008@ti.com>
Date: Sun, 16 Jun 2013 23:05:31 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
CC: <linux-pm@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <amit.kachhap@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        <jonghwa3.lee@samsung.com>
Subject: Re: [PATCH V5 02/30] thermal: exynos: Add ARCH_HAS_TMU config to
 know the supported soc's
References: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com> <1370955220-2949-3-git-send-email-amit.daniel@samsung.com>
In-Reply-To: <1370955220-2949-3-git-send-email-amit.daniel@samsung.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2WXGDDBRSFUMEOPULOTXF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2WXGDDBRSFUMEOPULOTXF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hey Amit,

On 11-06-2013 08:53, Amit Daniel Kachhap wrote:
> This patch adds config sybmol ARCH_HAS_TMU to enable the TMU driver.
> This will allow adding support for new soc easily as now it is the
> platform responsibility to enable this config symbol.
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
> ---
>  drivers/thermal/samsung/Kconfig |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/=
Kconfig
> index 2d3d9dc..145a55d 100644
> --- a/drivers/thermal/samsung/Kconfig
> +++ b/drivers/thermal/samsung/Kconfig
> @@ -1,6 +1,9 @@
> +config ARCH_HAS_TMU
> +	bool
> +
>  config EXYNOS_THERMAL
>  	tristate "Temperature sensor on Samsung EXYNOS"
> -	depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
> +	depends on ARCH_HAS_TMU

I would rather use ARCH_HAS_BANDGAP as discussed and agreed during your
v4 review. I managed push this patch through RMK's system:
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=3D7758/1

>  	depends on CPU_THERMAL
>  	help
>  	  If you say yes here you get support for TMU (Thermal Management
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2WXGDDBRSFUMEOPULOTXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlG+fPsACgkQCXcVR3XQvP1WzwEAmtlAswHrz46LPK6MIo/e9vs8
chXTAUh0g5SQwQLFWDgA/1NpiPYjyzJEchEyIN2zJcYAKdjdNx1V80kIk3kN2cO4
=+DOd
-----END PGP SIGNATURE-----

------enig2WXGDDBRSFUMEOPULOTXF--
