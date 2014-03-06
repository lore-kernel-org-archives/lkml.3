Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbaCFEeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:34:44 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:34455 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbaCFEem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:34:42 -0500
Message-ID: <5317FAA3.9020409@ti.com>
Date: Thu, 6 Mar 2014 10:03:39 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Mugunthan V N <mugunthanvnm@ti.com>, <bcousson@baylibre.com>,
        <linux@arm.linux.org.uk>, <akpm@linux-foundation.org>, <nm@ti.com>,
        <balajitk@ti.com>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND Patch 0/9] dts pending patches for TI omap
References: <1393858226-32595-1-git-send-email-mugunthanvnm@ti.com> <20140305195053.GG7599@atomide.com>
In-Reply-To: <20140305195053.GG7599@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2014 01:20 AM, Tony Lindgren wrote:
> * Mugunthan V N <mugunthanvnm@ti.com> [140303 06:53]:
>> Benoit/Tony
>>
>> Here I am send all the pending dt patches that can go into 3.15 merge window,
>> all the patches were already posted to mailing list and has beed reviewed.
>>
>> I have rebased the patches on top of
>> git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git omap-for-v3.15/dt
>> and fixed all the merge conflicts.
>>
>> Pasting the mail archive for the patches series
>>
>> * Add ABB device nodes
>> http://linux-kernel.2935.n7.nabble.com/PATCH-0-4-ARM-dts-OMAP3630-Add-ABB-device-nodes-td794852.html
>>
>> * MMC hot plug support
>> http://mail.blameitonlove.com/lists/linux-omap/msg101933.html
>> Dropped [PATCH 2/3] ARM: dts: am335x-evmsk: add SD card hotplug support as this
>> is already merged with commit id 29ea5efb0bb612d352aa360de26e2095cb230e4a
>>
>> * DRA7 Cross bar DTS patches
>> Cross bar driver has been pulled for next merge, so the dts patches can also
>> be pulled for next merge window.
>>
>> Here is the pull request for the same patch series.
>>
>> The following changes since commit f777ba1780584b100ab9664cc06d04f3bb273a84:
>>
>>   Merge tag 'for_3.15/dts_signed' of git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt into omap-for-v3.15/dt (2014-03-02 14:22:03 -0800)
>>
>> are available in the git repository at:
>>
>>
>>   git://git.ti.com/~mugunthanvnm/ti-linux-kernel/linux.git omapdt-for-3.15
>>
>> for you to fetch changes up to 5f78b45aa45c5b2c4de895c3b0740fda4684dae4:
>>
>>   ARM: DTS: DRA7: Add routable-irqs property for gic node (2014-03-03 19:53:25 +0530)
> 
> Thanks applying all except for the crossbar ones into
> omap-for-v3.15/dt.
> 
> Please resend the last three patches once the dependencies
> are merged to mainline kernel as otherwise the interrupt
> nubers are all wrong without the crossbar driver related
> code.
 
   Ok, i will resend when the dependencies are merged

Regards,
 Sricharan

