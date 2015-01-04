Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbbADEJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 23:09:17 -0500
Received: from [119.145.14.65] ([119.145.14.65]:25677 "EHLO
	szxga02-in.huawei.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbbADEJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 23:09:15 -0500
Message-ID: <54A8BCB4.4010801@huawei.com>
Date: Sun, 4 Jan 2015 12:08:20 +0800
From: "long.wanglong" <long.wanglong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Haojian Zhuang <haojian.zhuang@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <peifeiyue@huawei.com>
Subject: Re: [PATCH] irq: irq-hip04: initialize hip04_cpu_map to 0xffff
References: <1418295816-179583-1-git-send-email-long.wanglong@huawei.com> <CAD6h2NSnU5aLEC2w12FVesvBHoKHg2DNY3Eav-kq7htivu=Z=w@mail.gmail.com>
In-Reply-To: <CAD6h2NSnU5aLEC2w12FVesvBHoKHg2DNY3Eav-kq7htivu=Z=w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.88.174]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/11 19:19, Haojian Zhuang wrote:
> On 11 December 2014 at 19:03, Wang Long <long.wanglong@huawei.com> wrote:
>> HiP04 GIC extends to support 16 cores, so we should
>> initialize the hip04_cpu_map to 0xffff.
>>
>> Signed-off-by: Wang Long <long.wanglong@huawei.com>
>> ---
>>  drivers/irqchip/irq-hip04.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/irqchip/irq-hip04.c b/drivers/irqchip/irq-hip04.c
>> index 9c8f8335..8eee46b 100644
>> --- a/drivers/irqchip/irq-hip04.c
>> +++ b/drivers/irqchip/irq-hip04.c
>> @@ -382,7 +382,7 @@ hip04_of_init(struct device_node *node, struct device_node *parent)
>>          * It will be refined as each CPU probes its ID.
>>          */
>>         for (i = 0; i < NR_HIP04_CPU_IF; i++)
>> -               hip04_cpu_map[i] = 0xff;
>> +               hip04_cpu_map[i] = 0xffff;
>>
>>         /*
>>          * Find out how many interrupts are supported.
>> --
>> 1.8.3.4
>>
> 
> Acked-by: Haojian Zhuang <haojian.zhuang@linaro.org>
> 
> Best Regards
> Haojian
> 
> 

hi Thomas Gleixner, Jason Cooper

could you please help to apply this patch?

Best Regards
Wang Long


