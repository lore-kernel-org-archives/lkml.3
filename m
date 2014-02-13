Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbaBMWdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:33:20 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:50160 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaBMWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:33:16 -0500
Message-ID: <52FD4824.2020303@samsung.com>
Date: Fri, 14 Feb 2014 07:33:08 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
CC: Paul Bolle <pebolle@tiscali.nl>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        LKML <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: S3C24XX: Fix typo "CONFIG_CPUS_3C2443"
References: <1392198068.23759.7.camel@x220> <CAK9yfHyXmY52KmKPj6=te829-R83dfM7wB813h=+=zCpzzxobA@mail.gmail.com>
In-Reply-To: <CAK9yfHyXmY52KmKPj6=te829-R83dfM7wB813h=+=zCpzzxobA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/14 18:47, Sachin Kamat wrote:
> On 12 February 2014 15:11, Paul Bolle<pebolle@tiscali.nl>  wrote:
>> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>
>> ---
>> Untested. This needs testing by people with access to knowledge,
>> compilers, and/or hardware related to CPU_S3C2443. I'm not one of them.
>>
>>   arch/arm/mach-s3c24xx/common.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-s3c24xx/common.c b/arch/arm/mach-s3c24xx/common.c
>> index 4adaa4b..1d77d70 100644
>> --- a/arch/arm/mach-s3c24xx/common.c
>> +++ b/arch/arm/mach-s3c24xx/common.c
>> @@ -484,7 +484,7 @@ struct platform_device s3c2440_device_dma = {
>>   };
>>   #endif
>>
>> -#if defined(CONFIG_CPUS_3C2443) || defined(CONFIG_CPU_S3C2416)
>> +#if defined(CONFIG_CPU_S3C2443) || defined(CONFIG_CPU_S3C2416)
>
> This is definitely a typo and the current fix looks good.
>
> Reviewed-by: Sachin Kamat<sachin.kamat@linaro.org>
>
Applied, thanks.

- Kukjin
