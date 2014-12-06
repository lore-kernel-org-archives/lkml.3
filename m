Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaLFDFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 22:05:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:58802 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaLFDFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 22:05:46 -0500
Date: Fri, 5 Dec 2014 21:05:20 -0600
From: Felipe Balbi <balbi@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>, Tejun Heo <tj@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lu@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH] PM / Kconfig: Replace PM_RUNTIME with PM in dependencies
Message-ID: <20141206030520.GA16151@saruman>
Reply-To: <balbi@ti.com>
References: <1710744.OD8H2BOPgr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <1710744.OD8H2BOPgr@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 06, 2014 at 03:54:35AM +0100, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>=20
> After commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if PM_SLEEP is
> selected) PM_RUNTIME is always set if PM is set, so Kconfig options
> depending on CONFIG_PM_RUNTIME may now be changed to depend on
> CONFIG_PM.
>=20
> Replace PM_RUNTIME with PM in Kconfig dependencies throughout the
> tree.
>=20
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

for drivers/usb/phy:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>=20
> Note: This depends on commit b2b49ccbdd54 (PM: Kconfig: Set PM_RUNTIME if
> PM_SLEEP is selected) which is only in linux-next at the moment (via the
> linux-pm tree).
>=20
> Please let me know if it is OK to take this one into linux-pm.
>=20
> ---
>  arch/arm/mach-exynos/Kconfig          |    2 +-
>  arch/ia64/Kconfig                     |    2 +-
>  drivers/ata/Kconfig                   |    2 +-
>  drivers/media/platform/Kconfig        |    2 +-
>  drivers/media/platform/s5p-tv/Kconfig |    2 +-
>  drivers/staging/gdm72xx/Kconfig       |    2 +-
>  drivers/usb/core/Kconfig              |    2 +-
>  drivers/usb/phy/Kconfig               |    4 ++--
>  drivers/usb/storage/Kconfig           |    2 +-
>  9 files changed, 10 insertions(+), 10 deletions(-)
>=20
> Index: linux-pm/arch/arm/mach-exynos/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/arch/arm/mach-exynos/Kconfig
> +++ linux-pm/arch/arm/mach-exynos/Kconfig
> @@ -21,7 +21,7 @@ menuconfig ARCH_EXYNOS
>  	select HAVE_S3C_RTC if RTC_CLASS
>  	select PINCTRL
>  	select PINCTRL_EXYNOS
> -	select PM_GENERIC_DOMAINS if PM_RUNTIME
> +	select PM_GENERIC_DOMAINS if PM
>  	select S5P_DEV_MFC
>  	select SRAM
>  	help
> Index: linux-pm/arch/ia64/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/arch/ia64/Kconfig
> +++ linux-pm/arch/ia64/Kconfig
> @@ -232,7 +232,7 @@ config IA64_SGI_UV
>  config IA64_HP_SIM
>  	bool "Ski-simulator"
>  	select SWIOTLB
> -	depends on !PM_RUNTIME
> +	depends on !PM
> =20
>  endchoice
> =20
> Index: linux-pm/drivers/ata/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/ata/Kconfig
> +++ linux-pm/drivers/ata/Kconfig
> @@ -61,7 +61,7 @@ config ATA_ACPI
> =20
>  config SATA_ZPODD
>  	bool "SATA Zero Power Optical Disc Drive (ZPODD) support"
> -	depends on ATA_ACPI && PM_RUNTIME
> +	depends on ATA_ACPI && PM
>  	default n
>  	help
>  	  This option adds support for SATA Zero Power Optical Disc
> Index: linux-pm/drivers/media/platform/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/media/platform/Kconfig
> +++ linux-pm/drivers/media/platform/Kconfig
> @@ -112,7 +112,7 @@ config VIDEO_OMAP3_DEBUG
>  config VIDEO_S3C_CAMIF
>  	tristate "Samsung S3C24XX/S3C64XX SoC Camera Interface driver"
>  	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
> -	depends on PM_RUNTIME
> +	depends on PM
>  	depends on ARCH_S3C64XX || PLAT_S3C24XX || COMPILE_TEST
>  	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
> Index: linux-pm/drivers/media/platform/s5p-tv/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/media/platform/s5p-tv/Kconfig
> +++ linux-pm/drivers/media/platform/s5p-tv/Kconfig
> @@ -8,7 +8,7 @@
> =20
>  config VIDEO_SAMSUNG_S5P_TV
>  	bool "Samsung TV driver for S5P platform"
> -	depends on PM_RUNTIME
> +	depends on PM
>  	depends on ARCH_S5PV210 || ARCH_EXYNOS || COMPILE_TEST
>  	default n
>  	---help---
> Index: linux-pm/drivers/staging/gdm72xx/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/staging/gdm72xx/Kconfig
> +++ linux-pm/drivers/staging/gdm72xx/Kconfig
> @@ -53,7 +53,7 @@ if WIMAX_GDM72XX_USB
> =20
>  config WIMAX_GDM72XX_USB_PM
>  	bool "Enable power management support"
> -	depends on PM_RUNTIME
> +	depends on PM
>  	help
>  	  Enable USB power management in order to reduce power consumption
>  	  while the interface is not in use.
> Index: linux-pm/drivers/usb/core/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/usb/core/Kconfig
> +++ linux-pm/drivers/usb/core/Kconfig
> @@ -43,7 +43,7 @@ config USB_DYNAMIC_MINORS
> =20
>  config USB_OTG
>  	bool "OTG support"
> -	depends on PM_RUNTIME
> +	depends on PM
>  	default n
>  	help
>  	  The most notable feature of USB OTG is support for a
> Index: linux-pm/drivers/usb/phy/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/usb/phy/Kconfig
> +++ linux-pm/drivers/usb/phy/Kconfig
> @@ -20,7 +20,7 @@ config AB8500_USB
> =20
>  config FSL_USB2_OTG
>  	bool "Freescale USB OTG Transceiver Driver"
> -	depends on USB_EHCI_FSL && USB_FSL_USB2 && USB_OTG_FSM && PM_RUNTIME
> +	depends on USB_EHCI_FSL && USB_FSL_USB2 && USB_OTG_FSM && PM
>  	select USB_OTG
>  	select USB_PHY
>  	help
> @@ -153,7 +153,7 @@ config USB_MSM_OTG
> =20
>  config USB_MV_OTG
>  	tristate "Marvell USB OTG support"
> -	depends on USB_EHCI_MV && USB_MV_UDC && PM_RUNTIME
> +	depends on USB_EHCI_MV && USB_MV_UDC && PM
>  	select USB_OTG
>  	select USB_PHY
>  	help
> Index: linux-pm/drivers/usb/storage/Kconfig
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-pm.orig/drivers/usb/storage/Kconfig
> +++ linux-pm/drivers/usb/storage/Kconfig
> @@ -41,7 +41,7 @@ config USB_STORAGE_REALTEK
> =20
>  config REALTEK_AUTOPM
>  	bool "Realtek Card Reader autosuspend support"
> -	depends on USB_STORAGE_REALTEK && PM_RUNTIME
> +	depends on USB_STORAGE_REALTEK && PM
>  	default y
> =20
>  config USB_STORAGE_DATAFAB
>=20

