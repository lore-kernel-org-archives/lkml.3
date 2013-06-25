Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3FYORZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:17:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39519 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab3FYORW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:17:22 -0400
Message-ID: <51C9A634.6030605@ti.com>
Date: Tue, 25 Jun 2013 19:46:20 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Benoit Cousson <b-cousson@ti.com>, Joel A Fernandes <joelagnel@ti.com>,
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
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com> <20130624101903.GV5523@atomide.com> <51C85958.9030502@ti.com> <20130625065450.GY5523@atomide.com>
In-Reply-To: <20130625065450.GY5523@atomide.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/2013 12:24 PM, Tony Lindgren wrote:
> * Benoit Cousson <b-cousson@ti.com> [130624 07:42]:
>> Hi Tony,
>>
>> On 06/24/2013 12:19 PM, Tony Lindgren wrote:
>>> Hi,
>>>
>>> For merging this series, I suggest the following sets:
>>>
>>> * Joel A Fernandes <joelagnel@ti.com> [130620 14:13]:
>>>>
>>>> Joel A Fernandes (3):
>>>>   edma: config: Enable config options for EDMA
>>>>   da8xx: config: Enable MMC and FS options
>>>>   ARM: davinci: Fix compiler warnings in devices-da8xx
>>>>
>>>> Matt Porter (8):
>>>>   dmaengine: edma: Add TI EDMA device tree binding
>>>>   ARM: edma: Add DT and runtime PM support to the private EDMA API
>>>>   ARM: edma: Add EDMA crossbar event mux support
>>>>   dmaengine: edma: enable build for AM33XX
>>>
>>> Sekhar should queue the above patches, I've acked the
>>> mach-omap2/Kconfig change.
>>>
>>>>   spi: omap2-mcspi: add generic DMA request support to the DT binding
>>>>   spi: omap2-mcspi: convert to dma_request_slave_channel_compat()
>>>
>>>
>>> The spi changes should get merged via the driver list.
>>>
>>>>   ARM: dts: add AM33XX EDMA support
>>>>   ARM: dts: add AM33XX SPI DMA support
>>>
>>> Benoit should queue the .dts changes.
>>
>> I'll do that, but do you consider them for 3.11?
> 
> Yes right after -rc1 if it makes the DMA work. We almost
> certainly need to send few branches of fixes after -rc1 once
> we find out what might have broken by the removal of the
> hwmod data..

The DMA related changes went into arm-soc yesterday. So it should be
safe to send the DT patches in before the merge window opens. If Tony is
done with sending his pull requests may be Benoit can send to arm-soc
directly?

Thanks,
Sekhar
