Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799AbbASAyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 19:54:23 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:21062 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbASAyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 19:54:21 -0500
X-AuditID: cbfee68f-f791c6d000004834-a5-54bc55bbbe6a
Message-id: <54BC55BB.7050809@samsung.com>
Date: Mon, 19 Jan 2015 09:54:19 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>, Kukjin Kim <kgene@kernel.org>
Cc: tglx@linutronix.de, inki.dae@samsung.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Doug Anderson <dianders@chromium.org>,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: [RESEND PATCH v3] clocksource: exynos_mct: Add the support for
 Exynos 64bit SoC
References: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com>
 <54B69072.4080607@kernel.org> <54B692FB.7030703@linaro.org>
In-reply-to: <54B692FB.7030703@linaro.org>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsWyRsSkSHd36J4Qg+mPlS3mfZa1OLvsIJvF
	pPsTWCx6F1xls+h//JrZYtPja6wWl3fNYbOYcX4fk8XS6xeZLE5d/8xmsXnTVGYHbo8189Yw
	esxuuMjisWlVJ5vHnWt72DzenTvH7rF5Sb3HlRNNrB59W1YxenzeJBfAGcVlk5Kak1mWWqRv
	l8CVseP7J+aClVIVl25NZ29gnCraxcjJISFgIrFxwzM2CFtM4sK99UA2F4eQwFJGiWPz5zPB
	FE28/4AFIrGIUWLX60tQzmtGif1vvrGDVPEKaEnsOLGRFcRmEVCVuHGhAaybDSi+/8UNsBWi
	AmESK6dfYYGoF5T4MfkemC0i4CvROm8RI4jNLLCGSWL9TycQW1ggTuL3kc1Qy5oYJX7OWQE2
	lBNo6PSfL6Aa1CUmzVvEDGHLS2xe85YZpEFCoJFDYtuypewQFwlIfJt8CGgSB1BCVmLTAWaI
	1yQlDq64wTKBUWwWkptmIRk7C8nYBYzMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzEC4/j0
	v2f9OxjvHrA+xCjAwajEw7vBd0+IEGtiWXFl7iFGU6ArJjJLiSbnA5NFXkm8obGZkYWpiamx
	kbmlmZI470Kpn8FCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGFl9HAJ+bHrNajTfRXLSmcs7
	on+UpcxKaGdYG2BlLbjsVJ/GmyVhLRH/VjZPErdqT/MU3BB3/+aWR0XqzFY5xV23sgR0OQ7N
	/1RnPpFzp71hbND6yja5p7liaRd63/Uf+3b3cbAzYynvbZ15v4LXy83QmRXH2PTMTpa9dR2/
	i0maeVLAEoZlSizFGYmGWsxFxYkAjS/W6N4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAd3doXtCDGZ0S1nM+yxrcXbZQTaL
	SfcnsFj0LrjKZtH/+DWzxabH11gtLu+aw2Yx4/w+Joul1y8yWZy6/pnNYvOmqcwO3B5r5q1h
	9JjdcJHFY9OqTjaPO9f2sHm8O3eO3WPzknqPKyeaWD36tqxi9Pi8SS6AM6qB0SYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6FolhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8aO75+YC1ZKVVy6NZ29gXGqaBcjJ4eEgInExPsP
	WCBsMYkL99azdTFycQgJLGKU2PX6EguE85pRYv+bb+wgVbwCWhI7TmxkBbFZBFQlblxoYAKx
	2YDi+1/cYAOxRQXCJFZOv8ICUS8o8WPyPTBbRMBXonXeIkYQm1lgDZPE+p9OILawQJzE7yOb
	oZY1MUr8nLMCbCgn0NDpP19ANahLTJq3iBnClpfYvOYt8wRGgVlIdsxCUjYLSdkCRuZVjKKp
	BckFxUnpuUZ6xYm5xaV56XrJ+bmbGMFJ4pn0DsZVDRaHGAU4GJV4eDf47gkRYk0sK67MPcQo
	wcGsJMIrowcU4k1JrKxKLcqPLyrNSS0+xGgKDIKJzFKiyfnABJZXEm9obGJmZGlkbmhhZGyu
	JM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cBo+D/At5vl6OH5KiGvNSTPdFz+03DYI+t96943
	HrmVC7+Ffl5dk+50r5/xseSDIPVp9QmKf3P53jruUr/pxvrnjnJO1bc9Am/ecP17d1op84f3
	isosrRL71zJ3wy3z2TZrWj9Yftb8bUhG5LpPbOs/73raPCFm1ueocC29RTpW81UkF/NwfzBU
	YinOSDTUYi4qTgQAksmgdigDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Daniel and Kukjin,

