Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab3LDLMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:12:47 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:62642 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab3LDLMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:12:46 -0500
MIME-Version: 1.0
In-Reply-To: <529F033E.9020608@gmail.com>
References: <1386152565-26524-1-git-send-email-thierry.reding@gmail.com>
	<529F033E.9020608@gmail.com>
Date: Wed, 4 Dec 2013 19:12:45 +0800
Message-ID: <CAN1soZwWGUfg1sq4TquTBL4_JtEdy7VGoXA42cqhpN7kQew6nQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: pxa: Remove unused variables
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 6:26 PM, Daniel Mack <zonque@gmail.com> wrote:
> On 12/04/2013 11:22 AM, Thierry Reding wrote:
>> The conf and of_id variables are assigned but never used, so they may as
>> well just be removed.
>>
>> Signed-off-by: Thierry Reding <thierry.reding@gmail.com>
>
> Acked-by: Daniel Mack <zonque@gmail.com>
>
>> ---
>>  arch/arm/mach-pxa/irq.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
>> index b6cc1816463e..0eecd83c624e 100644
>> --- a/arch/arm/mach-pxa/irq.c
>> +++ b/arch/arm/mach-pxa/irq.c
>> @@ -235,8 +235,6 @@ static const struct of_device_id intc_ids[] __initconst = {
>>  void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int))
>>  {
>>       struct device_node *node;
>> -     const struct of_device_id *of_id;
>> -     struct pxa_intc_conf *conf;
>>       struct resource res;
>>       int n, ret;
>>
>> @@ -245,8 +243,6 @@ void __init pxa_dt_irq_init(int (*fn)(struct irq_data *, unsigned int))
>>               pr_err("Failed to find interrupt controller in arch-pxa\n");
>>               return;
>>       }
>> -     of_id = of_match_node(intc_ids, node);
>> -     conf = of_id->data;
>>
>>       ret = of_property_read_u32(node, "marvell,intc-nr-irqs",
>>                                  &pxa_internal_irq_nr);
>>
>

Applied.

Thanks
Haojian
