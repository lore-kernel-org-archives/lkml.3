Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3FQDrA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 23:47:00 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:49835 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3FQDq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 23:46:59 -0400
MIME-Version: 1.0
In-Reply-To: <51BE7CFB.6020008@ti.com>
References: <1370955220-2949-1-git-send-email-amit.daniel@samsung.com>
	<1370955220-2949-3-git-send-email-amit.daniel@samsung.com>
	<51BE7CFB.6020008@ti.com>
Date: Mon, 17 Jun 2013 09:16:58 +0530
X-Google-Sender-Auth: K6BAM1cLBqFn3gl2ajFSDIE6GAU
Message-ID: <CADGdYn7miARF2h_7hu5TcvJQvTTJ3SDg01jfFkUN_2OAuJu42w@mail.gmail.com>
Subject: Re: [PATCH V5 02/30] thermal: exynos: Add ARCH_HAS_TMU config to know
 the supported soc's
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: linux-pm@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, jonghwa3.lee@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

On Mon, Jun 17, 2013 at 8:35 AM, Eduardo Valentin
<eduardo.valentin@ti.com> wrote:
> Hey Amit,
>
> On 11-06-2013 08:53, Amit Daniel Kachhap wrote:
>> This patch adds config sybmol ARCH_HAS_TMU to enable the TMU driver.
>> This will allow adding support for new soc easily as now it is the
>> platform responsibility to enable this config symbol.
>>
>> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/thermal/samsung/Kconfig |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
>> index 2d3d9dc..145a55d 100644
>> --- a/drivers/thermal/samsung/Kconfig
>> +++ b/drivers/thermal/samsung/Kconfig
>> @@ -1,6 +1,9 @@
>> +config ARCH_HAS_TMU
>> +     bool
>> +
>>  config EXYNOS_THERMAL
>>       tristate "Temperature sensor on Samsung EXYNOS"
>> -     depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5)
>> +     depends on ARCH_HAS_TMU
>
> I would rather use ARCH_HAS_BANDGAP as discussed and agreed during your
> v4 review. I managed push this patch through RMK's system:
> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7758/1
Agreed I will post my TMU re-structured patches with this config flag.

Thanks,
Amit Daniel

>
>>       depends on CPU_THERMAL
>>       help
>>         If you say yes here you get support for TMU (Thermal Management
>>
>
>
> --
> You have got to be excited about what you are doing. (L. Lamport)
>
> Eduardo Valentin
>
