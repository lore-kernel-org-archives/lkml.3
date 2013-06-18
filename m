Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3FREls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 00:41:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48017 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721Ab3FRElq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 00:41:46 -0400
Message-ID: <51BFE4D3.50509@ti.com>
Date: Tue, 18 Jun 2013 10:10:51 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Fernandes, Joel A" <joelagnel@ti.com>
CC: Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
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
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH v10 5/8] dmaengine: edma: Add TI EDMA device tree binding
References: <1371263570-9323-1-git-send-email-joelagnel@ti.com> <1371263570-9323-5-git-send-email-joelagnel@ti.com> <3940138.jZFEtfGGLz@wuerfel> <083BC63EECB6FD41B8E81CF7FD87CC0F2E4E9395@DLEE08.ent.ti.com>
In-Reply-To: <083BC63EECB6FD41B8E81CF7FD87CC0F2E4E9395@DLEE08.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 6/17/2013 9:10 PM, Fernandes, Joel A wrote:
> Hi Arnd,
> 
>> -----Original Message-----
>> From: Arnd Bergmann [mailto:arnd@arndb.de]
>> Sent: Monday, June 17, 2013 6:13 AM
>> To: Fernandes, Joel A
>> Cc: Tony Lindgren; Nori, Sekhar; Matt Porter; Grant Likely; Rob Herring; Vinod
>> Koul; Mark Brown; Cousson, Benoit; Russell King; Rob Landley; Andrew
>> Morton; Jason Kridner; Koen Kooi; Devicetree Discuss; Linux OMAP List; Linux
>> ARM Kernel List; Linux DaVinci Kernel List; Linux Kernel Mailing List; Linux
>> Documentation List; Linux MMC List; Linux SPI Devel List
>> Subject: Re: [PATCH v10 5/8] dmaengine: edma: Add TI EDMA device tree
>> binding
>>
>> On Friday 14 June 2013 21:32:47 Joel A Fernandes wrote:
>>>
>>> diff --git a/Documentation/devicetree/bindings/dma/ti-edma.txt
>>> b/Documentation/devicetree/bindings/dma/ti-edma.txt
>>> new file mode 100644
>>> index 0000000..ada0018
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/dma/ti-edma.txt
>>> @@ -0,0 +1,26 @@
>>> +TI EDMA
>>> +
>>> +Required properties:
>>> +- compatible : "ti,edma3"
>>> +- ti,hwmods: Name of the hwmods associated to the EDMA
>>> +- ti,edma-regions: Number of regions
>>> +- ti,edma-slots: Number of slots
>>> +
>>> +Optional properties:
>>> +- ti,edma-xbar-event-map: Crossbar event to channel map
>>
>> You need to list #dma-cells as required here, and which values are accepted
>> by the driver (I suppose only <1>). You should also explain the format of the
>> dma-specifier for a slave here for each possible value of #dma-cells.
>>
>> For each of the standard properties (reg, interrupts, dma-channels), list
>> whether they are optional or required. Since the example has three
>> interrupts, you should probably list how many interrupts need to be specified
>> (minimum and maximum if the number is variable) and in what order to
>> expect them.
>  
> [Joel] Thanks for the suggestion, I updated it and it looks like this now:
>                                                                                                              
> Required properties:                                                                                                                   
> - compatible : "ti,edma3"                                                                                                              
> - ti,hwmods: Name of the hwmods associated to the EDMA  

I have already asked for ti,hwmods to be made optional. Please see my
comment from yesterday.

Thanks,
Sekhar
