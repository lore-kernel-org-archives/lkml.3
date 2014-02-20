Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaBTQxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:53:49 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:35762 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbaBTQxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:53:47 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-3b-530633194f96
Message-id: <53063317.5030208@samsung.com>
Date: Thu, 20 Feb 2014 20:53:43 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623
 Thunderbird/17.0.7
MIME-version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org,
        Anton Vorontsov <anton@enomsg.org>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, akpm@linux-foundation.org
Subject: Re: [PATCH v3 0/6] Deferrable timers support for hrtimers/timerfd API
References: <1392885633-7787-1-git-send-email-a.perevalov@samsung.com>
 <alpine.DEB.2.02.1402201209550.4468@ionos.tec.linutronix.de>
In-reply-to: <alpine.DEB.2.02.1402201209550.4468@ionos.tec.linutronix.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsVy+t/xq7qSxmzBBv9PsFjMWb+GzeLgVk2L
	61+es1qc+a1rcbbpDbvF5V1z2Cw2b5rK7MDuMaH/E6PHnWt72DzenTvH7nFixm8Wj74tqxg9
	Pm+SC2CL4rJJSc3JLEst0rdL4MqYfr2JseAWa8XbvUeYGxh3s3QxcnJICJhIvDg0kxXCFpO4
	cG89WxcjF4eQwFJGiTmn/jODJIQEPgM5jfIgNq+AlsTxC/PYQWwWAVWJ7Uc3ADVwcLAJGEjs
	u2cLYooKREgcXa4JUS0o8WPyPbBVIgIaEhsv3WIGGc8ssJZR4snd54wgCWEBP4kZ+78yQext
	ZZS4fvs92HxOAU+JpVt2gdnMAtYSKydtY4Sw5SU2r3nLPIFRYBaSJbOQlM1CUraAkXkVo2hq
	aXJBcVJ6rpFecWJucWleul5yfu4mRkiof93BuPSY1SFGAQ5GJR7ek1JswUKsiWXFlbmHGCU4
	mJVEeN1VgEK8KYmVValF+fFFpTmpxYcYmTg4pRoY7Tc5n34Q2pLicMtFMXzL/XKRSAYJpydp
	qmdTYgwXc+1L81xwfz+r6MeytxN+T9bc3MBwd/+NlsSMoMM3b5qo/G81zbJVv9F6Y3JkJtvp
	3j3HmeNzBV7XRO559fKUw8Ics2n7z6mxp/I5qJ2ab1c4Z37FRpsVnUX/E3lXLPy/72otT58x
	8/27SizFGYmGWsxFxYkAA65NA1MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 03:12 PM, Thomas Gleixner wrote:
> On Thu, 20 Feb 2014, Alexey Perevalov wrote:
>
>> Hello.
>>
>> This is a combo patch set for support defferability in timerfd.
>> Due implementation of timerfd is based on hrtimers and only on hrtimers,
>> it was necessary to add such deferrability into hrtimers too.
> Sigh, this is not about timerfd. Adding new clock ids exposes them to
> all other hrtimer based interfaces as well.
Posix timers, maybe something else,
do you want to separate this patch set, or add to this patch set,
1. proper description
2. and if it'll touch posix-timer, posix_timers clocks should be 
extended too.

>   
> Thanks,
>
> 	tglx
>


-- 
Best regards,
Alexey Perevalov
