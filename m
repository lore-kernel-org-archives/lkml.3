Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3GJSxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:53:25 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:58068 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3GJSxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:53:24 -0400
Message-ID: <51DDADA0.8010706@linaro.org>
Date: Wed, 10 Jul 2013 19:53:20 +0100
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH] MAINTAINERS: Add Daniel as maintainer for drivers/clocksource
References: <51DDA797.4030200@linaro.org> <1373482211.14604.62.camel@joe-AO722>
In-Reply-To: <1373482211.14604.62.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 07:50 PM, Joe Perches wrote:
> On Wed, 2013-07-10 at 19:27 +0100, John Stultz wrote:
>> I've been doing a bad job at managing the drivers/clocksource directory,
>> so Daniel has been helping with review and patch queuing for the clocksource
>> and clockevent drivers, so add him formally to the MAINTAINERS list.
>>
>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Signed-off-by: John Stultz <john.stultz@linaro.org>
>> ---
>>    MAINTAINERS | 6 ++++++
>>    1 file changed, 6 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 5be702c..460c996 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -7014,6 +7014,12 @@ F:	include/uapi/linux/timex.h
>>    F:	kernel/time/clocksource.c
>>    F:	kernel/time/time*.c
>>    F:	kernel/time/ntp.c
>> +
>> +CLOCKSOURCE, CLOCKEVENT DRIVERS
>> +M:	Daniel Lezcano <daniel.lezcano@linaro.org>
>> +M:	Thomas Gleixner <tglx@linutronix.de>
>> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
>> +S:	Supported
>>    F:	drivers/clocksource
> Sections in alphabetical order please.
Ah, sorry about that!
> Does this even apply?
> It looks more like an interdiff.
Crud. On the road, so I may be having mail client issues. I'll sort this 
out before resending.

> Should the F: include/linux/clocksource.h
> and F: kernel/time/clocksource.c entries
> above this be moved too?

No, I'm still covering the core clocksource code, just passing the 
drivers off to Daniel.

thanks for the quick review!
-john

