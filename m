Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356AbaBTQZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:25:54 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27704 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaBTQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:25:53 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-0e-53062c8f6eb0
Message-id: <53062C8E.30301@samsung.com>
Date: Thu, 20 Feb 2014 20:25:50 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, anton@nomsg.org,
        kyungmin.park@samsung.com, cw00.choi@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v3 1/6] tracing/trivial: Add CLOCK_BOOTIME and CLOCK_TAI
 for human readable clockid trace
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
 <1392885633-7787-2-git-send-email-a.perevalov@samsung.com>
 <alpine.DEB.2.02.1402201158170.4468@ionos.tec.linutronix.de>
In-reply-to: <alpine.DEB.2.02.1402201158170.4468@ionos.tec.linutronix.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t/xa7r9OmzBBjdbjC3mrF/DZtH/q5PV
	4vqX56wWZ37rWpxtesNucXnXHDaLzZumMjuwe9y5tofN4925c+weJ2b8ZvH4smcvs0ffllWM
	Hp83yQWwRXHZpKTmZJalFunbJXBlXO31LGjnrJh6fA97A2MfexcjJ4eEgInE8vbZbBC2mMSF
	e+uBbC4OIYGljBI/1z1nh3A+M0qsX7YXrIpXQEPi1I5+VhCbRUBV4sv32yxdjBwcbAIGEvvu
	2YKYogIREkeXa0JUC0r8mHyPBcQWAerceOkWM8hIZoEZjBKvN25jBEkIC+RLHD+9ihFi1yFG
	icZt08E6OAU8JX7cvMUEYjMLWEusnATRwCwgL7F5zVvmCYwCs5AsmYWkbBaSsgWMzKsYRVNL
	kwuKk9JzDfWKE3OLS/PS9ZLzczcxQoL9yw7GxcesDjEKcDAq8fAWSLAFC7EmlhVX5gJdw8Gs
	JMLrrgIU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwGi//a9gisq6TQw7uVLONTozhGcL6mWaF11O
	e7z8UOxRw11L6m91Ci6NSKuNLJcKWvJfWvPe+X166fJeUxeUPppfyFJh+e3zoqy7FSca7rl5
	yH1VNvwU/LftVdG+CwvKp/CW3X3R9bDnSpDssoDNUtY3zcLvuv9NfNRkNLXVLdaiK3/auyds
	y5VYijMSDbWYi4oTAdNFiKpUAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 03:01 PM, Thomas Gleixner wrote:
>
> On Thu, 20 Feb 2014, Alexey Perevalov wrote:
>
>> These clockids is also used in current hrtimer implementation.
>>
>> Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
>> ---
>>   include/trace/events/timer.h |    5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
>> index 185b2c6..547b79f 100644
>> --- a/include/trace/events/timer.h
>> +++ b/include/trace/events/timer.h
>> @@ -11,7 +11,10 @@
>>   #define clockid_to_string(clockid)						\
>>   	__print_symbolic(clockid,						\
>>   			 { CLOCK_MONOTONIC,		"CLOCK_MONOTONIC" },	\
>> -			 { CLOCK_REALTIME,		"CLOCK_REALTIME" })
>> +			 { CLOCK_REALTIME,		"CLOCK_REALTIME" },	\
>> +			 { CLOCK_BOOTTIME,		"CLOCK_BOOTTIME" },	\
>> +			 { CLOCK_TAI,			"CLOCK_TAI" }		\
>> +	)
> patching file include/trace/events/timer.h
> Hunk #1 FAILED at 11.
> 1 out of 1 hunk FAILED -- rejects in file include/trace/events/timer.h
>
> Brilliant stuff this.
>
>
>
>    
>
Sorry, I missed one patch


-- 
Best regards,
Alexey Perevalov
