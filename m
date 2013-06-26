Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab3FZEL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 00:11:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59123 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3FZELz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 00:11:55 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Fernandes, Joel" <joelagnel@ti.com>, Tony Lindgren <tony@atomide.com>,
        "Nori, Sekhar" <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Chris Ball <cjb@laptop.org>
CC: Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 1/2] ARM: configs: Enable TI_EDMA in omap2plus_defconfig
Thread-Topic: [PATCH 1/2] ARM: configs: Enable TI_EDMA in omap2plus_defconfig
Thread-Index: AQHOcgz4FDJ5xxFPXEiw1o+V0ReyUZlHYhQg
Date: Wed, 26 Jun 2013 04:10:57 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EC43DE5@DBDE04.ent.ti.com>
References: <1372210320-7148-1-git-send-email-joelagnel@ti.com>
In-Reply-To: <1372210320-7148-1-git-send-email-joelagnel@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 07:02:00, Fernandes, Joel wrote:
> From: Joel A Fernandes <agnel.joel@gmail.com>
> 
> Build EDMA in my default to avoid fewer people stepping on their toes

"my default" --> which default. I believe it should be omap2plus defconfig

> with broken DMA on drivers needing EDMA.
> 
> Signed-off-by: Joel A Fernandes <agnel.joel@gmail.com>
> ---
>  arch/arm/configs/omap2plus_defconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> index abbe319..7e00deb 100644
> --- a/arch/arm/configs/omap2plus_defconfig
> +++ b/arch/arm/configs/omap2plus_defconfig
> @@ -236,6 +236,7 @@ CONFIG_RTC_DRV_TWL92330=y
>  CONFIG_RTC_DRV_TWL4030=y
>  CONFIG_RTC_DRV_OMAP=y
>  CONFIG_DMADEVICES=y
> +CONFIG_TI_EDMA=y
>  CONFIG_DMA_OMAP=y
>  CONFIG_EXT2_FS=y
>  CONFIG_EXT3_FS=y
> -- 
> 1.7.9.5
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


Regards, 
Gururaja
