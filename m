Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab3F1PwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:52:09 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55801 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab3F1PwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:52:07 -0400
Message-ID: <51CDB06B.9010604@ti.com>
Date: Fri, 28 Jun 2013 21:18:59 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: "Fernandes, Joel" <joelf@ti.com>
CC: <benoit.cousson@gmail.com>, "lars@metafoo.de" <lars@metafoo.de>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Mark Brown <broonie@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>, Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/5] AM33xx: MMC resources from DT without HWMOD data
References: <1372209808-6532-1-git-send-email-joelagnel@ti.com> <CAD=GYpbdVVrh-tiqOcbHi3mkWRJUBdx0EsEZEFVVbgFgcCWgsw@mail.gmail.com> <51CC2A1E.2040003@ti.com> <CAD=GYpa9LQ1fV6=O9B65sJURVAigsgXCPLWav8cHXTuGQXPc9A@mail.gmail.com> <51CC67CA.2070805@ti.com> <083BC63EECB6FD41B8E81CF7FD87CC0F2E4F0F95@DLEE08.ent.ti.com>
In-Reply-To: <083BC63EECB6FD41B8E81CF7FD87CC0F2E4F0F95@DLEE08.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 June 2013 11:38 PM, Fernandes, Joel wrote:
> Hi Balaji,
>

<snip>

>>> Some patches were squashed and others dropped in the series resulting
>>> in the single patch above. This patch should be good to apply
>> Hi Joel,
>>
>> Before pushing mmc dts support for am335x, Can you please let me
>> know if below 2 patches [1] are merged/accepted,
>> IIRC these patches are needed for MMC to work properly.
>>
>> I suggest to hold the dts patch until slave_sg_limit gets merged
>> otherwise it will cause regression in am335x mmc.
>>
>> [PATCH v4 1/3] dmaengine: add dma_get_slave_sg_limits()
>> [PATCH v4 2/3] dma: edma: add device_slave_sg_limits() support
>
> Actually this is an independent regression and is currently worked on by Lars-Peter Clausen [1].
>
> Currently not having the MMC DTS merged is also a regression,

No, Right now mmc support is not added to am335x, so it is not really a regression

 > so I suggest lets take it one
> step at a time and get the DTS merged in first. Also there will be overhead of reposting this
> DTS patch later again which will not change. What do you say?
>

If it gets enabled via dts, without slave sg limit support,
file read/write will fail, possibly corrupting file system.

> Thanks,
>
> -Joel
>
> [1] https://patchwork.kernel.org/patch/2228041/
>

