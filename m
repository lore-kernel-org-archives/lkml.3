Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3FXK70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:59:26 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:52981 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3FXK7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:59:23 -0400
Message-ID: <51C82684.6090700@atmel.com>
Date: Mon, 24 Jun 2013 12:59:16 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        "Ludovic Desroches" <ludovic.desroches@atmel.com>,
        Josh Wu <josh.wu@atmel.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: at91/PMC: at91sam9n12 family has USB HS feature
References: <cover.1372064763.git.nicolas.ferre@atmel.com> <a3b28f9041482ff60ed0b1b7a6f11d0b1beb5163.1372064763.git.nicolas.ferre@atmel.com> <51C82369.1080900@atmel.com>
In-Reply-To: <51C82369.1080900@atmel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/2013 12:46, Bo Shen :
> Hi Nicolas,
>
> On 06/24/2013 05:08 PM, Nicolas Ferre wrote:
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> ---
>>   arch/arm/mach-at91/clock.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/arm/mach-at91/clock.c b/arch/arm/mach-at91/clock.c
>> index 978de42..1b9bbba 100644
>> --- a/arch/arm/mach-at91/clock.c
>> +++ b/arch/arm/mach-at91/clock.c
>> @@ -88,6 +88,7 @@ EXPORT_SYMBOL_GPL(at91_pmc_base);
>>   #define cpu_has_udpfs()        (!(cpu_is_at91sam9rl() \
>>                   || cpu_is_at91sam9g45() \
>>                   || cpu_is_at91sam9x5() \
>> +                || cpu_is_at91sam9n12() \
>>                   || cpu_is_sama5d3()))
>
> The at91sam9n12 don't have USB HS device port feature. It only has USB
> FS device port feature.

OMG! sure ;-)

So I remove this patch from my series (sorry for the noise ;-))

>
>>   #define cpu_has_plladiv2()    (cpu_is_at91sam9g45() \
>>
>
> Best Regards,
> Bo Shen

Thanks! bye.
-- 
Nicolas Ferre
