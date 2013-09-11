Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab3IKGGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 02:06:20 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60433 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3IKGGR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 02:06:17 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH 0/3] ARM: dts: Enable EDMA, MMC and SPI on AM33XX for v3.13
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <523006E8.5080104@ti.com>
Date: Wed, 11 Sep 2013 08:06:15 +0200
Cc: Benoit Cousson <bcousson@baylibre.com>, Nishanth Menon <nm@ti.com>,
        Devicetree Discuss <devicetree@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Content-Transfer-Encoding: 7BIT
Message-Id: <9A0C149F-8BF4-4970-859F-A8E59EAC31E4@dominion.thruhere.net>
References: <1378841079-15796-1-git-send-email-joelf@ti.com> <5EB8AE91-A996-4CF1-86B7-C8FDEC177E89@dominion.thruhere.net> <522F7DC0.7030603@ti.com> <88E4C15C-B1AA-4A39-A5E1-CF9E8420C2BE@dominion.thruhere.net> <523006E8.5080104@ti.com>
To: Joel Fernandes <joelf@ti.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 11 sep. 2013, om 08:00 heeft Joel Fernandes <joelf@ti.com> het volgende geschreven:

> On 09/11/2013 12:18 AM, Koen Kooi wrote:
>> 
>> Op 10 sep. 2013, om 22:14 heeft Joel Fernandes <joelf@ti.com> het volgende geschreven:
>> 
>>> On 09/10/2013 02:39 PM, Koen Kooi wrote:
>>>> 
>>>> Op 10 sep. 2013, om 21:24 heeft Joel Fernandes <joelf@ti.com> het volgende geschreven:
>>>> 
>>>>> Here are last few patches required to add EDMA and MMC/SPI support for AM33xx.
>>>>> 
>>>>> Now that all dependent DMA patches and fixes are in linux next or mainline, except
>>>>> for [1] which should go in for 3.12 -rc cycle, it is safe to enable MMC and SPI support
>>>>> and this patch series enables it. These are originally Matt Porter's patches with
>>>>> changes to make it work with recent kernels, addition of irq, memory resources and
>>>>> enable other extra properties.
>>>>> 
>>>>> These patches should cleanly apply on master branch after Koen's patch [2] for basic
>>>>> BBB DT support is applied.
>>>>> 
>>>>> MMC support is enabled for: Beaglebone, AM335x EVM and EVM-SK boards. MMC support
>>>>> for BBB is intentionally not added due to custom fixes and other patches that are
>>>>> in Koen's tree and which will be separately submitted by him.
>>>> 
>>>> Correct, but your patches for MMC support on BBW are missing the card detect entries to make it hotplug work.
>>> 
>>> I thought it was determined that this would be submitted by you separately after
>>> rebasing as we discussed [1] and [2].
>> 
>> I have no problem submitting that, I just think it's weird that the patch you submitted contains a known broken version for BBW.
> 
> There's nothing "broken" about $subject series. Please don't confuse maintainers
> by using wrong words like that. This series is perfectly OK as such to be merged.

But plugging in an SD card doesn't work in this series, I'd call that broken.

> Further, I am puzzled by all this noise because card-detect additions were
> initially agreed to be posted separately by you along with other custom DTS for
> BBW MMC.

I agreed to post the mmc fixes needed for BBW and BBB, so I assumed you'd drop all beaglebone entries from your series.

> Its obvious I wouldn't squash patches that we _agreed_ you would send
> out- and that are especially additions than any real fixes. Hopefully this makes
> it clear, if you need any help please let me know.

Right, so now your patch series will add a half-assed DT entry which only works if the uSD card is present at boot. Anyway, fixup series underway already

> 
> Thanks!
> 
> -Joel
> 
> 
>>> 
>>> [1] https://lkml.org/lkml/2013/9/6/183
>>> [2] http://marc.info/?l=linux-omap&m=137879246709612&w=2
>>> 
>>> 
>>> Regards,
>>> 
>>> -Joel
>> 
> 

