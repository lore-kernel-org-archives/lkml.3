Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbbANX5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 18:57:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:33586 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbbANX5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 18:57:04 -0500
X-AuditID: cbfee68f-f791c6d000004834-4a-54b7024d1b95
Message-id: <54B7024C.4020407@samsung.com>
Date: Thu, 15 Jan 2015 08:57:00 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Doug Anderson <dianders@chromium.org>
Cc: Kukjin Kim <kgene@kernel.org>, tglx@linutronix.de, inki.dae@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "'Olof Johansson'" <olof@lixom.net>
Subject: Re: [RESEND PATCH v3] clocksource: exynos_mct: Add the support for
 Exynos 64bit SoC
References: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com>
 <54B69072.4080607@kernel.org> <54B692FB.7030703@linaro.org>
In-reply-to: <54B692FB.7030703@linaro.org>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsWyRsSkRNeXaXuIwarJfBbzPstanF12kM1i
	0v0JLBa9C66yWfQ/fs1ssenxNVaLy7vmsFnMOL+PyWLp9YtMFqeuf2az2LxpKrMDt8eaeWsY
	PWY3XGTx2LSqk83jzrU9bB7vzp1j99i8pN7jyokmVo++LasYPT5vkgvgjOKySUnNySxLLdK3
	S+DKuDVFt2CSfMXZBTeYGxgnSnYxcnJICJhIrNo3mRXCFpO4cG89G4gtJLCUUeLKdw2Ymmn/
	fgDVcAHFpzNK7LlynBHCec0osX7aFmaQKl4BLYmvzb1AVRwcLAKqEteuRoOE2YDC+1/cABsq
	KhAmsXL6FRaIckGJH5PvgdkiAuESv/5NZgKZySywhEni980ZYAlhgTiJ30c2s0Asa2KU+Dln
	BRNIghNo6vSfLxhBbGYBdYlJ8xYxQ9jyEpvXvGUGaZAQ6OSQWPLjPNgkFgEBiW+TD7GAXCch
	ICux6QAzxGuSEgdX3GCZwCg2C8lRs5CMnYVk7AJG5lWMoqkFyQXFSelFxnrFibnFpXnpesn5
	uZsYgTF8+t+z/h2Mdw9YH2IU4GBU4uF1OLI1RIg1say4MvcQoynQFROZpUST84GJIq8k3tDY
	zMjC1MTU2Mjc0kxJnHeh1M9gIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyhE46tt6j71Tqz
	xT7vtaqrTfTs2f+MophfnxPT94pZzrttXZHY1vxv3Uf/5Hc+/7nO40a6pcJlOSP3OadENvC0
	35v+Xj7i98SnTqu6an2LhWcIXp/xsfNnbtr2ZTM2XMrMbH3z8ut8Rq+tFs+qononhDBb6F6/
	Uj31ie6PjDkXVsxjd5kxpY5JiaU4I9FQi7moOBEAPBmxLdwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jQV1fpu0hBhNbWS3mfZa1OLvsIJvF
	pPsTWCx6F1xls+h//JrZYtPja6wWl3fNYbOYcX4fk8XS6xeZLE5d/8xmsXnTVGYHbo8189Yw
	esxuuMjisWlVJ5vHnWt72DzenTvH7rF5Sb3HlRNNrB59W1YxenzeJBfAGdXAaJORmpiSWqSQ
	mpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdK2SQlliTilQKCCxuFhJ
	3w7ThNAQN10LmMYIXd+QILgeIwM0kLCGMePWFN2CSfIVZxfcYG5gnCjZxcjJISFgIjHt3w9W
	CFtM4sK99WxdjFwcQgLTGSX2XDnOCOG8ZpRYP20LM0gVr4CWxNfmXqAODg4WAVWJa1ejQcJs
	QOH9L26wgdiiAmESK6dfYYEoF5T4MfkemC0iEC7x699kJpCZzAJLmCR+35wBlhAWiJP4fWQz
	C8SyJkaJn3NWMIEkOIGmTv/5ghHEZhZQl5g0bxEzhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCU8QzqR2MKxssDjEKcDAq8fA6HNkaIsSaWFZc
	mXuIUYKDWUmE9+2nbSFCvCmJlVWpRfnxRaU5qcWHGE2BQTCRWUo0OR+YvvJK4g2NTcyMLI3M
	DS2MjM2VxHmV7NtChATSE0tSs1NTC1KLYPqYODilGhj3PP43VTDwiN+x222Oel7/b149qMYv
	vb0nambt+pOOWx0PC/5ME5tu83bx1NJf31yOLjvFZPLya+y6xTduvwmNV/68x2bD43v3rwQd
	e9CQz7Fj7orOeTUrxcM0q3X5bx+5231kDePdK7ubzpovjw3pk/Hx2vY9kE10j8/R5N1nVOe8
	vaV/6PauHCWW4oxEQy3mouJEADucQiYnAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kukjin,

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

I know arch_timer. As you comment, ARCH timer would be used for system timer for ARMv8.
But, Exynos5433/Exynos7 (ARMv8) include MCT (Multi-Core Timer) IP. I checked it on
Exynos5433/EXynos7 User-manaual and tested it.

I think that exynos_mct.c should support the Exynos 64-bit SoC
because Exynos5433/Exynos7 include already MCT (Multi-Core Timer) IP.

Also, I have a problem to verify ARCH timer on Exynos SoC. Exynos User-manual never includes
the detailed information about for ARCH timer(e.g, clock for ARCH timer). I knew that
I can get the document of ARCH timer for ARM official site but I think it is insufficient
to implement ARCH timer on Exynos SoC. 

Best Regards,
Chanwoo Choi

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

