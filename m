Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbaBMW5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:57:45 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:42145 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaBMW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:57:42 -0500
Message-ID: <52FD4DDD.6020400@samsung.com>
Date: Fri, 14 Feb 2014 07:57:33 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Kukjin Kim <kgene.kim@samsung.com>
CC: Richard Weinberger <richard@nod.at>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        "moderated list:ARM SUB-ARCHITECT..." 
	<linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/SAMSUNG ARM A..." 
	<linux-samsung-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 22/28] Remove S3C24XX_GPIO_EXTRA128
References: <1391971686-9517-1-git-send-email-richard@nod.at> <1391971686-9517-23-git-send-email-richard@nod.at> <52F999A1.1070709@samsung.com>
In-Reply-To: <52F999A1.1070709@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/14 12:31, Kukjin Kim wrote:
> On 02/10/14 03:48, Richard Weinberger wrote:
>> The symbol is an orphan, get rid of it.
>>
>> Signed-off-by: Richard Weinberger<richard@nod.at>
>> ---
>> arch/arm/mach-s3c24xx/Kconfig | 1 -
>> 1 file changed, 1 deletion(-)
>>
>> diff --git a/arch/arm/mach-s3c24xx/Kconfig
>> b/arch/arm/mach-s3c24xx/Kconfig
>> index 1c67f04..bb1fa603 100644
>> --- a/arch/arm/mach-s3c24xx/Kconfig
>> +++ b/arch/arm/mach-s3c24xx/Kconfig
>> @@ -561,7 +561,6 @@ config MACH_OSIRIS
>> select S3C2410_IOTIMING if ARM_S3C2440_CPUFREQ
>> select S3C2440_XTAL_12000000
>> select S3C24XX_DCLK
>> - select S3C24XX_GPIO_EXTRA128
>> select S3C24XX_SIMTEC_PM if PM
>> select S3C_DEV_NAND
>> select S3C_DEV_USB_HOST
>
> OK good, but I will squash this with 13th for mach-s3c24xx/Kconfig when
> I apply.
>
+ Paul Bolle

Richard,

I found same patch ([PATCH] ARM: s3c24xx: get rid of unneeded selects) 
for S3C24XX from Paul before your posting. So I picked that up.

Thanks,
Kukjin
