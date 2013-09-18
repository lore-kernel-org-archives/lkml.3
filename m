Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab3IRBsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 21:48:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:21967 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3IRBsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 21:48:42 -0400
Message-ID: <52390665.2020507@huawei.com>
Date: Wed, 18 Sep 2013 09:48:21 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clocksource: fix comment for __clocksource_updatefreq_scale
References: <523831AB.9060101@huawei.com> <alpine.DEB.2.02.1309172056320.4089@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1309172056320.4089@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/18 2:57, Thomas Gleixner wrote:
> On Tue, 17 Sep 2013, Xie XiuQi wrote:
> 
>> The functions clocksource_updatefreq_hz() and clocksource_updatefreq_khz()
>> do not exist, The proper ones are __clocksource_updatefreq_hz() and
>> __clocksource_updatefreq_khz().
> 
> I'd rather rename the functions and the few call sites because the
> underscores are completely meaningless.

That's a good idea, thanks. I'll update this patch and send later.

> 
> Thanks,
> 
> 	tglx
> 
>> Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
>> ---
>>  kernel/time/clocksource.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>> index 50a8736..d2f6ddc 100644
>> --- a/kernel/time/clocksource.c
>> +++ b/kernel/time/clocksource.c
>> @@ -714,7 +714,8 @@ static void clocksource_enqueue(struct clocksource *cs)
>>   * This should only be called from the clocksource->enable() method.
>>   *
>>   * This *SHOULD NOT* be called directly! Please use the
>> - * clocksource_updatefreq_hz() or clocksource_updatefreq_khz helper functions.
>> + * __clocksource_updatefreq_hz() or __clocksource_updatefreq_khz helper
>> + * functions.
>>   */
>>  void __clocksource_updatefreq_scale(struct clocksource *cs, u32 scale, u32 freq)
>>  {
>> -- 
>> 1.8.2.1
>>
>>
> 
> 


