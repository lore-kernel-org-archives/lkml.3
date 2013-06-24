Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab3FXOid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:38:33 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38207 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab3FXOia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:38:30 -0400
Message-ID: <51C85958.9030502@ti.com>
Date: Mon, 24 Jun 2013 16:36:08 +0200
From: Benoit Cousson <b-cousson@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Joel A Fernandes <joelagnel@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
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
Subject: Re: [PATCH v12 00/11] DMA Engine support for AM33XX
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <20130624101903.GV5523@atomide.com>
In-Reply-To: <20130624101903.GV5523@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On 06/24/2013 12:19 PM, Tony Lindgren wrote:
> Hi,
> 
> For merging this series, I suggest the following sets:
> 
> * Joel A Fernandes <joelagnel@ti.com> [130620 14:13]:
>>
>> Joel A Fernandes (3):
>>   edma: config: Enable config options for EDMA
>>   da8xx: config: Enable MMC and FS options
>>   ARM: davinci: Fix compiler warnings in devices-da8xx
>>
>> Matt Porter (8):
>>   dmaengine: edma: Add TI EDMA device tree binding
>>   ARM: edma: Add DT and runtime PM support to the private EDMA API
>>   ARM: edma: Add EDMA crossbar event mux support
>>   dmaengine: edma: enable build for AM33XX
> 
> Sekhar should queue the above patches, I've acked the
> mach-omap2/Kconfig change.
> 
>>   spi: omap2-mcspi: add generic DMA request support to the DT binding
>>   spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
> 
> 
> The spi changes should get merged via the driver list.
> 
>>   ARM: dts: add AM33XX EDMA support
>>   ARM: dts: add AM33XX SPI DMA support
> 
> Benoit should queue the .dts changes.

I'll do that, but do you consider them for 3.11?

Thanks,
Benoit

