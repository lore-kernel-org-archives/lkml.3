Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935403Ab3FUKQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:16:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42746 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756130Ab3FUKQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:16:13 -0400
Message-ID: <51C427AA.6080601@ti.com>
Date: Fri, 21 Jun 2013 15:45:06 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Joel A Fernandes <joelagnel@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v12 04/11] dmaengine: edma: enable build for AM33XX
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <1371762407-24544-5-git-send-email-joelagnel@ti.com>
In-Reply-To: <1371762407-24544-5-git-send-email-joelagnel@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/21/2013 2:36 AM, Joel A Fernandes wrote:
> From: Matt Porter <mporter@ti.com>
> 
> Enable TI EDMA option on OMAP and TI_PRIV_EDMA
> 
> Signed-off-by: Matt Porter <mporter@ti.com>
> Signed-off-by: Joel A Fernandes <joelagnel@ti.com>

This will have to be taken by Tony.

Thanks,
Sekhar

> ---
>  arch/arm/mach-omap2/Kconfig |    1 +
>  drivers/dma/Kconfig         |    2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
> index f49cd51..f91b07f 100644
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -17,6 +17,7 @@ config ARCH_OMAP2PLUS
>  	select PROC_DEVICETREE if PROC_FS
>  	select SOC_BUS
>  	select SPARSE_IRQ
> +	select TI_PRIV_EDMA
>  	select USE_OF
>  	help
>  	  Systems based on OMAP2, OMAP3, OMAP4 or OMAP5
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index e992489..3215a3c 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -213,7 +213,7 @@ config SIRF_DMA
>  
>  config TI_EDMA
>  	tristate "TI EDMA support"
> -	depends on ARCH_DAVINCI
> +	depends on ARCH_DAVINCI || ARCH_OMAP
>  	select DMA_ENGINE
>  	select DMA_VIRTUAL_CHANNELS
>  	default n
> 
