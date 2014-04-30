Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbaD3HRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 03:17:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41602 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaD3HRe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 03:17:34 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-36-5360a38c983e
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 8BIT
Message-id: <5360A7C8.1080407@samsung.com>
Date: Wed, 30 Apr 2014 16:35:36 +0900
From: Pankaj Dubey <pankaj.dubey@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308
 Thunderbird/17.0.4
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>, chow.kim@samsung.com,
        Young-Gun Jang <yg1004.jang@samsung.com>,
        VIKAS SAJJANC <vikas.sajjan@samsung.com>
Subject: Re: [PATCH v3 01/12] ARM: EXYNOS: Make exynos machine_ops as static
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
 <1398835057-3860-2-git-send-email-pankaj.dubey@samsung.com>
 <CAK9yfHxfkegFzzJCz4nAkxrHT6FGT0OQ-5RkCdTA3ruo2kU8CA@mail.gmail.com>
In-reply-to: <CAK9yfHxfkegFzzJCz4nAkxrHT6FGT0OQ-5RkCdTA3ruo2kU8CA@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zI92exQnBBovmGVosm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NanPzTy2ixfsZrFoubz7YzWexoWc3iwOXR0tzD5nHn2h42
	j81L6j36tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoEro3vTVsaCPRIVX1e+ZWpgPCLcxcjJISFg
	ItHb+ZgNwhaTuHBvPZDNxSEksIxRYtGEHhaYottXv7JDJBYxShzeeYsdJMErICjxY/I9sCJm
	ATOJRy3rmLsYOYBsEYl/NyQhwtoSyxa+Zobofc0ocWlOOwtEr5ZEX1sHE4jNIqAqsebAHrCZ
	bAK6Ek/ez2UGsUUFwiQ2Te9jBbFFgOpfdi9nAhnELPCLSWLh4idgRcICPhKztv6Auu4Mo8TH
	I28ZQRKcAsESz7ctYgVJSAi8ZZd4+eol1DoBiW+TD7GAnCohICux6QAzxJuSEgdX3GCZwCg+
	C8lzs5A8NwvhuVlInlvAyLKKUTS1ILmgOCm9yESvODG3uDQvXS85P3cTIySGJ+xgvHfA+hBj
	MtD2icxSosn5wBSQVxJvaGxmZGFqYmpsZG5pRpqwkjiv2qOkICGB9MSS1OzU1ILUovii0pzU
	4kOMTBycUg2Mue2by7/WhopqzmX6sObDzo3GPUd9ry2sXJv7/Gv1I2OBWZNivly/9v/8xzPn
	D/AntzN92t6dlrvi5tz2yJ87rptF9AseYTH2/u7YxluvL8ObV9Hy8+q7LS2CxocPHmaM6udS
	nGI36cU1hakvv2p9Cfs30evljafdoa7Nas3H7ZmNTqTHNG5ZqMRSnJFoqMVcVJwIAIwBzBn3	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAd2exQnBBmun6Fgsm3SXzaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NanPzTy2ixfsZrFoubz7YzWexoWc3iwOXR0tzD5nHn2h42
	j81L6j36tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEv
	MTfVVsnFJ0DXLTMH6CglhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8aX
	7W+YCz6IV6zsW8PWwPhDqIuRk0NCwETi9tWv7BC2mMSFe+vZuhi5OIQEFjFKHN55CyzBKyAo
	8WPyPZYuRg4OZgF5iSOXskHCzAJmEo9a1jFD1L9mlLg0p50Fol5Loq+tgwnEZhFQlVhzYA/Y
	HDYBXYkn7+cyg9iiAmESm6b3sYLYIkD1L7uXM4EMYhb4xSSxcPETsCJhAR+JWVt/sENsOMMo
	8fHIW0aQBKdAsMTzbYtYJzAKzEJy4CyEA2chOXABI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k
	/NxNjOCIfya1g3Flg8UhRgEORiUeXoGt8cFCrIllxZW5hxglOJiVRHgzOhKChXhTEiurUovy
	44tKc1KLDzEmA703kVlKNDkfmIzySuINjU3MjCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2a
	WpBaBLOFiYNTqoFR4/fV1f2Gj292HBPaGjr9W0XTxXpbNYE1M+d8WXRYRjwrevIDn/tNkber
	QgLfiHz3NS2+0dcaOel29IfjNQ7zSpdIuFrtuTJDtW3DTS/R1O2WnRWvBZp7Yl/FXErdxXqM
	553y2ZCX2ce9bPpi++p+ntNaa7suSHZt60dfmfftxzepcIko2H5XYinOSDTUYi4qTgQAjEep
	LzwDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sachin,

