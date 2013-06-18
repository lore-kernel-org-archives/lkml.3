Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab3FRU2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 16:28:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60956 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab3FRU2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 16:28:06 -0400
Message-ID: <51C0C2A8.4020707@ti.com>
Date: Tue, 18 Jun 2013 16:27:20 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>, <tony@atomide.com>
CC: <grant.likely@linaro.org>, <linux-pm@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 5/6] arm: omap2plus_defconfig: enable TI bandgap driver
References: <1370637968-23299-1-git-send-email-eduardo.valentin@ti.com> <1370637968-23299-6-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1370637968-23299-6-git-send-email-eduardo.valentin@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2JDWEHRDWOWSIBGCLRKPE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2JDWEHRDWOWSIBGCLRKPE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Tony,

On 07-06-2013 16:46, Eduardo Valentin wrote:
> Enable the bandgap driver for TI SoCs thermal support.
>=20
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Cc: AnilKumar Ch <anilkumar@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

Is it possible for you to queue this one and patch 6 for 3.11?

Cheers,

> ---
>  arch/arm/configs/omap2plus_defconfig | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>=20
> diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/om=
ap2plus_defconfig
> index c1ef64b..6e6c494 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -151,6 +151,13 @@ CONFIG_W1=3Dy
>  CONFIG_POWER_SUPPLY=3Dy
>  CONFIG_SENSORS_LM75=3Dm
>  CONFIG_WATCHDOG=3Dy
> +CONFIG_THERMAL=3Dy
> +CONFIG_THERMAL_HWMON=3Dy
> +CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=3Dy
> +CONFIG_THERMAL_GOV_FAIR_SHARE=3Dy
> +CONFIG_THERMAL_GOV_STEP_WISE=3Dy
> +CONFIG_THERMAL_GOV_USER_SPACE=3Dy
> +CONFIG_CPU_THERMAL=3Dy
>  CONFIG_OMAP_WATCHDOG=3Dy
>  CONFIG_TWL4030_WATCHDOG=3Dy
>  CONFIG_MFD_TPS65217=3Dy
> @@ -237,6 +244,10 @@ CONFIG_RTC_DRV_TWL4030=3Dy
>  CONFIG_RTC_DRV_OMAP=3Dy
>  CONFIG_DMADEVICES=3Dy
>  CONFIG_DMA_OMAP=3Dy
> +CONFIG_TI_SOC_THERMAL=3Dy
> +CONFIG_TI_THERMAL=3Dy
> +CONFIG_OMAP4_THERMAL=3Dy
> +CONFIG_OMAP5_THERMAL=3Dy
>  CONFIG_EXT2_FS=3Dy
>  CONFIG_EXT3_FS=3Dy
>  # CONFIG_EXT3_FS_XATTR is not set
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2JDWEHRDWOWSIBGCLRKPE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlHAwqgACgkQCXcVR3XQvP1prgD9GqsZJ9CVhGHgsx+niT+6bd+1
Elxfawr0Ow1oJTUroJ8A/2FIirb7G99qOruls6w8FIY6rsDuXB3Pso/jN6rdptlm
=HGZt
-----END PGP SIGNATURE-----

------enig2JDWEHRDWOWSIBGCLRKPE--
