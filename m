Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3CHM32 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 07:29:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59087 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753076Ab3CHM3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 07:29:25 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: "Porter, Matt" <mporter@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/2] ARM: dts: add AM33XX MMC support
Thread-Topic: [PATCH 2/2] ARM: dts: add AM33XX MMC support
Thread-Index: AQHOGuqV346jkMSBUUmpAvXZrfaGX5iaRamDgAABDLD//6x8AIAAXPnAgAAB1xD//6X/AIAAaJAA//+nxQAAMfTxAA==
Date: Fri, 8 Mar 2013 12:29:02 +0000
Message-ID: <79CD15C6BA57404B839C016229A409A83EC213C8@DBDE01.ent.ti.com>
References: <1362629799-22485-1-git-send-email-mporter@ti.com>
 <1362629799-22485-3-git-send-email-mporter@ti.com>
 <41fde401c8e646689123d7c6d3a2dffc@DLEE71.ent.ti.com>
 <20130307141235.GQ6209@beef>
 <79CD15C6BA57404B839C016229A409A83EC20C57@DBDE01.ent.ti.com>
 <20130307144656.GR6209@beef>
 <79CD15C6BA57404B839C016229A409A83EC20CCA@DBDE01.ent.ti.com>
 <20130307150408.GU6209@beef>
 <79CD15C6BA57404B839C016229A409A83EC20D27@DBDE01.ent.ti.com>
 <20130307160236.GV6209@beef>
In-Reply-To: <20130307160236.GV6209@beef>
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

