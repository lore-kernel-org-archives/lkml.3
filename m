Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3JARsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:48:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61339 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab3JARsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:48:10 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-d1-524b0ad8ffeb
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
Cc: linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Heiko Stuebner <heiko@sntech.de>,
        Naour Romain <romain.naour@openwide.fr>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Tarek Dakhran <t.dakhran@samsung.com>
Subject: Re: [PATCH 6/6] ARM: smdk5410_defconfig: add defconfig for smdk5410
Date: Tue, 01 Oct 2013 19:48:04 +0200
Message-id: <1556357.Ys4C5Q5WGD@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-52-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1380644227-12244-7-git-send-email-v.tyrtov@samsung.com>
References: <1380644227-12244-1-git-send-email-v.tyrtov@samsung.com>
 <1380644227-12244-7-git-send-email-v.tyrtov@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jAd0bXN5BBltbRC0mrTvAZDHvs6zF
	/CPnWC3+P3rNanHu1UpGi94FV9ksNj2+xmqxsG0Ji8XlXXPYLGac38dkcfsyr8XS6xeZLJ5O
	uMhmMWH6WhaLwyuAZqx7OZ3FYsvPDkaLVwfbWCzWPz/FaLF501Rmi6kzfrA7iHqsmbeG0aOl
	uYfNY8HnK+wef1e9YPZYufwLm8er1TNZPe5c28Pm8e7cOXaPzUvqPV5dY/Ho27KK0WP7tXnM
	Hp83yXlsnBsawBfFZZOSmpNZllqkb5fAldF89w5zwVa1ipcnP7I1MC5V7GLk5JAQMJFoWXWB
	HcIWk7hwbz1bFyMXh5DAIkaJl8ensEI4LUwS0/beYASpYhOwkpjYvgrMFhHQkVj97gJYB7PA
	O1aJj5MvMoEkhAV8JJ7f7mIGsVkEVCXmb5sK1sAroClx4v9tsBpRAU+JT5OWgtVwCrhKzLnx
	HcwWEqiX2HvoDhtEvaDEj8n3WEBsZgF5iX37p7JC2DoS+1unsU1gFJiFpGwWkrJZSMoWMDKv
	YhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiO4mdSOxhXNlgcYhTgYFTi4ZV46BUkxJpYVlyZ
	e4hRgoNZSYTX/ixQiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQimCwT
	B6dUA2Pu0bzjVsoSrHWdEVJnJ1kkaEq2qy2KfLz62t0Ha6xKuE6vX1Dy/+PjHf+EzFYsO27+
	NmbK2jexr7fMU+rekOv103xGR2JM5od7nC5qR1pW8N4t77qrceLwwaVyVzluXVguP2/19qae
	H/rf/eTa98o//HdzlcPJyEpgGpq7aUn3g9ruV1NFP+UosRRnJBpqMRcVJwIA6MC0hd4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday, October 01, 2013 08:17:07 PM Vyacheslav Tyrtov wrote:
> From: Tarek Dakhran <t.dakhran@samsung.com>
> 
> Since current exynos_defconfig cannot support for EXYNOS5410 because
> of big.LITTLE architecture, MCPM and ARM_CCI bus there added

CONFIG_MCPM and CONFIG_ARM_CCI are optional features that won't be used
unless explicitly enabled in the device tree. CONFIG_BIG_LITTLE is not
enabled in the new defconfig at all (I also believe that it is optional
or at least can be made optional).

