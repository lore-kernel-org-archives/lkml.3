Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaICMFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:05:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43311 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaICMFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:05:16 -0400
Date: Wed, 3 Sep 2014 14:05:11 +0200
From: Markus Pargmann <mpa@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, Alexander Shiyan <shc_work@mail.ru>,
        Shawn Guo <shawn.guo@linaro.org>, Anson Huang <b20788@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Denis Carikli <denis@eukrea.com>, Greg Ungerer <gerg@uclinux.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] pinctrl: imx/mxs: move freescale drivers to subdir
Message-ID: <20140903120511.GA6260@pengutronix.de>
References: <1409744538-21827-1-git-send-email-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <1409744538-21827-1-git-send-email-linus.walleij@linaro.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:02:36 up 18 days, 22 min, 75 users,  load average: 0.01, 0.05,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 03, 2014 at 01:42:18PM +0200, Linus Walleij wrote:
> This moves all the Freescale-related drivers (i.MX and MXS) to
> its own subdirectory to clear the view.
>=20
> Cc: Alexander Shiyan <shc_work@mail.ru>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Anson Huang <b20788@freescale.com>
> Cc: Fabio Estevam <fabio.estevam@freescale.com>
> Cc: Denis Carikli <denis@eukrea.com>
> Cc: Markus Pargmann <mpa@pengutronix.de>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/pinctrl/Kconfig                            | 110 +--------------=
------

You are removing all Kconfig symbols in this file, but the new Kconfig
file in the freescale subdirectory seems to be missing in this patch.

Best Regards,

Markus

