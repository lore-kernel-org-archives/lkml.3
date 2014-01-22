Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613AbaAVIbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 03:31:21 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39183 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaAVIbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 03:31:17 -0500
Message-ID: <52DF81D4.9000008@linaro.org>
Date: Wed, 22 Jan 2014 09:31:16 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jingoo Han <jg1.han@samsung.com>
CC: "'Thomas Gleixner'" <tglx@linutronix.de>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>
Subject: Re: [PATCH] Documentation: devicetree: mct: Fix counter bit of CPU
 local timers
References: <000001cf1687$a0e5e250$e2b1a6f0$%han@samsung.com> <000101cf1749$30ae3b50$920ab1f0$%han@samsung.com>
In-Reply-To: <000101cf1749$30ae3b50$920ab1f0$%han@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2014 09:08 AM, Jingoo Han wrote:
> On Tuesday, January 21, 2014 6:03 PM, Jingoo Han wrote:
>>
>> According to the datasheet of Exynos SoCs, the counter bit
>> of CPU local timers is 31-bit, not 32-bit; thus, it should
>> be fixed.
>
> Please, ignore this patch.
> There is a 31-bit counter in CPU local timers; however,
> FRC (free running down-counters) of CPU local timers is
> 32-bit. Thus, there is no need to fix it.
> Thank you.

Ok.

>>
>> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
>> ---
>>   Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
>> b/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
>> index 167d5da..8c77791 100644
>> --- a/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
>> +++ b/Documentation/devicetree/bindings/timer/samsung,exynos4210-mct.txt
>> @@ -3,7 +3,7 @@ Samsung's Multi Core Timer (MCT)
>>   The Samsung's Multi Core Timer (MCT) module includes two main blocks, the
>>   global timer and CPU local timers. The global timer is a 64-bit free running
>>   up-counter and can generate 4 interrupts when the counter reaches one of the
>> -four preset counter values. The CPU local timers are 32-bit free running
>> +four preset counter values. The CPU local timers are 31-bit free running
>>   down-counters and generate an interrupt when the counter expires. There is
>>   one CPU local timer instantiated in MCT for every CPU in the system.
>>
>> --
>> 1.7.10.4
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

