Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbaFQI4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 04:56:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34241 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753916AbaFQI4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 04:56:50 -0400
Message-ID: <53A0023D.9010407@ti.com>
Date: Tue, 17 Jun 2014 14:24:21 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <nm@ti.com>, <rnayak@ti.com>,
        <linux@arm.linux.org.uk>, <tglx@linutronix.de>, <jason@lakedaemon.net>,
        <joe@perches.com>
Subject: Re: [PATCH V3 00/16] irqchip: crossbar: driver fixes
References: <1402917796-31574-1-git-send-email-r.sricharan@ti.com> <539EF985.3080705@ti.com>
In-Reply-To: <539EF985.3080705@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 June 2014 07:34 PM, Santosh Shilimkar wrote:
> Sricharan,
>
> On Monday 16 June 2014 07:23 AM, Sricharan R wrote:
>> This series does some cleanups, fixes for handling two interrupts
>> getting mapped twice to same crossbar and provides support for
>> hardwired IRQ and crossbar definitions.
>>
>> On certain platforms such as DRA7, SPIs 0, 1, 2, 3, 5, 6, 10,
>> 131, 132, 133 are direct wired to hardware blocks bypassing
>> crossbar. This quirky implementation is *NOT* supposed to be the
>> expectation of crossbar hardware usage. This series adds support
>> to represent such hard-wired irqs through DT and avoid generic
>> allocation/programming of crossbar in the driver.
>>
>> This way of supporting hard-wired irqs was a result of
>> the below discussions.
>> http://www.spinics.net/lists/arm-kernel/msg329946.html
>>
>> Based on 3.15 mainline.
>>
>> All the patches are available here
>>  git@github.com:Sricharanti/sricharan.git crossbar_updates
>>
>> The fixes series[1] earlier posted is merged in to this.
>> [1] http://www.spinics.net/lists/arm-kernel/msg328273.html
>>
>> [V2] Merged the above series and rebased on 3.15 mainline
>>
>> [V3] Modified patch#3 to get irqs-skip properties from DT,
>>      merged path#8 for checkpatch warning to other relevant
>>      patches and fixed comments for other patches.
>>
> I scanned entire series again including your updates on Jason's
> comments. All look good to my eyes.
>
> Hopefully after this series now, we can actually enable the crossbar
> support on those machines.
>
> FWIW,
> Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Thanks Santosh.

Regards,
 Sricharan