--=20
balbi

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUgnJwAAoJEIaOsuA1yqREtUMP/Rr93bB+fqYfXtlg8Tg0u6MA
0xeTNGaQ6kIJvueu4I1PWqRzEwlKhrdFjJlcdJPoeYANbgKr08sS87niBM8L1yHR
Ey6MRiFC7uSsvqit7EjvGi/s8sUDjfRCcBo0XFBQ+iDh6N+e1hxa0dR23faBQx3x
8hZVowOf/c2gSdNG1S63jtN9DcdM2qU9DKVS4+HpkXFdK7dooCK6UeZrTBSEETQO
EvlOsPsyNsO3DFgclmk9KWZGKMn9FTLer6do81M3D7f03+e5hqUlmdb7m/tR4VxB
/5/617KrNT5u1yDDyXpjMGFW5+IYqeGWZ0wJOmXvg5n/U8gVSPkTDPHYlJR/htHZ
jYPLHgMSXD4Tf6WmWDXAvn1gJjTlHtgIzwVpT4aYrb9tb6xLuthm4IbtMySDQMDO
iQ1U55X3S/7V/yGNFduvzyg89QxHWlOAGYie38ZxDbCr/DxZzjO9Ag4bNf2cg7Oq
2KoD0FtxuQkrtYuPmmzQ2CDZh6Z/RwFBTCu7tskvOqTzkbsNqtwnUzU/Ty0u9cHQ
JNuO/EjC0fH8C6ZPc2C/W3ZjqUFYp94w2VvfMUzbnh4XgbTP7ROhipQEVu+FAYFE
mDywiCg63BxBzbGOBdtEGpYqUHkKHrjnBf9/Q2U8HQ64O0AvS0BkXA8iCuweNLYw
694SjLwpEccxe/Q1t1xV
=2pVb
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
