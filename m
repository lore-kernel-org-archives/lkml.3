Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbbAPLvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:51:21 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:51679 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbbAPLvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:51:16 -0500
X-AuditID: cbfee691-f79b86d000004a5a-03-54b8fb32546a
Message-id: <54B8FB31.5090105@samsung.com>
Date: Fri, 16 Jan 2015 20:51:13 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: rtc-linux@googlegroups.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] MAINTAINERS: Add entry for Maxim PMIC-s on Samsung boards
References: <1421407190-6771-1-git-send-email-k.kozlowski@samsung.com>
In-reply-to: <1421407190-6771-1-git-send-email-k.kozlowski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsWyRsSkUNfo944Qg1fPuS2WXLzKbjH14RM2
	i0lP3jNbTFw5mdni9QtDi/tfjzJafLvSwWRxedccNovPvUcYLZ5OuMhmcbtxBZvF/s4ORovT
	3awWP850s1ic3l3iwO9xua+XyWPnrLvsHnsmnmTz2LxCy2PTqk42jzvX9rB5zDsZ6NG3ZRWj
	x/R5P5k8Pm+SC+CK4rJJSc3JLEst0rdL4MpYeWgbS8FnwYoZP2ayNjB+5eti5OSQEDCR2Nl+
	mg3CFpO4cG89kM3FISSwlFFi9fVjrF2MHGBFE9p4QGqEBBYxSnSe14Ooec0oce/BTrBmXgEt
	iSu/L4HZLAKqEs0rprKA2GxA8f0vboDFRQXCJFZOv8ICUS8o8WPyPTBbRMBQ4uDu7UwgQ5kF
	elgkFrzuYQZJCAv4Sdyd85oNYrObxOYHt1lBbE4Bd4lzC7cygtjMAjoS+1unsUHY8hKb17xl
	hvhmKYfEvicyEAcJSHybfIgF4hlZiU0HoEokJQ6uuMEygVFsFpKTZiGZOgvJ1AWMzKsYRVML
	kguKk9KLTPWKE3OLS/PS9ZLzczcxAqP99L9nE3cw3j9gfYhRgINRiYfXYdOOECHWxLLiytxD
	jKZAV0xklhJNzgemlLySeENjMyMLUxNTYyNzSzMlcV4d6Z/BQgLpiSWp2ampBalF8UWlOanF
	hxiZODilGhhnH9fU5ZAq2z9nV/rc+jmTvedUfrzvn+d4+2u5nskp5RmZa6b3LE96Hc9169Kv
	Yr6XcWrW04NuMe437Uw1d2S/t8Fr6ouJx5Le9i3fde2WxwulrF3mvV8sItvf6eiG8e1TZa8L
	bN7/POlSudNlLamiWb3VvwuT3rVFFh0Om12fe/rlkdnbo82UWIozEg21mIuKEwFllYsN8QIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV2j3ztCDCb8ZLJYcvEqu8XUh0/Y
	LCY9ec9sMXHlZGaL1y8MLe5/Pcpo8e1KB5PF5V1z2Cw+9x5htHg64SKbxe3GFWwW+zs7GC1O
	d7Na/DjTzWJxeneJA7/H5b5eJo+ds+6ye+yZeJLNY/MKLY9NqzrZPO5c28PmMe9koEffllWM
	HtPn/WTy+LxJLoArqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VW
	ycUnQNctMwfoByWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxspD21gK
	PgtWzPgxk7WB8StfFyMHh4SAicSENp4uRk4gU0ziwr31bCC2kMAiRonO83pdjFxA9mtGiXsP
	doIleAW0JK78vgRmswioSjSvmMoCYrMBxfe/uAEWFxUIk1g5/QoLRL2gxI/J98BsEQFDiYO7
	tzOBDGUW6GGRWPC6hxkkISzgJ3F3zmuozW4Smx/cZgWxOQXcJc4t3MoIYjML6Ejsb53GBmHL
	S2xe85Z5AqPALCQ7ZiEpm4WkbAEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4GTyTHoH
	46oGi0OMAhyMSjy8M7bsCBFiTSwrrsw9xCjBwawkwmv/GSjEm5JYWZValB9fVJqTWnyI0RQY
	BBOZpUST84GJLq8k3tDYxMzI0sjc0MLI2FxJnFfJvi1ESCA9sSQ1OzW1ILUIpo+Jg1OqgVGA
	eZrgkTkW2z9pB3aa6O9P8M87e/DngZZUl+c8JrN+TW52SQqM29j18EHHm7OvhNg27jVf7SYQ
	d8zlv9hDx98t/XeTOtXmHF27ja/87RGmFsf01J7IgGzfN/qhgT2vH3KJf/Z71nPxBd/FCJ93
	U1vucEz/spQttYl59XubB0K9huJ9DxYFtyuxFGckGmoxFxUnAgApOvoKPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 01/16/2015 08:19 PM, Krzysztof Kozlowski wrote:
> Add myself as supporter for Maxim 77686 PMIC and Maxim 14577/77693 MUIC
> drivers:
>  - mfd (all of them),
>  - extcon (extcon-max14577, extcon-max77693)
>  - power (max14577_charger.c, 77693 on LKML [1]),
>  - regulator (all of them),
>  - clock (clk-max77686.c)
>  - RTC (rtc-max77686.c).
> 
> Lately I am the author of major contributors to them. These
> drivers are used on Exynos-based boards (Trats 2, Gear 1 and Gear 2).
> 
> [1] https://lkml.org/lkml/2015/1/5/139
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Alessandro Zummo <a.zummo@towertech.it>
> ---
>  MAINTAINERS | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f017a30eb280..b033fb499186 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6143,6 +6143,21 @@ F:	Documentation/devicetree/bindings/i2c/max6697.txt
>  F:	drivers/hwmon/max6697.c
>  F:	include/linux/platform_data/max6697.h
>  
> +MAXIM PMIC AND MUIC DRIVERS FOR EXYNOS BASED BOARDS
> +M:	Krzysztof Kozlowski <k.kozlowski@samsung.com>
> +L:	linux-kernel@vger.kernel.org
> +S:	Supported
> +F:	drivers/*/*max14577*.c
> +F:	drivers/*/*max77686*.c
> +F:	drivers/*/*max77693*.c

I knew that you did implement max14577 series because I did cowork to implement it with you.

But,
The drivers/extcon/extcon-max77693.c was implemented by me
and extcon-max14577.c was implemented by me and you.

The initial version of drivers/mfd/max77876.c, drivers/regulator/max77686.c
was implemented by Jonghwa Lee(jonghwa3.lee@samsung.com).

The initial version of drivers/mfd/max77693.c was implmented by me
and drivers/mfd/max77693.c by Jonghwa Lee.

Best Regards,
Chanwoo Choi




