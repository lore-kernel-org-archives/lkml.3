Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbaKTKDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:03:43 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:56190 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbaKTKDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:03:38 -0500
Date: Thu, 20 Nov 2014 10:03:29 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        pankaj.dubey@samsung.com, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/5] drivers: soc: Add support for Exynos PMU driver
Message-ID: <20141120100328.GO4042@n2100.arm.linux.org.uk>
References: <1416461968-2057-1-git-send-email-amit.daniel@samsung.com>
 <1416461968-2057-3-git-send-email-amit.daniel@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416461968-2057-3-git-send-email-amit.daniel@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 11:09:25AM +0530, Amit Daniel Kachhap wrote:
> diff --git a/drivers/soc/Makefile b/drivers/soc/Makefile
> index 063113d..44d220d 100644
> --- a/drivers/soc/Makefile
> +++ b/drivers/soc/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_ARCH_QCOM)		+= qcom/
>  obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
>  obj-$(CONFIG_SOC_TI)		+= ti/
>  obj-$(CONFIG_PLAT_VERSATILE)	+= versatile/
> +obj-$(CONFIG_ARCH_EXYNOS)	+= samsung/

Is ARCH_EXYNOS appropriate here, or is your new SOC_SAMSUNG better?

> diff --git a/drivers/soc/samsung/Kconfig b/drivers/soc/samsung/Kconfig
> new file mode 100644
> index 0000000..a424ebc
> --- /dev/null
> +++ b/drivers/soc/samsung/Kconfig
> @@ -0,0 +1,20 @@
> +#
> +# SAMSUNG SOC drivers
> +#
> +menuconfig SOC_SAMSUNG
> +	bool "Samsung SOC drivers support"

If you intend to select SOC_SAMSUNG, is there any point in making this
a user-visible symbol?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
