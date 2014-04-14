Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaDNA6Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 20:58:24 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:22991 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaDNA6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 20:58:21 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f156d00000276c-18-534b32aac081
Content-transfer-encoding: 8BIT
Message-id: <534B32AD.2030209@samsung.com>
Date: Mon, 14 Apr 2014 09:58:21 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
To: Jonathan Cameron <jic23@kernel.org>
Cc: =?UTF-8?B?7LWc7LCs7Jqw?= <cwchoi00@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        ch.naveen@samsung.com, Kukjin Kim <kgene.kim@samsung.com>,
        linux-iio@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] iio: adc: exynos_adc: Control special clock of ADC to
 support Exynos3250 ADC
References: <1397181640-18513-1-git-send-email-cw00.choi@samsung.com>
 <18632148.yOYlTYattA@amdc1032>
 <CAGTfZH2Rpa+hooPHY2xmquVHCwcE2X7rqf3rzGKCz02rA9qSzA@mail.gmail.com>
 <f457ceee-ac84-45a4-9274-2ab196f92b96@email.android.com>
In-reply-to: <f457ceee-ac84-45a4-9274-2ab196f92b96@email.android.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWyRsSkUHe1kXewwaPVTBYbZ6xntbj7/DCj
	xbOj2hYPmlYxWfQuuMpmcbbpDbvFpsfXWC3mHXnHYnF51xw2ixnn9zE5cHnsnHWX3WPTqk42
	j81L6j36tqxi9Pi8SS6ANYrLJiU1J7MstUjfLoEr486OhUwF82Qq7pzXaWBcL9rFyMkhIWAi
	sf9PPyOELSZx4d56ti5GLg4hgaWMEj9XvGSCKWqYto0FIjGdUWLjwgUsIAleAUGJH5PvAdkc
	HMwC8hJHLmWDhJkF1CUmzVvEDFH/mlGi9chcRoh6LYnGh01gvSwCqhIXuneygdhsQPH9L26A
	2aICYRIrp18BqxEBGjRtxhUmkEHMAhOZJeb8ecYEskxYIFli7QUBiAUvGCWuPdkCdimngKvE
	u/tzWUESEgIv2SX6Fr5jh9gmIPFt8iGwSyUEZCU2HWCG+ExS4uCKGywTGMVmIflnFsI/s5D8
	s4CReRWjaGpBckFxUnqRsV5xYm5xaV66XnJ+7iZGYDye/vesfwfj3QPWhxiTgTZOZJYSTc4H
	xnNeSbyhsZmRhamJqbGRuaUZacJK4rz3HyYFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDs
	fHh6e57lduXY66nz+qdsF1Q4ujK+8PmlU+EzM19JfZO+MHnbibUPO08xWay+ftbDuirsY56h
	4v4Dgl5b/6pP0ZUsbvBgrz3v1T+BV8V1276jIWutHZ+3bH5wtDtGNHLh7pTlpb7VZ9nbNLvf
	cV8/b37li0Sg5O3VC04nhdu1Muj9S5kX6ZOpxFKckWioxVxUnAgA29Xlmt0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd1VRt7BBgtum1lsnLGe1eLu88OM
	Fs+Oals8aFrFZNG74CqbxdmmN+wWmx5fY7WYd+Qdi8XlXXPYLGac38fkwOWxc9Zddo9NqzrZ
	PDYvqffo27KK0ePzJrkA1qgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8
	xNxUWyUXnwBdt8wcoKOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1GBmggYQ1jBl3
	dixkKpgnU3HnvE4D43rRLkZODgkBE4mGadtYIGwxiQv31rN1MXJxCAlMZ5TYuHABWIJXQFDi
	x+R7QDYHB7OAvMSRS9kgYWYBdYlJ8xYxQ9S/ZpRoPTKXEaJeS6LxYRNYL4uAqsSF7p1sIDYb
	UHz/ixtgtqhAmMTK6VfAakSABk2bcYUJZBCzwERmiTl/njGBLBMWSJZYe0EAYsELRolrT7Yw
	gTRwCrhKvLs/l3UCo8AsJPfNQrhvFpL7FjAyr2IUTS1ILihOSs811CtOzC0uzUvXS87P3cQI
	jvZnUjsYVzZYHGIU4GBU4uFN2O4ZLMSaWFZcmXuIUYKDWUmEd1uGV7AQb0piZVVqUX58UWlO
	avEhxmSg7yYyS4km5wMTUV5JvKGxiZmRpZG5oYWRsTlpwkrivAdarQOFBNITS1KzU1MLUotg
	tjBxcEo1MM65wLbl+RT/Q/E3uCcYhatuvn12Zqmg11/PGSu7Lhg90K8UvnDh6WG/aRwPGI/c
	93VgKSzzn8XPMd8nNvJjJMvypWeifLnrln08yir+0ywy4sR/L9EVckUcn70tma/sDOq5ccjX
	8vTu67FV6ifS81YvSxCwPMm5RahvyzF5ibjqU5e+KwYnNCmxFGckGmoxFxUnAgCAtoIwOgMA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On 04/12/2014 04:49 PM, Jonathan Cameron wrote:
