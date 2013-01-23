Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754938Ab3AWKuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:50:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42997 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab3AWKuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:50:07 -0500
Message-ID: <50FFC02E.5090703@ti.com>
Date: Wed, 23 Jan 2013 16:19:18 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Matt Porter <mporter@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
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
        Arnd Bergmann <arnd@arndb.de>, Dan Williams <djbw@fb.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 00/14] DMA Engine support for AM33XX
References: <1358281974-8411-1-git-send-email-mporter@ti.com> <50FEB6B2.5020303@ti.com> <20130123022133.GA5727@opensource.wolfsonmicro.com>
In-Reply-To: <20130123022133.GA5727@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 1/23/2013 7:51 AM, Mark Brown wrote:
> On Tue, Jan 22, 2013 at 09:26:34PM +0530, Sekhar Nori wrote:
>> On 1/16/2013 2:02 AM, Matt Porter wrote:
> 
>>> This series adds DMA Engine support for AM33xx, which uses
>>> an EDMA DMAC. The EDMA DMAC has been previously supported by only
>>> a private API implementation (much like the situation with OMAP
>>> DMA) found on the DaVinci family of SoCs.
> 
>> Will you take this series through the OMAP tree? Only 1/14 touches
>> mach-davinci and I am mostly okay with it except some changes I just
>> requested Matt to make in another thread.
> 
> Is this series somewhere near actually getting merged then? It seemed
> like there was lots of stuff going on.

I don't think there is a lot of churn on this now. 5 of the patches have
already been acked by Tony. I had a look at the first two patches (from
davinci perspective) and they mostly look good to me.

That said, I was not intending to suggest the entire series was ready
for merging. Since the series touches multiple areas of the kernel, I
wanted to make sure we have one person shepherding the series towards
mainline.

Patch 1/14 has some changes in sound/ can you please take a look and ack
them?

Thanks,
Sekhar
