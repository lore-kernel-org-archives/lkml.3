Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983Ab3GQTVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 15:21:16 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47856 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836Ab3GQTVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 15:21:15 -0400
Message-ID: <51E6EEA8.7040504@linaro.org>
Date: Wed, 17 Jul 2013 12:21:12 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add the generic sched_clock under timekeeping
References: <a38977cc6608170b69b21b8a5ee985685c7e8a0d.1374055149.git.baruch@tkos.co.il> <51E6E91C.1090700@linaro.org> <20130717191222.GW6950@tarshish>
In-Reply-To: <20130717191222.GW6950@tarshish>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2013 12:12 PM, Baruch Siach wrote:
> Hi John,
>
> On Wed, Jul 17, 2013 at 11:57:32AM -0700, John Stultz wrote:
>> On 07/17/2013 03:05 AM, Baruch Siach wrote:
>>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>>> ---
>>>   MAINTAINERS | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index bf61e04..bd9616a 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -7129,6 +7129,7 @@ M:	Thomas Gleixner <tglx@linutronix.de>
>>>   T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
>>>   S:	Supported
>>>   F:	include/linux/clocksource.h
>>> +F:	include/linux/sched_clock.h
>>>   F:	include/linux/time.h
>>>   F:	include/linux/timex.h
>>>   F:	include/uapi/linux/time.h
>>> @@ -7136,6 +7137,7 @@ F:	include/uapi/linux/timex.h
>>>   F:	kernel/time/clocksource.c
>>>   F:	kernel/time/time*.c
>>>   F:	kernel/time/ntp.c
>>> +F:	kernel/time/sched_clock.c
>> It seems like we could probably simplify this bit to kernel/time/*, no?
> This would add jiffies.c and all the tick-* files that are currently covered
> by the "HIGH-RESOLUTION TIMERS, CLOCKEVENTS, DYNTICKS" section.

Ok, fair enough. My thought was it all goes through Thomas anyway, but 
for those sections there are different combinations of folks who 
co-maintain.

thanks
-john