On 04/30/2014 03:00 PM, Sachin Kamat wrote:
> Hi Pankaj,
>
> On 30 April 2014 10:47, Pankaj Dubey <pankaj.dubey@samsung.com> wrote:
>> As machine function ops are used only in this file let's make
>> them static.
>>
>> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
>> ---
>>   arch/arm/mach-exynos/exynos.c |    6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
>> index 3d69e8d..06dcce5 100644
>> --- a/arch/arm/mach-exynos/exynos.c
>> +++ b/arch/arm/mach-exynos/exynos.c
>> @@ -198,7 +198,7 @@ static struct map_desc exynos5_iodesc[] __initdata = {
>>          },
>>   };
>>
>> -void exynos_restart(enum reboot_mode mode, const char *cmd)
>> +static void exynos_restart(enum reboot_mode mode, const char *cmd)
>>   {
>>          struct device_node *np;
>>          u32 val = 0x1;
>> @@ -239,7 +239,7 @@ void __init exynos_cpufreq_init(void)
>>          platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
>>   }
>>
>> -void __init exynos_init_late(void)
>> +static void __init exynos_init_late(void)
>>   {
>>          if (of_machine_is_compatible("samsung,exynos5440"))
>>                  /* to be supported later */
>> @@ -300,7 +300,7 @@ static void __init exynos_map_io(void)
>>                  iotable_init(exynos5250_iodesc, ARRAY_SIZE(exynos5250_iodesc));
>>   }
>>
>> -void __init exynos_init_io(void)
>> +static void __init exynos_init_io(void)
>>   {
>>          debug_ll_io_init();
>
> The declarations from common.h should also be removed in this patch to
> avoid the below
> build errors:

Thanks. I will merge changes in common.h in this patch itself.

>
> arch/arm/mach-exynos/exynos.c:198:13: error: static declaration of
> ‘exynos_restart’ follows non-static declaration
>   static void exynos_restart(enum reboot_mode mode, const char *cmd)
>               ^
> In file included from arch/arm/mach-exynos/exynos.c:31:0:
> arch/arm/mach-exynos/common.h:22:6: note: previous declaration of
> ‘exynos_restart’ was here
>   void exynos_restart(enum reboot_mode mode, const char *cmd);
>        ^
> arch/arm/mach-exynos/exynos.c:235:20: error: static declaration of
> ‘exynos_init_late’ follows non-static declaration
>   static void __init exynos_init_late(void)
>                      ^
> In file included from arch/arm/mach-exynos/exynos.c:31:0:
> arch/arm/mach-exynos/common.h:25:6: note: previous declaration of
> ‘exynos_init_late’ was here
>   void exynos_init_late(void);
>        ^
> arch/arm/mach-exynos/exynos.c:296:20: error: static declaration of
> ‘exynos_init_io’ follows non-static declaration
>   static void __init exynos_init_io(void)
>                      ^
> In file included from arch/arm/mach-exynos/exynos.c:31:0:
> arch/arm/mach-exynos/common.h:21:6: note: previous declaration of
> ‘exynos_init_io’ was here
>   void exynos_init_io(void);
>
>


-- 
Best Regards,
Pankaj Dubey