> 
> 
> On April 11, 2014 11:45:42 PM GMT+01:00, "최찬우" <cwchoi00@gmail.com> wrote:
>> Hi Bartlomiej,
>>
>> On Fri, Apr 11, 2014 at 6:41 PM, Bartlomiej Zolnierkiewicz
>> <b.zolnierkie@samsung.com> wrote:
>>>
>>> Hi,
>>>
>>> On Friday, April 11, 2014 11:00:40 AM Chanwoo Choi wrote:
>>>> This patch control special clock for ADC in Exynos series's FSYS
>> block.
>>>
>>> s/control/controls/
>>
>> I'll fix it.
>>
>>>
>>>> If special clock of ADC is registerd on clock list of common clk
>> framework,
>>>> Exynos ADC drvier have to control this clock.
>>>
>>> s/drvier/driver/
>>
>> I'll fix it.
>>
>>>
>>>> Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
>>>> - 'adc' clock: bus clock for ADC
>>>>
>>>> Exynos3250 has additional 'sclk_tsadc' clock as following:
>>>> - 'sclk_tsadc' clock: special clock for ADC which provide clock to
>> internal ADC
>>>>
>>>> Exynos 4210/4212/4412 and Exynos5250/5420 has not included
>> 'sclk_tsadc' clock
>>>> in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included
>> 'sclk_tsadc'
>>>> clock in FSYS_BLK.
>>>>
>>>> Cc: Jonathan Cameron <jic23@kernel.org>
>>>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>>>> Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>>> Cc: linux-iio@vger.kernel.org
>>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>  drivers/iio/adc/exynos_adc.c | 13 +++++++++++++
>>>>  1 file changed, 13 insertions(+)
>>>>
>>>> diff --git a/drivers/iio/adc/exynos_adc.c
>> b/drivers/iio/adc/exynos_adc.c
>>>> index d25b262..4cd1975 100644
>>>> --- a/drivers/iio/adc/exynos_adc.c
>>>> +++ b/drivers/iio/adc/exynos_adc.c
>>>> @@ -88,6 +88,7 @@ struct exynos_adc {
>>>>       void __iomem            *regs;
>>>>       void __iomem            *enable_reg;
>>>>       struct clk              *clk;
>>>> +     struct clk              *sclk;
>>>>       unsigned int            irq;
>>>>       struct regulator        *vdd;
>>>>
>>>> @@ -308,6 +309,13 @@ static int exynos_adc_probe(struct
>> platform_device *pdev)
>>>>               goto err_irq;
>>>>       }
>>>>
>>>> +     info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
>>>> +     if (IS_ERR(info->sclk)) {
>>>> +             dev_warn(&pdev->dev, "failed getting sclk clock, err =
>> %ld\n",
>>>> +                                                    
>> PTR_ERR(info->sclk));
>>>> +             info->sclk = NULL;
>>>> +     }
>>>> +
>>>>       info->vdd = devm_regulator_get(&pdev->dev, "vdd");
>>>>       if (IS_ERR(info->vdd)) {
>>>>               dev_err(&pdev->dev, "failed getting regulator, err =
>> %ld\n",
>>>> @@ -341,6 +349,7 @@ static int exynos_adc_probe(struct
>> platform_device *pdev)
>>>>               goto err_iio_dev;
>>>>
>>>>       clk_prepare_enable(info->clk);
>>>> +     clk_prepare_enable(info->sclk);
>>>>
>>>>       exynos_adc_hw_init(info);
>>>>
>>>> @@ -357,6 +366,7 @@ err_of_populate:
>>>>                               exynos_adc_remove_devices);
>>>>       regulator_disable(info->vdd);
>>>>       clk_disable_unprepare(info->clk);
>>>> +     clk_disable_unprepare(info->sclk);
>>>
>>> Please disable clocks in the reverse of order in which they were
>> enabled.
>>
>> Is it necessary? I don't think that.
> It is probably not a bug but it is more obviously correct in the reverse order so that is how it should be done!

OK, I'll fix it on next posting(v2). Thanks.

Best Regards,
Chanwoo Choi


