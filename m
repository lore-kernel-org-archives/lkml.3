Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab3G3QM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:12:29 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:55965 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab3G3QM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:12:28 -0400
Message-ID: <51F7E5E8.5090000@linaro.org>
Date: Tue, 30 Jul 2013 09:12:24 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH v4 07/17] clocksource: bcm2835: Switch to sched_clock_register()
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org> <1374189690-10810-8-git-send-email-sboyd@codeaurora.org> <51F78FCB.2020004@linaro.org>
In-Reply-To: <51F78FCB.2020004@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 03:04 AM, Daniel Lezcano wrote:
> On 07/19/2013 01:21 AM, Stephen Boyd wrote:
>> The 32 bit sched_clock interface now supports 64 bits. Upgrade to
>> the 64 bit function to allow us to remove the 32 bit registration
>> interface.
>>
>> Cc: Stephen Warren <swarren@wwwdotorg.org>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
> Hi Stephen,
>
> you sent a series with tick and clocksource changes.
>
> John is recipient of part of them. I replaced him to maintain the
> clocksource drivers.
>
> Is the series you sent for clocksource drivers supposed to be taken by
> me or by Russell ?
>
> In the future if there are no dependencies, it would be preferable to
> group the clocksource drivers changes into a series and send them to me.


I believe there are some dependencies on the generic bits.

I'm planning on queing the generic parts in one branch (to send to 
thomas), queuing the drivers/clocksource bits to send to you, but was 
waiting on an Ack from Catalin.

I got busy with some other work items, so I haven't pushed these out 
yet, but I'll review things again and push them out today.

thanks
-john



