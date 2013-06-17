Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab3FQPpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 11:45:07 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:52362 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3FQPpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 11:45:05 -0400
Message-ID: <51BF2EEF.8070209@ti.com>
Date: Mon, 17 Jun 2013 21:14:47 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Joel A Fernandes <agnel.joel@gmail.com>
CC: <matt@ohporter.com>, Arnd Bergmann <arnd@arndb.de>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Dan Williams <djbw@fb.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH v2 0/3] omap_hsmmc DT DMA Client support
References: <1362518004-7083-1-git-send-email-mporter@ti.com> <201303052126.01572.arnd@arndb.de> <20130306133717.GJ6209@beef> <CAD=GYpbmFyZxwpRwSVjasehhmR5UzMQaGCZf_5Gfo9biQyb0Ww@mail.gmail.com> <CAD=GYpaSMkTCWgetPxvchuZMWzzB09_F3nqazKFRJob1imoXUw@mail.gmail.com>
In-Reply-To: <CAD=GYpaSMkTCWgetPxvchuZMWzzB09_F3nqazKFRJob1imoXUw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 June 2013 11:40 PM, Joel A Fernandes wrote:
> Resending on Matt's new email, thanks.
>
> On Fri, Jun 14, 2013 at 1:10 PM, Joel A Fernandes <agnel.joel@gmail.com> wrote:
>> Hi,
>>
>> On Wed, Mar 6, 2013 at 7:37 AM, Matt Porter <mporter@ti.com> wrote:
>>> On Tue, Mar 05, 2013 at 09:26:01PM +0000, Arnd Bergmann wrote:
>>>> On Tuesday 05 March 2013, Matt Porter wrote:
>>>>> Changes since v1:
>>>>>          - rebase to 3.9-rc1, previous dependencies upstream
>>>>>
>>>>> This series adds DT DMA Engine Client support to the omap_hsmmc.
>>>>> It leverages the generic DMA OF helpers in -next and the
>>>>> dma_request_slave_channel_compat() wrapper introduced in the
>>>>> AM33XX DMA Engine series to support DMA in omap_hsmmc on platforms
>>>>> booting via DT. These platforms include omap2/3/4/5 and am33xx.
>>>>>
>>>>> These patches were split out from the v5 version of the AM33XX DMA
>>>>> series and split from the EDMA-specific omap_hsmmc changes.
>>>>>
>>>>
>>>> The description seems stale, but the patches all look good to me.
>>>>
>>>> I guess they can now get merged in any order.
>>>>
>>>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>>>
>>> Yes, missed updating that to indicating that those are now in
>>> 3.9-rc1.
>>
>> If there are no more changes, could this patch please be merged in for
>> 3.10 or if not, could Matt please update the description as requested
>> and repost?
>>
Hi Joel,

   mmc: omap_hsmmc: Skip platform_get_resource_byname() for dt case
   mmc: omap_hsmmc: convert to dma_request_slave_channel_compat()
got merged in 3.10 rc5

   mmc: omap_hsmmc: add generic DMA request support to the DT binding
should go along with edma dts patch series

>> Thanks,
>> Joel

