Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab3IJUPh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 16:15:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59188 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab3IJUPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 16:15:35 -0400
Message-ID: <522F7DC0.7030603@ti.com>
Date: Tue, 10 Sep 2013 15:14:56 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Koen Kooi <koen@dominion.thruhere.net>
CC: Benoit Cousson <bcousson@baylibre.com>, Nishanth Menon <nm@ti.com>,
        Devicetree Discuss <devicetree@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 0/3] ARM: dts: Enable EDMA, MMC and SPI on AM33XX for
 v3.13
References: <1378841079-15796-1-git-send-email-joelf@ti.com> <5EB8AE91-A996-4CF1-86B7-C8FDEC177E89@dominion.thruhere.net>
In-Reply-To: <5EB8AE91-A996-4CF1-86B7-C8FDEC177E89@dominion.thruhere.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 02:39 PM, Koen Kooi wrote:
> 
> Op 10 sep. 2013, om 21:24 heeft Joel Fernandes <joelf@ti.com> het volgende geschreven:
> 
>> Here are last few patches required to add EDMA and MMC/SPI support for AM33xx.
>>
>> Now that all dependent DMA patches and fixes are in linux next or mainline, except
>> for [1] which should go in for 3.12 -rc cycle, it is safe to enable MMC and SPI support
>> and this patch series enables it. These are originally Matt Porter's patches with
>> changes to make it work with recent kernels, addition of irq, memory resources and
>> enable other extra properties.
>>
>> These patches should cleanly apply on master branch after Koen's patch [2] for basic
>> BBB DT support is applied.
>>
>> MMC support is enabled for: Beaglebone, AM335x EVM and EVM-SK boards. MMC support
>> for BBB is intentionally not added due to custom fixes and other patches that are
>> in Koen's tree and which will be separately submitted by him.
> 
> Correct, but your patches for MMC support on BBW are missing the card detect entries to make it hotplug work.

I thought it was determined that this would be submitted by you separately after
rebasing as we discussed [1] and [2].

[1] https://lkml.org/lkml/2013/9/6/183
[2] http://marc.info/?l=linux-omap&m=137879246709612&w=2


Regards,

-Joel
