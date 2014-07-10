Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbaGJF7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:59:06 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53854 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaGJF7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:59:05 -0400
Message-ID: <53BE2B6D.1090602@ti.com>
Date: Thu, 10 Jul 2014 11:28:05 +0530
From: Lokesh Vutla <lokeshvutla@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Sricharan R <r.sricharan@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <santosh.shilimkar@ti.com>,
        <nm@ti.com>, <rnayak@ti.com>, <linux@arm.linux.org.uk>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>,
        Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH V4 2/2] arm: dts: dra7: add crossbar device binding
References: <1403767532-19290-1-git-send-email-r.sricharan@ti.com> <1403767532-19290-3-git-send-email-r.sricharan@ti.com> <20140626074417.GF28884@atomide.com> <53ABDA9A.8000108@ti.com> <20140626102650.GH28884@atomide.com> <20140709154417.GC28884@atomide.com>
In-Reply-To: <20140709154417.GC28884@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,
On Wednesday 09 July 2014 09:14 PM, Tony Lindgren wrote:
> * Tony Lindgren <tony@atomide.com> [140626 03:28]:
>> * Sricharan R <r.sricharan@ti.com> [140626 01:36]:
>>> Hi Tony,
>>>
>>> On Thursday 26 June 2014 01:14 PM, Tony Lindgren wrote:
>>>> * Sricharan R <r.sricharan@ti.com> [140626 00:29]:
>>>>> From: R Sricharan <r.sricharan@ti.com>
>>>>>
>>>>> There is a IRQ crossbar device in the soc, which
>>>>> maps the irq requests from the peripherals to the
>>>>> mpu interrupt controller's inputs. The Peripheral irq
>>>>> requests are connected to only one crossbar
>>>>> input and the output of the crossbar is connected to only one
>>>>> controller's input line. The crossbar device is used to map
>>>>> a peripheral input to a free mpu's interrupt controller line.
>>>>>
>>>>> Here, adding a new crossbar device node and replacing all the peripheral
>>>>> interrupt numbers with its fixed crossbar input lines.
>>>>
>>>> I think these two patches need to be a single patch to avoid
>>>> breaking booting for git bisect inbetween these patches?
>>>   This does not cause booting issues. irq_desc gets allocated linearly,
>>>    but that does not create boot issues.
>>
>> OK
> 
> These are now applied on top of Jason's immutable irqchip branch
> and merged and pushed out into omap-for-v3.17/dt. Can you guys
> please test?
I have tested omap-for-v3.17/dt on DRA7 EVM. Crossbar is working fine.
Looks good to me.

lokesh@a0131933lt:~/working/mainline/linux$ git describe 
v3.16-rc1-34-g6464099

Please find the logs here: http://paste.ubuntu.com/7773616/

Thanks and regards,
Lokesh

> 
> Regards,
> 
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

