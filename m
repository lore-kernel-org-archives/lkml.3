Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830AbaKJE7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:59:16 -0500
Received: from mail-yh0-f42.google.com ([209.85.213.42]:32809 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbaKJE7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:59:15 -0500
MIME-Version: 1.0
In-Reply-To: <CAGcde9Fctk+XBxLV4VbevU4W7EYW+-it+T3qn3wg=v=b5ykJzA@mail.gmail.com>
References: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
	<1415452601-13078-4-git-send-email-amit.daniel@samsung.com>
	<CAGcde9Fctk+XBxLV4VbevU4W7EYW+-it+T3qn3wg=v=b5ykJzA@mail.gmail.com>
Date: Mon, 10 Nov 2014 10:29:14 +0530
X-Google-Sender-Auth: mndBSgcg4LXQtrg69pm3UUSfcfg
Message-ID: <CADGdYn5VL6aXwU4-Hmf__Ox9T964bDf3WwhdJn0Aiatz8zWKbA@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] drivers: soc: samsung: Fix a spelling mistake
From: amit daniel kachhap <amit.daniel@samsung.com>
To: Pankaj Dubey <dubepankaj1980@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 8, 2014 at 9:26 PM, Pankaj Dubey <dubepankaj1980@gmail.com> wrote:
> Hi Amit,
>
>
> On 8 November 2014 18:46, Amit Daniel Kachhap <amit.daniel@samsung.com> wrote:
>> This patches changes the name of exynos5_list_diable_wfi_wfe to
>> exynos5_list_disable_wfi_wfe.
>>
>
> Same change I have posted earlier [1] and Kukjin has taken same in his for-next.
>
> 1: http://www.spinics.net/lists/arm-kernel/msg372742.html
ok but this patch is still not visible in linux-next. I will rebase my
v3 patch series against Kukjin for-next
>
> Thanks,
> Pankaj Dubey
>
>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> ---
>>  drivers/soc/samsung/exynos-pmu.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
>> index 35774e8..3832cda 100644
>> --- a/drivers/soc/samsung/exynos-pmu.c
>> +++ b/drivers/soc/samsung/exynos-pmu.c
>> @@ -361,7 +361,7 @@ static unsigned int const exynos5_list_both_cnt_feed[] = {
>>         EXYNOS5_TOP_PWR_SYSMEM_OPTION,
>>  };
>>
>> -static unsigned int const exynos5_list_diable_wfi_wfe[] = {
>> +static unsigned int const exynos5_list_disable_wfi_wfe[] = {
>>         EXYNOS5_ARM_CORE1_OPTION,
>>         EXYNOS5_FSYS_ARM_OPTION,
>>         EXYNOS5_ISP_ARM_OPTION,
>> @@ -392,11 +392,11 @@ static void exynos5_powerdown_conf(enum sys_powerdown mode)
>>         /*
>>          * Disable WFI/WFE on XXX_OPTION
>>          */
>> -       for (i = 0; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe); i++) {
>> -               tmp = pmu_raw_readl(exynos5_list_diable_wfi_wfe[i]);
>> +       for (i = 0; i < ARRAY_SIZE(exynos5_list_disable_wfi_wfe); i++) {
>> +               tmp = pmu_raw_readl(exynos5_list_disable_wfi_wfe[i]);
>>                 tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
>>                          EXYNOS5_OPTION_USE_STANDBYWFI);
>> -               pmu_raw_writel(tmp, exynos5_list_diable_wfi_wfe[i]);
>> +               pmu_raw_writel(tmp, exynos5_list_disable_wfi_wfe[i]);
>>         }
>>  }
>>
>> --
>> 1.7.9.5
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
