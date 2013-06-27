Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3F0Q16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 12:27:58 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44199 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753514Ab3F0Q14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 12:27:56 -0400
Message-ID: <51CC67CA.2070805@ti.com>
Date: Thu, 27 Jun 2013 21:56:50 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>, <joelf@ti.com>
CC: <lars@metafoo.de>, Tony Lindgren <tony@atomide.com>,
        Sekhar Nori <nsekhar@ti.com>, Matt Porter <matt@ohporter.com>,
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
References: <1372209808-6532-1-git-send-email-joelagnel@ti.com> <CAD=GYpbdVVrh-tiqOcbHi3mkWRJUBdx0EsEZEFVVbgFgcCWgsw@mail.gmail.com> <51CC2A1E.2040003@ti.com> <CAD=GYpa9LQ1fV6=O9B65sJURVAigsgXCPLWav8cHXTuGQXPc9A@mail.gmail.com>
In-Reply-To: <CAD=GYpa9LQ1fV6=O9B65sJURVAigsgXCPLWav8cHXTuGQXPc9A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 June 2013 07:56 PM, Joel A Fernandes wrote:
> Hi Benoit,
>
> On Thu, Jun 27, 2013 at 7:03 AM, Benoit Cousson <b-cousson@ti.com> wrote:
>> Hi Joel,
>>
>> On 06/26/2013 05:28 AM, Joel A Fernandes wrote:
>>> On Tue, Jun 25, 2013 at 8:23 PM, Joel A Fernandes <joelagnel@ti.com> wrote:
>>>> From: Joel A Fernandes <agnel.joel@gmail.com>
>>>>
>>>> This series is fixes to get MMC working on AM33XX without HWMOD data.
>>>> On removal of HWMOD data, interrupt and register properties need to be provided
>>>> for the driver to function correctly.
>>>
>>> Please don't pull patches authored by me in this series. I have posted
>>> them with my wrong email address by mistake. I will correct my email
>>> during the next repost, after a round of review. Matt's patches in the
>>> series are still good though.
>>
>> In that case, please repost these in two series to avoid pulling the DTS
>> files in the MMC tree.
>
> The series has been replaced with the single patch:
> "[PATCH v2] ARM: dts: add AM33XX MMC support"
> http://marc.info/?l=linux-omap&m=137230403815943&w=2
>
> Some patches were squashed and others dropped in the series resulting
> in the single
> patch above. This patch should be good to apply
Hi Joel,

Before pushing mmc dts support for am335x, Can you please let me
know if below 2 patches [1] are merged/accepted,
IIRC these patches are needed for MMC to work properly.

I suggest to hold the dts patch until slave_sg_limit gets merged
otherwise it will cause regression in am335x mmc.

[PATCH v4 1/3] dmaengine: add dma_get_slave_sg_limits()
[PATCH v4 2/3] dma: edma: add device_slave_sg_limits() support

[1]
https://groups.google.com/forum/#!topic/linux.kernel/khTTcPtQpag

>
> Thanks,
>
> -Joel
>