> -----Original Message-----
> From: Matt Porter [mailto:ohiomdp@gmail.com] On Behalf Of Porter, Matt
> Sent: Thursday, March 07, 2013 9:33 PM
> To: Hiremath, Vaibhav
> Cc: Linux OMAP List; Russell King; Krishnamoorthy, Balaji T; Devicetree
> Discuss; Linux MMC List; Linux Kernel Mailing List; Chris Ball; Linux
> ARM Kernel List
> Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> 
> On Thu, Mar 07, 2013 at 03:50:01PM +0000, Vaibhav Hiremath wrote:
> >
> > > -----Original Message-----
> > > From: Matt Porter [mailto:ohiomdp@gmail.com] On Behalf Of Porter,
> Matt
> > > Sent: Thursday, March 07, 2013 8:34 PM
> > > To: Hiremath, Vaibhav
> > > Cc: Chris Ball; Russell King; Krishnamoorthy, Balaji T; Devicetree
> > > Discuss; Linux MMC List; Linux Kernel Mailing List; Linux OMAP
> List;
> > > Linux ARM Kernel List
> > > Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > >
> > > On Thu, Mar 07, 2013 at 02:59:42PM +0000, Vaibhav Hiremath wrote:
> > > >
> > > > > -----Original Message-----
> > > > > From: Hiremath, Vaibhav
> > > > > Sent: Thursday, March 07, 2013 8:24 PM
> > > > > To: Porter, Matt
> > > > > Cc: Linux OMAP List; Russell King; Krishnamoorthy, Balaji T;
> > > Devicetree
> > > > > Discuss; Linux MMC List; Linux Kernel Mailing List; Chris Ball;
> > > Linux
> > > > > ARM Kernel List
> > > > > Subject: RE: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > > > >
> > > > > > -----Original Message-----
> > > > > > From: Matt Porter [mailto:ohiomdp@gmail.com] On Behalf Of
> Porter,
> > > > > Matt
> > > > > > Sent: Thursday, March 07, 2013 8:17 PM
> > > > > > To: Hiremath, Vaibhav
> > > > > > Cc: Linux OMAP List; Russell King; Krishnamoorthy, Balaji T;
> > > > > Devicetree
> > > > > > Discuss; Linux MMC List; Linux Kernel Mailing List; Chris
> Ball;
> > > Linux
> > > > > > ARM Kernel List
> > > > > > Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > > > > >
> > > > > > On Thu, Mar 07, 2013 at 02:39:55PM +0000, Vaibhav Hiremath
> wrote:
> > > > > > >
> > > > > > > > -----Original Message-----
> > > > > > > > From: Matt Porter [mailto:ohiomdp@gmail.com] On Behalf Of
> > > Porter,
> > > > > > Matt
> > > > > > > > Sent: Thursday, March 07, 2013 7:43 PM
> > > > > > > > To: Hiremath, Vaibhav
> > > > > > > > Cc: Krishnamoorthy, Balaji T; Chris Ball; Cousson,
> Benoit;
> > > Tony
> > > > > > > > Lindgren; Russell King; Devicetree Discuss; Linux ARM
> Kernel
> > > > > List;
> > > > > > > > Linux OMAP List; Linux Kernel Mailing List; Linux MMC
> List
> > > > > > > > Subject: Re: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > > > > > > >
> > > > > > > > On Thu, Mar 07, 2013 at 05:29:24AM +0000, Vaibhav
> Hiremath
> > > wrote:
> > > > > > > > > > -----Original Message-----
> > > > > > > > > > From: linux-omap-owner@vger.kernel.org [mailto:linux-
> > > omap-
> > > > > > > > > > owner@vger.kernel.org] On Behalf Of Porter, Matt
> > > > > > > > > > Sent: Thursday, March 07, 2013 9:47 AM
> > > > > > > > > > To: Krishnamoorthy, Balaji T; Chris Ball; Cousson,
> > > Benoit;
> > > > > Tony
> > > > > > > > > > Lindgren; Russell King
> > > > > > > > > > Cc: Devicetree Discuss; Linux ARM Kernel List; Linux
> OMAP
> > > > > List;
> > > > > > > > Linux
> > > > > > > > > > Kernel Mailing List; Linux MMC List
> > > > > > > > > > Subject: [PATCH 2/2] ARM: dts: add AM33XX MMC support
> > > > > > > > > >
> > > > <snip>
> > > > >
> > > > > I believe you meant "CONFIG_TI_EDMA" right?
> > > > >
> > > > > Yes, I just enabled it and the result is still same.
> > > > >
> > > > >
> > > > >
> > > > > [root@arago /]# dmesg | grep -ir mmc
> > > > > [    0.506844] vmmc: 1800 <--> 3300 mV at 3300 mV
> > > > > [    0.506970] vmmc: supplied by vbat
> > > > > [root@arago /]#
> > > > > [root@arago /]#
> > > > > [root@arago /]# dmesg | grep -ir dma
> > > > > [    0.217063] DMA: preallocated 256 KiB pool for atomic
> coherent
> > > > > allocations
> > > > > [    0.236321] platform 49000000.edma: alias fck already exists
> > > > > [    0.236360] platform 49000000.edma: alias fck already exists
> > > > > [    0.236381] platform 49000000.edma: alias fck already exists
> > > > > [    0.370705] edma-dma-engine edma-dma-engine.0: TI EDMA DMA
> > > engine
> > > > > driver
> > > > > [    0.445156] omap-dma-engine omap-dma-engine: OMAP DMA engine
> > > driver
> > > > > [root@arago /]#
> > > > > [root@arago /]#
> > > > >
> > > > >
> > > > I have applied below patches from your recent post
> > > >
> > > >
> > > > [2/2] ARM: dts: add AM33XX MMC support
> > > > [1/2] mmc: omap_hsmmc: set max_segs based on dma engine limits
> > > > [v4,3/3] mmc: davinci: get SG segment limits with
> > > dma_get_slave_sg_limits()
> > > > [v4,2/3] dma: edma: add device_slave_sg_limits() support
> > > > [v4,1/3] dmaengine: add dma_get_slave_sg_limits()
> > > > [v9,9/9] ARM: dts: add AM33XX SPI DMA support
> > > > [v9,8/9] spi: omap2-mcspi: add generic DMA request support to the
> DT
> > > binding
> > > > [v9,7/9] spi: omap2-mcspi: convert to
> > > dma_request_slave_channel_compat()
> > > > [v9,6/9] ARM: dts: add AM33XX EDMA support
> > > > [v9,5/9] dmaengine: edma: Add TI EDMA device tree binding
> > > > [v9,4/9] dmaengine: edma: enable build for AM33XX
> > > > [v9,3/9] ARM: edma: add AM33XX support to the private EDMA API
> > > > [v9,2/9] ARM: edma: remove unused transfer controller handlers
> > > > [v9,1/9] ARM: davinci: move private EDMA API to arm/common
> > > > [v3,2/2] mmc: omap_hsmmc: add generic DMA request support to the
> DT
> > > binding
> > > > [v3,1/2] mmc: omap_hsmmc: convert to
> > > dma_request_slave_channel_compat()
> > > >
> > > >
> > > >
> > > > Am I missing anything here?
> > >
> > > Yes, you missed the
> > > http://www.spinics.net/lists/arm-kernel/msg227886.html dependency
> > > mentioned first in the cover letter.
> > >
> >
> > Matt, I manually edited the file with above patch and result is still
> the same.
> > Can you point me to branch where you have tested MMC code?
> 
> git://github.com/ohporter/linux.git edma-dmaengine-am33xx-mmc-v1
> 
> omap2plus_defconfig + CONFIG_TI_EDMA
> 
> I just doublechecked MMC rootfs on bone and evmsk as it's the standard
> smoke test. My EVM is intermittent now so trying to coax it to power up
> to reverify.
> 

Matt,

Your branch is working for me, I tested it on EVM. Not sure what is wrong with manual rebasing
I did yesterday. I will try to nail-down root-cause here.

And you can submit the next version fixing the comments I have given.

Thanks,
Vaibhav