Therefore please modify existing exynos_defconfig to support EXYNOS5410
instead of adding the new defconfig. Having the common defconfig is really
important from the long-term maintainance POV.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> smdk5410_defconfig which is tested on SMDK5410 board
> for all 8 cpu running at the same time.
> This defconfig enables ARM_CCI, MCPM, EDCS.
> 
> Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> ---
>  arch/arm/configs/smdk5410_defconfig | 134 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 134 insertions(+)
>  create mode 100644 arch/arm/configs/smdk5410_defconfig
> 
> diff --git a/arch/arm/configs/smdk5410_defconfig b/arch/arm/configs/smdk5410_defconfig
> new file mode 100644
> index 0000000..1c19594
> --- /dev/null
> +++ b/arch/arm/configs/smdk5410_defconfig
> @@ -0,0 +1,134 @@
> +CONFIG_SYSVIPC=y
> +CONFIG_NO_HZ=y
> +CONFIG_HIGH_RES_TIMERS=y
> +CONFIG_BLK_DEV_INITRD=y
> +CONFIG_KALLSYMS_ALL=y
> +CONFIG_MODULES=y
> +CONFIG_MODULE_UNLOAD=y
> +CONFIG_PARTITION_ADVANCED=y
> +CONFIG_ARCH_EXYNOS=y
> +CONFIG_S3C_LOWLEVEL_UART_PORT=3
> +CONFIG_S3C24XX_PWM=y
> +CONFIG_ARCH_EXYNOS5=y
> +CONFIG_SMP=y
> +CONFIG_NR_CPUS=8
> +CONFIG_PREEMPT=y
> +CONFIG_AEABI=y
> +CONFIG_HIGHMEM=y
> +CONFIG_ZBOOT_ROM_TEXT=0x0
> +CONFIG_ZBOOT_ROM_BSS=0x0
> +CONFIG_ARM_APPENDED_DTB=y
> +CONFIG_ARM_ATAG_DTB_COMPAT=y
> +CONFIG_CMDLINE="console=ttySAC2,115200"
> +CONFIG_VFP=y
> +CONFIG_NEON=y
> +CONFIG_NET=y
> +CONFIG_PACKET=y
> +CONFIG_UNIX=y
> +CONFIG_NET_KEY=y
> +CONFIG_INET=y
> +CONFIG_RFKILL_REGULATOR=y
> +CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
> +CONFIG_DEVTMPFS=y
> +CONFIG_DEVTMPFS_MOUNT=y
> +CONFIG_PROC_DEVICETREE=y
> +CONFIG_BLK_DEV_LOOP=y
> +CONFIG_BLK_DEV_CRYPTOLOOP=y
> +CONFIG_BLK_DEV_RAM=y
> +CONFIG_BLK_DEV_RAM_SIZE=8192
> +CONFIG_SCSI=y
> +CONFIG_BLK_DEV_SD=y
> +CONFIG_CHR_DEV_SG=y
> +CONFIG_MD=y
> +CONFIG_BLK_DEV_DM=y
> +CONFIG_DM_CRYPT=m
> +CONFIG_NETDEVICES=y
> +CONFIG_SMSC911X=y
> +CONFIG_USB_USBNET=y
> +CONFIG_USB_NET_SMSC75XX=y
> +CONFIG_USB_NET_SMSC95XX=y
> +CONFIG_INPUT_EVDEV=y
> +CONFIG_KEYBOARD_GPIO=y
> +CONFIG_KEYBOARD_CROS_EC=y
> +# CONFIG_MOUSE_PS2 is not set
> +CONFIG_MOUSE_CYAPA=y
> +CONFIG_INPUT_TOUCHSCREEN=y
> +CONFIG_SERIAL_8250=y
> +CONFIG_SERIAL_SAMSUNG=y
> +CONFIG_SERIAL_SAMSUNG_CONSOLE=y
> +CONFIG_SERIAL_OF_PLATFORM=y
> +CONFIG_HW_RANDOM=y
> +CONFIG_TCG_TPM=y
> +CONFIG_TCG_TIS_I2C_INFINEON=y
> +CONFIG_I2C=y
> +CONFIG_I2C_MUX=y
> +CONFIG_I2C_ARB_GPIO_CHALLENGE=y
> +CONFIG_I2C_S3C2410=y
> +CONFIG_DEBUG_GPIO=y
> +# CONFIG_HWMON is not set
> +CONFIG_MFD_CROS_EC=y
> +CONFIG_MFD_CROS_EC_I2C=y
> +CONFIG_MFD_MAX77686=y
> +CONFIG_MFD_MAX8997=y
> +CONFIG_MFD_SEC_CORE=y
> +CONFIG_MFD_TPS65090=y
> +CONFIG_REGULATOR=y
> +CONFIG_REGULATOR_FIXED_VOLTAGE=y
> +CONFIG_REGULATOR_GPIO=y
> +CONFIG_REGULATOR_MAX8997=y
> +CONFIG_REGULATOR_MAX77686=y
> +CONFIG_REGULATOR_S5M8767=y
> +CONFIG_REGULATOR_TPS65090=y
> +CONFIG_FB=y
> +CONFIG_FB_MODE_HELPERS=y
> +CONFIG_FB_SIMPLE=y
> +CONFIG_EXYNOS_VIDEO=y
> +CONFIG_EXYNOS_MIPI_DSI=y
> +CONFIG_EXYNOS_DP=y
> +CONFIG_FRAMEBUFFER_CONSOLE=y
> +CONFIG_FONTS=y
> +CONFIG_FONT_7x14=y
> +CONFIG_LOGO=y
> +CONFIG_USB=y
> +CONFIG_USB_EHCI_HCD=y
> +CONFIG_USB_EHCI_S5P=y
> +CONFIG_USB_STORAGE=y
> +CONFIG_USB_DWC3=y
> +CONFIG_USB_PHY=y
> +CONFIG_SAMSUNG_USB2PHY=y
> +CONFIG_SAMSUNG_USB3PHY=y
> +CONFIG_MMC=y
> +CONFIG_MMC_SDHCI=y
> +CONFIG_MMC_SDHCI_S3C=y
> +CONFIG_MMC_DW=y
> +CONFIG_MMC_DW_IDMAC=y
> +CONFIG_MMC_DW_EXYNOS=y
> +CONFIG_RTC_CLASS=y
> +CONFIG_RTC_DRV_S3C=y
> +CONFIG_COMMON_CLK_MAX77686=y
> +CONFIG_EXT2_FS=y
> +CONFIG_EXT3_FS=y
> +CONFIG_EXT4_FS=y
> +CONFIG_MSDOS_FS=y
> +CONFIG_VFAT_FS=y
> +CONFIG_TMPFS=y
> +CONFIG_TMPFS_POSIX_ACL=y
> +CONFIG_CRAMFS=y
> +CONFIG_ROMFS_FS=y
> +CONFIG_NLS_CODEPAGE_437=y
> +CONFIG_NLS_ASCII=y
> +CONFIG_NLS_ISO8859_1=y
> +CONFIG_PRINTK_TIME=y
> +CONFIG_MAGIC_SYSRQ=y
> +CONFIG_DEBUG_KERNEL=y
> +CONFIG_DETECT_HUNG_TASK=y
> +CONFIG_DEBUG_RT_MUTEXES=y
> +CONFIG_DEBUG_SPINLOCK=y
> +CONFIG_DEBUG_MUTEXES=y
> +CONFIG_DEBUG_INFO=y
> +CONFIG_DEBUG_USER=y
> +CONFIG_CRYPTO_SHA256=y
> +CONFIG_CRC_CCITT=y
> +CONFIG_ARM_CCI=y
> +CONFIG_MCPM=y
> +CONFIG_CMDLINE_FORCE=y

