Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbaEEJJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:09:25 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:53448 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbaEEJJU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:09:20 -0400
MIME-Version: 1.0
In-Reply-To: <536752FD.3040704@suse.de>
References: <1398245154-18771-1-git-send-email-chander.kashyap@linaro.org>
	<1399278444-8312-1-git-send-email-chander.kashyap@linaro.org>
	<1399278444-8312-3-git-send-email-chander.kashyap@linaro.org>
	<536752FD.3040704@suse.de>
Date: Mon, 5 May 2014 14:39:19 +0530
Message-ID: <CANuQgHE50Ogqaf7jJsfy6Wx40oCsUBSXz=877BaXdXswQ7e8tw@mail.gmail.com>
Subject: Re: [Patch v3 2/5] cpuidle: config: Add ARCH_EXYNOS entry to select
 cpuidle-big-little driver
From: Chander Kashyap <chander.kashyap@linaro.org>
To: =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Chander Kashyap <k.chander@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas,

On 5 May 2014 14:29, Andreas Färber <afaerber@suse.de> wrote:
> Hi,
>
> Am 05.05.2014 10:27, schrieb Chander Kashyap:
>> Exynos5420 is a big-little SoC from Samsung. It has 4 A15 and 4 A7 cores.
>> In order to use generic cpuidle-big-little driver, this patch adds Exynos5420
>> specific check to initialize generic cpuidle driver.
>>
>> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
>> Signed-off-by: Chander Kashyap <k.chander@samsung.com>
>> ---
>> Changes in v3: None
>> Changes in v2:
>>       1. Changed config macro from SOC_EXYNOS5420 to SOC_EXYNOS5420
>
> This is probably a copy&pasto? Anyway, the commit message needs an
> update since no Exynos5420 specific check is done below afaics. That
> went into 3/5.

Oops that's write,
Copy paste mistake, and commit message change is required. I will fix it .

Thanks


>
> Cheers,
> Andreas
>
>>  drivers/cpuidle/Kconfig.arm |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
>> index 97ccc31..d9596e7 100644
>> --- a/drivers/cpuidle/Kconfig.arm
>> +++ b/drivers/cpuidle/Kconfig.arm
>> @@ -4,7 +4,7 @@
>>
>>  config ARM_BIG_LITTLE_CPUIDLE
>>       bool "Support for ARM big.LITTLE processors"
>> -     depends on ARCH_VEXPRESS_TC2_PM
>> +     depends on ARCH_VEXPRESS_TC2_PM || ARCH_EXYNOS
>>       select ARM_CPU_SUSPEND
>>       select CPU_IDLE_MULTIPLE_DRIVERS
>>       help
>>
>
>
> --
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
> GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg



-- 
with warm regards,
Chander Kashyap