On 01/15/2015 01:02 AM, Daniel Lezcano wrote:
> On 01/14/2015 04:51 PM, Kukjin Kim wrote:
>> On 01/14/15 14:33, Chanwoo Choi wrote:
>>
>> Hi,
>>
>> + Doug, Olof
>>
>>> This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
>>> for Exynos 32bit SoC.
>>>
>> Yes, the Exynos MCT(Multi-Core Timer) is 64bit timer and it is available
>> on 64bit exynos SoC such as exynos7. But basically ARMv8 architecture is
>> including ARM ARCH timer (ARM Generic Timer) and exynos7 also has
>> implemented it and additionally its access is faster than using memory
>> mapped register called SFR for MCT...so Doug submitted patch to use MCT
>> on 32bit exynos SoCs before.
>>
>> I know using MCT on 64bit exynos is usefulness for Power Management and
>> I need to talk to relevant guys in office again. If anything, I'll let
>> you know.
> 
> I will wait for your answer before digging more the patch.
> 
> Thanks
>   -- Daniel
> 
>>> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: Kukjin Kim <kgene.kim@samsung.com>
>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
>>> ---
>>> This patch set is tested on 64-bit Exynos SoC. I send only this patch from
>>> following patchst[1].
>>> [1] https://lkml.org/lkml/2014/12/2/134
>>>
>>> Changes from v2:
>>> - None
>>> Changes from v1:
>>> - Use CONFIG_ARM instead of CONFIG_ARM64
>>>
>>>   drivers/clocksource/Kconfig      | 1 -
>>>   drivers/clocksource/exynos_mct.c | 4 ++++
>>>   2 files changed, 4 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
>>> index fc01ec2..be38119 100644
>>> --- a/drivers/clocksource/Kconfig
>>> +++ b/drivers/clocksource/Kconfig
>>> @@ -135,7 +135,6 @@ config CLKSRC_METAG_GENERIC
>>>
>>>   config CLKSRC_EXYNOS_MCT
>>>       def_bool y if ARCH_EXYNOS
>>> -    depends on !ARM64
>>>       help
>>>         Support for Multi Core Timer controller on Exynos SoCs.
>>>
>>> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
>>> index 9403061..b840ea1 100644
>>> --- a/drivers/clocksource/exynos_mct.c
>>> +++ b/drivers/clocksource/exynos_mct.c
>>> @@ -223,6 +223,7 @@ static u64 notrace exynos4_read_sched_clock(void)
>>>       return exynos4_read_count_32();
>>>   }
>>>
>>> +#if defined(CONFIG_ARM)
>>>   static struct delay_timer exynos4_delay_timer;
>>>
>>>   static cycles_t exynos4_read_current_timer(void)
>>> @@ -231,14 +232,17 @@ static cycles_t exynos4_read_current_timer(void)
>>>                "cycles_t needs to move to 32-bit for ARM64 usage");
>>>       return exynos4_read_count_32();
>>>   }
>>> +#endif
>>>
>>>   static void __init exynos4_clocksource_init(void)
>>>   {
>>>       exynos4_mct_frc_start();
>>>
>>> +#if defined(CONFIG_ARM)
>>>       exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
>>>       exynos4_delay_timer.freq = clk_rate;
>>>       register_current_timer_delay(&exynos4_delay_timer);
>>> +#endif
>>>
>>>       if (clocksource_register_hz(&mct_frc, clk_rate))
>>>           panic("%s: can't register clocksource\n", mct_frc.name);
> 
> 

Do you have any comment about this patch?

Best Regards,
Chanwoo Choi


