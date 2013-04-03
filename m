Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761110Ab3DCLqx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:46:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32795 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757321Ab3DCLqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:46:50 -0400
Message-ID: <515C1672.4060000@ti.com>
Date: Wed, 3 Apr 2013 17:15:54 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Matt Porter <mporter@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCH v9 0/9] DMA Engine support for AM33XX
References: <1362586540-10393-1-git-send-email-mporter@ti.com>
In-Reply-To: <1362586540-10393-1-git-send-email-mporter@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On 3/6/2013 9:45 PM, Matt Porter wrote:

> This series adds DMA Engine support for AM33xx, which uses
> an EDMA DMAC. The EDMA DMAC has been previously supported by only
> a private API implementation (much like the situation with OMAP
> DMA) found on the DaVinci family of SoCs.

> Matt Porter (9):
>   ARM: davinci: move private EDMA API to arm/common
>   ARM: edma: remove unused transfer controller handlers

If you are going to be late in re-spinning the entire series in time for
v3.10, then I suggest I queue the first two patches through davinci tree
for v3.10 and then you can work on rest of patches for next (v3.11)
merge window.

Let me know what you think.

>   ARM: edma: add AM33XX support to the private EDMA API
>   dmaengine: edma: enable build for AM33XX
>   dmaengine: edma: Add TI EDMA device tree binding
>   ARM: dts: add AM33XX EDMA support
>   spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
>   spi: omap2-mcspi: add generic DMA request support to the DT binding
>   ARM: dts: add AM33XX SPI DMA support

Thanks,
Sekhar