>  drivers/pinctrl/Makefile                           |  19 +---
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx.c      |   2 +-
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx.h      |   0
>  .../pinctrl/{ =3D> freescale}/pinctrl-imx1-core.c    |   2 +-
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx1.c     |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx1.h     |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx21.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx23.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx25.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx27.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx28.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx35.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx50.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx51.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx53.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx6dl.c   |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx6q.c    |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx6sl.c   |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-imx6sx.c   |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-mxs.c      |   2 +-
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-mxs.h      |   0
>  drivers/pinctrl/{ =3D> freescale}/pinctrl-vf610.c    |   0
>  23 files changed, 5 insertions(+), 130 deletions(-)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx.c (99%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx.h (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx1-core.c (99%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx1.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx1.h (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx21.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx23.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx25.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx27.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx28.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx35.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx50.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx51.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx53.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx6dl.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx6q.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx6sl.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-imx6sx.c (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-mxs.c (99%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-mxs.h (100%)
>  rename drivers/pinctrl/{ =3D> freescale}/pinctrl-vf610.c (100%)
>=20
> diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
> index e1c5a87c80cd..64d06b52f98a 100644
> --- a/drivers/pinctrl/Kconfig
> +++ b/drivers/pinctrl/Kconfig
> @@ -97,102 +97,6 @@ config PINCTRL_BCM281XX
>  	  BCM28145, and BCM28155 SoCs.  This driver requires the pinctrl
>  	  framework.  GPIO is provided by a separate GPIO driver.
> =20
> -config PINCTRL_IMX
> -	bool
> -	select PINMUX
> -	select PINCONF
> -
> -config PINCTRL_IMX1_CORE
> -	bool
> -	select PINMUX
> -	select PINCONF
> -
> -config PINCTRL_IMX1
> -	bool "IMX1 pinctrl driver"
> -	depends on SOC_IMX1
> -	select PINCTRL_IMX1_CORE
> -	help
> -	  Say Y here to enable the imx1 pinctrl driver
> -
> -config PINCTRL_IMX21
> -	bool "i.MX21 pinctrl driver"
> -	depends on SOC_IMX21
> -	select PINCTRL_IMX1_CORE
> -	help
> -	  Say Y here to enable the i.MX21 pinctrl driver
> -
> -config PINCTRL_IMX27
> -	bool "IMX27 pinctrl driver"
> -	depends on SOC_IMX27
> -	select PINCTRL_IMX1_CORE
> -	help
> -	  Say Y here to enable the imx27 pinctrl driver
> -
> -
> -config PINCTRL_IMX25
> -        bool "IMX25 pinctrl driver"
> -        depends on OF
> -        depends on SOC_IMX25
> -        select PINCTRL_IMX
> -        help
> -          Say Y here to enable the imx25 pinctrl driver
> -
> -config PINCTRL_IMX35
> -	bool "IMX35 pinctrl driver"
> -	depends on SOC_IMX35
> -	select PINCTRL_IMX
> -	help
> -	  Say Y here to enable the imx35 pinctrl driver
> -
> -config PINCTRL_IMX50
> -	bool "IMX50 pinctrl driver"
> -	depends on SOC_IMX50
> -	select PINCTRL_IMX
> -	help
> -	  Say Y here to enable the imx50 pinctrl driver
> -
> -config PINCTRL_IMX51
> -	bool "IMX51 pinctrl driver"
> -	depends on SOC_IMX51
> -	select PINCTRL_IMX
> -	help
> -	  Say Y here to enable the imx51 pinctrl driver
> -
> -config PINCTRL_IMX53
> -	bool "IMX53 pinctrl driver"
> -	depends on SOC_IMX53
> -	select PINCTRL_IMX
> -	help
> -	  Say Y here to enable the imx53 pinctrl driver
> -
> -config PINCTRL_IMX6Q
> -	bool "IMX6Q/DL pinctrl driver"
> -	depends on SOC_IMX6Q
> -	select PINCTRL_IMX
> -	help
> -	  Say Y here to enable the imx6q/dl pinctrl driver
> -
> -config PINCTRL_IMX6SL
> -	bool "IMX6SL pinctrl driver"
> -	depends on SOC_IMX6SL
> -	select PINCTRL_IMX
> -	help
> -	  Say Y here to enable the imx6sl pinctrl driver
> -
> -config PINCTRL_IMX6SX
> -	bool "IMX6SX pinctrl driver"
> -	depends on SOC_IMX6SX
> -	select PINCTRL_IMX
> -	help
> -	  Say Y here to enable the imx6sx pinctrl driver
> -
> -config PINCTRL_VF610
> -	bool "Freescale Vybrid VF610 pinctrl driver"
> -	depends on SOC_VF610
> -	select PINCTRL_IMX
> -	help
> -	  Say Y here to enable the Freescale Vybrid VF610 pinctrl driver
> -
>  config PINCTRL_LANTIQ
>  	bool
>  	depends on LANTIQ
> @@ -204,19 +108,6 @@ config PINCTRL_FALCON
>  	depends on SOC_FALCON
>  	depends on PINCTRL_LANTIQ
> =20
> -config PINCTRL_MXS
> -	bool
> -	select PINMUX
> -	select PINCONF
> -
> -config PINCTRL_IMX23
> -	bool
> -	select PINCTRL_MXS
> -
> -config PINCTRL_IMX28
> -	bool
> -	select PINCTRL_MXS
> -
>  config PINCTRL_ROCKCHIP
>  	bool
>  	select PINMUX
> @@ -313,6 +204,7 @@ config PINCTRL_PALMAS
>  	  TPS65913, TPS80036 etc.
> =20
>  source "drivers/pinctrl/berlin/Kconfig"
> +source "drivers/pinctrl/freescale/Kconfig"
>  source "drivers/pinctrl/mvebu/Kconfig"
>  source "drivers/pinctrl/nomadik/Kconfig"
>  source "drivers/pinctrl/qcom/Kconfig"
> diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile
> index 0ffe1f608c67..51f52d32859e 100644
> --- a/drivers/pinctrl/Makefile
> +++ b/drivers/pinctrl/Makefile
> @@ -17,24 +17,7 @@ obj-$(CONFIG_PINCTRL_AT91)	+=3D pinctrl-at91.o
>  obj-$(CONFIG_PINCTRL_BCM2835)	+=3D pinctrl-bcm2835.o
>  obj-$(CONFIG_PINCTRL_BAYTRAIL)	+=3D pinctrl-baytrail.o
>  obj-$(CONFIG_PINCTRL_BCM281XX)	+=3D pinctrl-bcm281xx.o
> -obj-$(CONFIG_PINCTRL_IMX)	+=3D pinctrl-imx.o
> -obj-$(CONFIG_PINCTRL_IMX1_CORE)	+=3D pinctrl-imx1-core.o
> -obj-$(CONFIG_PINCTRL_IMX1)	+=3D pinctrl-imx1.o
> -obj-$(CONFIG_PINCTRL_IMX21)	+=3D pinctrl-imx21.o
> -obj-$(CONFIG_PINCTRL_IMX27)	+=3D pinctrl-imx27.o
> -obj-$(CONFIG_PINCTRL_IMX35)	+=3D pinctrl-imx35.o
> -obj-$(CONFIG_PINCTRL_IMX50)	+=3D pinctrl-imx50.o
> -obj-$(CONFIG_PINCTRL_IMX51)	+=3D pinctrl-imx51.o
> -obj-$(CONFIG_PINCTRL_IMX53)	+=3D pinctrl-imx53.o
> -obj-$(CONFIG_PINCTRL_IMX6Q)	+=3D pinctrl-imx6q.o
> -obj-$(CONFIG_PINCTRL_IMX6Q)	+=3D pinctrl-imx6dl.o
> -obj-$(CONFIG_PINCTRL_IMX6SL)	+=3D pinctrl-imx6sl.o
> -obj-$(CONFIG_PINCTRL_IMX6SX)	+=3D pinctrl-imx6sx.o
>  obj-$(CONFIG_PINCTRL_FALCON)	+=3D pinctrl-falcon.o
> -obj-$(CONFIG_PINCTRL_MXS)	+=3D pinctrl-mxs.o
> -obj-$(CONFIG_PINCTRL_IMX23)	+=3D pinctrl-imx23.o
> -obj-$(CONFIG_PINCTRL_IMX25)	+=3D pinctrl-imx25.o
> -obj-$(CONFIG_PINCTRL_IMX28)	+=3D pinctrl-imx28.o
>  obj-$(CONFIG_PINCTRL_PALMAS)	+=3D pinctrl-palmas.o
>  obj-$(CONFIG_PINCTRL_ROCKCHIP)	+=3D pinctrl-rockchip.o
>  obj-$(CONFIG_PINCTRL_SINGLE)	+=3D pinctrl-single.o
> @@ -53,9 +36,9 @@ obj-$(CONFIG_PINCTRL_XWAY)	+=3D pinctrl-xway.o
>  obj-$(CONFIG_PINCTRL_LANTIQ)	+=3D pinctrl-lantiq.o
>  obj-$(CONFIG_PINCTRL_TB10X)	+=3D pinctrl-tb10x.o
>  obj-$(CONFIG_PINCTRL_ST) 	+=3D pinctrl-st.o
> -obj-$(CONFIG_PINCTRL_VF610)	+=3D pinctrl-vf610.o
> =20
>  obj-$(CONFIG_ARCH_BERLIN)	+=3D berlin/
> +obj-y				+=3D freescale/
>  obj-$(CONFIG_PLAT_ORION)        +=3D mvebu/
>  obj-y				+=3D nomadik/
>  obj-$(CONFIG_ARCH_QCOM)		+=3D qcom/
> diff --git a/drivers/pinctrl/pinctrl-imx.c b/drivers/pinctrl/freescale/pi=
nctrl-imx.c
> similarity index 99%
> rename from drivers/pinctrl/pinctrl-imx.c
> rename to drivers/pinctrl/freescale/pinctrl-imx.c
> index 570e5acb4a6a..e89268c09e4c 100644
> --- a/drivers/pinctrl/pinctrl-imx.c
> +++ b/drivers/pinctrl/freescale/pinctrl-imx.c
> @@ -24,7 +24,7 @@
>  #include <linux/pinctrl/pinmux.h>
>  #include <linux/slab.h>
> =20
> -#include "core.h"
> +#include "../core.h"
>  #include "pinctrl-imx.h"
> =20
>  /* The bits in CONFIG cell defined in binding doc*/
> diff --git a/drivers/pinctrl/pinctrl-imx.h b/drivers/pinctrl/freescale/pi=
nctrl-imx.h
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx.h
> rename to drivers/pinctrl/freescale/pinctrl-imx.h
> diff --git a/drivers/pinctrl/pinctrl-imx1-core.c b/drivers/pinctrl/freesc=
ale/pinctrl-imx1-core.c
> similarity index 99%
> rename from drivers/pinctrl/pinctrl-imx1-core.c
> rename to drivers/pinctrl/freescale/pinctrl-imx1-core.c
> index 176a3e62f1cf..5ac59fbb2440 100644
> --- a/drivers/pinctrl/pinctrl-imx1-core.c
> +++ b/drivers/pinctrl/freescale/pinctrl-imx1-core.c
> @@ -28,7 +28,7 @@
>  #include <linux/pinctrl/pinmux.h>
>  #include <linux/slab.h>
> =20
> -#include "core.h"
> +#include "../core.h"
>  #include "pinctrl-imx1.h"
> =20
>  struct imx1_pinctrl {
> diff --git a/drivers/pinctrl/pinctrl-imx1.c b/drivers/pinctrl/freescale/p=
inctrl-imx1.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx1.c
> rename to drivers/pinctrl/freescale/pinctrl-imx1.c
> diff --git a/drivers/pinctrl/pinctrl-imx1.h b/drivers/pinctrl/freescale/p=
inctrl-imx1.h
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx1.h
> rename to drivers/pinctrl/freescale/pinctrl-imx1.h
> diff --git a/drivers/pinctrl/pinctrl-imx21.c b/drivers/pinctrl/freescale/=
pinctrl-imx21.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx21.c
> rename to drivers/pinctrl/freescale/pinctrl-imx21.c
> diff --git a/drivers/pinctrl/pinctrl-imx23.c b/drivers/pinctrl/freescale/=
pinctrl-imx23.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx23.c
> rename to drivers/pinctrl/freescale/pinctrl-imx23.c
> diff --git a/drivers/pinctrl/pinctrl-imx25.c b/drivers/pinctrl/freescale/=
pinctrl-imx25.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx25.c
> rename to drivers/pinctrl/freescale/pinctrl-imx25.c
> diff --git a/drivers/pinctrl/pinctrl-imx27.c b/drivers/pinctrl/freescale/=
pinctrl-imx27.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx27.c
> rename to drivers/pinctrl/freescale/pinctrl-imx27.c
> diff --git a/drivers/pinctrl/pinctrl-imx28.c b/drivers/pinctrl/freescale/=
pinctrl-imx28.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx28.c
> rename to drivers/pinctrl/freescale/pinctrl-imx28.c
> diff --git a/drivers/pinctrl/pinctrl-imx35.c b/drivers/pinctrl/freescale/=
pinctrl-imx35.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx35.c
> rename to drivers/pinctrl/freescale/pinctrl-imx35.c
> diff --git a/drivers/pinctrl/pinctrl-imx50.c b/drivers/pinctrl/freescale/=
pinctrl-imx50.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx50.c
> rename to drivers/pinctrl/freescale/pinctrl-imx50.c
> diff --git a/drivers/pinctrl/pinctrl-imx51.c b/drivers/pinctrl/freescale/=
pinctrl-imx51.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx51.c
> rename to drivers/pinctrl/freescale/pinctrl-imx51.c
> diff --git a/drivers/pinctrl/pinctrl-imx53.c b/drivers/pinctrl/freescale/=
pinctrl-imx53.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx53.c
> rename to drivers/pinctrl/freescale/pinctrl-imx53.c
> diff --git a/drivers/pinctrl/pinctrl-imx6dl.c b/drivers/pinctrl/freescale=
/pinctrl-imx6dl.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx6dl.c
> rename to drivers/pinctrl/freescale/pinctrl-imx6dl.c
> diff --git a/drivers/pinctrl/pinctrl-imx6q.c b/drivers/pinctrl/freescale/=
pinctrl-imx6q.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx6q.c
> rename to drivers/pinctrl/freescale/pinctrl-imx6q.c
> diff --git a/drivers/pinctrl/pinctrl-imx6sl.c b/drivers/pinctrl/freescale=
/pinctrl-imx6sl.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx6sl.c
> rename to drivers/pinctrl/freescale/pinctrl-imx6sl.c
> diff --git a/drivers/pinctrl/pinctrl-imx6sx.c b/drivers/pinctrl/freescale=
/pinctrl-imx6sx.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-imx6sx.c
> rename to drivers/pinctrl/freescale/pinctrl-imx6sx.c
> diff --git a/drivers/pinctrl/pinctrl-mxs.c b/drivers/pinctrl/freescale/pi=
nctrl-mxs.c
> similarity index 99%
> rename from drivers/pinctrl/pinctrl-mxs.c
> rename to drivers/pinctrl/freescale/pinctrl-mxs.c
> index 67035091f8fd..f98c6bb0f769 100644
> --- a/drivers/pinctrl/pinctrl-mxs.c
> +++ b/drivers/pinctrl/freescale/pinctrl-mxs.c
> @@ -21,7 +21,7 @@
>  #include <linux/pinctrl/pinmux.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
> -#include "core.h"
> +#include "../core.h"
>  #include "pinctrl-mxs.h"
> =20
>  #define SUFFIX_LEN	4
> diff --git a/drivers/pinctrl/pinctrl-mxs.h b/drivers/pinctrl/freescale/pi=
nctrl-mxs.h
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-mxs.h
> rename to drivers/pinctrl/freescale/pinctrl-mxs.h
> diff --git a/drivers/pinctrl/pinctrl-vf610.c b/drivers/pinctrl/freescale/=
pinctrl-vf610.c
> similarity index 100%
> rename from drivers/pinctrl/pinctrl-vf610.c
> rename to drivers/pinctrl/freescale/pinctrl-vf610.c
> --=20
> 1.9.3
>=20
>=20

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUBwP3AAoJEEpcgKtcEGQQsUgP/i9p+JRSwjOcYlavH6hXp9j0
9X5eL5qBnmSxzxGZFV7UOlRGoRfgrszn1WHH88KoppBuMzksSLRT7wNtDOpLofXe
dCr30KgVIvatxtHWOuW6nyI0UQt3Ddr7pbUyf1eXciSrXJQX6on5YIuLPhACcL6X
IIVMltrpHawzkYJ9At4BS2NBfb+sjaWhEagCa+Ou5RuonsZpaGcqRwqlXsujapXz
s6Yg1esBKk7ZIuG2XDuAOlbfOL+FbrNF9MAZ6+5t9LnTlgmLf6HOhiImx9oLR32X
m2kBbO4kkWx/sB1EONkfXC3JGUB9HZAL5l3U/jWPJxfeHfW7OGNfcGv7a0Gzu6Pr
rNpvhNEhF+T5ypiyHuYfBfCer3+Zh5CL9ruGtARbAsdqEeBeoH52wgY5uOUZLy+h
S5dGxpQnD4fFbSe1D/yuV++E6lQNFNdvu2WJL9mz3FZ1MoKfbRASo64BIa/n43tA
CWzmvDizQiKFtdUDIGU5eC5+RhGMjIkaANaIFjoscGZn26E++BawK2W57dH17THl
OSusaVIUGdE8WQ2w+mpIVEEcJXbNATnDxh1jhahf7RFf6HWu7J5dF0jtxB4mOVKM
j62JwiLecKv/d4w9dIJccSXnyCgY5ak2V3+8Wdy1q242Yw9hlZ1dHPiVlvRoynOT
hC74H1SbKYY1n+8DmeH7
=IxOb
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
