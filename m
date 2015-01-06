Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbbAFB4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 20:56:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:34350 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbbAFB4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 20:56:04 -0500
X-AuditID: cbfee691-f79b86d000004a5a-1e-54ab40b17a98
Message-id: <54AB40B1.6020003@samsung.com>
Date: Tue, 06 Jan 2015 10:56:01 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: daniel.lezcano@linaro.org, tglx@linutronix.de
Cc: Chanwoo Choi <cw00.choi@samsung.com>, kgene.kim@samsung.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene@kernel.org>
Subject: Re: [PATCHv3] clocksource: exynos_mct: Add the support for Exynos
 64bit SoC
References: <1418773571-10834-1-git-send-email-cw00.choi@samsung.com>
In-reply-to: <1418773571-10834-1-git-send-email-cw00.choi@samsung.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWyRsSkWHeTw+oQgxtXGC2uf3nOajHvs6xF
	74KrbBb9j18zW2x6fI3V4vKuOWwWM87vY7JYev0ik8XmTVOZHTg91sxbw+ixaVUnm8eda3vY
	PN6dO8fusXlJvUffllWMHp83yQWwR3HZpKTmZJalFunbJXBlfL8dUDBFqOLihn2sDYxf+LoY
	OTkkBEwkWv8cYYawxSQu3FvP1sXIxSEksJRR4v67dmaYonPLT0MlpjNKNO9/zAzhvGaU2Lvu
	NBNIFa+AlsSHnn1gHSwCqhIXLs5kBLHZgOL7X9xgA7FFBcIkVk6/wgJRLyjxY/I9MFtEwFBi
	z4oOsKHMAv8YJeb9n8IOkhAGariwezlYs5CAq8TTBd9YQWxOATeJO7+ug8WZBdQlJs1bxAxh
	y0tsXvMWbJCEwCN2iYkb9kBdJCDxbfIhoG0cQAlZiU0HoF6TlDi44gbLBEaxWUhumoVk7Cwk
	YxcwMq9iFE0tSC4oTkovMtUrTswtLs1L10vOz93ECIzO0/+eTdzBeP+A9SFGAQ5GJR5ejxMr
	Q4RYE8uKK3MPMZoCXTGRWUo0OR+YAvJK4g2NzYwsTE1MjY3MLc2UxHl1pH8GCwmkJ5akZqem
	FqQWxReV5qQWH2Jk4uCUamCcZHC4YTb7/Uv9TTZy4rIvrsx7IlfhuT2lft3dObfD1ppKLap7
	7uO7ebHqDonsFW+OH7nspqUqE8I3/9TS/oPXXcT+h+yZLKk6PanQyX9GUcz9Cd82/BQy/WvD
	zMxmGKfubPpBuGCnUXbB1eXHtnU0KydX1Re+d44qPlA/c+uxpXvNbJOuTTRXYinOSDTUYi4q
	TgQAadAitckCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xoO5Gh9UhBisfm1lc//Kc1WLeZ1mL
	3gVX2Sz6H79mttj0+BqrxeVdc9gsZpzfx2Sx9PpFJovNm6YyO3B6rJm3htFj06pONo871/aw
	ebw7d47dY/OSeo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0
	tDBXUshLzE21VXLxCdB1y8wBukxJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEa
	SFjDmPH9dkDBFKGKixv2sTYwfuHrYuTkkBAwkTi3/DQbhC0mceHeeiCbi0NIYDqjRPP+x8wQ
	zmtGib3rTjOBVPEKaEl86NnHDGKzCKhKXLg4kxHEZgOK739xA2ySqECYxMrpV1gg6gUlfky+
	B2aLCBhK7FnRATaUWeAfo8S8/1PYQRLCQA0Xdi8HaxYScJV4uuAbK4jNKeAmcefXdbA4s4C6
	xKR5i5ghbHmJzWveMk9gFJiFZMcsJGWzkJQtYGRexSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREc+8+kdjCubLA4xCjAwajEw+txYmWIEGtiWXFl7iFGCQ5mJRHeHZ9XhQjxpiRWVqUW5ccX
	leakFh9iNAUGwURmKdHkfGBayiuJNzQ2MTOyNDI3tDAyNlcS51WybwsREkhPLEnNTk0tSC2C
	6WPi4JRqYOxNLRZqkIprm9+dKuvOtVqfOdjkaBzPq6xFu3Z83hESzSDHuKWNI7YlYKVNpqVL
	89TdjPteBpuf6RBXdhV7uNGleIVW8iOTL1mdfxWnPL3MvX/JXOlF78SOPrytIPohtX31e5fe
	FIXmnR8POoaWWGRrVG3xEbedWubS+XupZY/8Xe0TrVanlViKMxINtZiLihMB7HiBxxMDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gently Ping.

Best Regards,
Chanwoo Choi

On 12/17/2014 08:46 AM, Chanwoo Choi wrote:
> This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
> for Exynos 32bit SoC.
> 
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Kukjin Kim <kgene.kim@samsung.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
> This patch set is tested on 64-bit Exynos SoC. I send only this patch from
> following patchst[1].
> [1] https://lkml.org/lkml/2014/12/2/134
> 
> Changes from v2:
> - None
> Changes from v1:
> - Use CONFIG_ARM instead of CONFIG_ARM64
> 
>  drivers/clocksource/Kconfig      | 1 -
>  drivers/clocksource/exynos_mct.c | 4 ++++
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
> index 9042060..27ef3fa 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -134,7 +134,6 @@ config CLKSRC_METAG_GENERIC
>  
>  config CLKSRC_EXYNOS_MCT
>  	def_bool y if ARCH_EXYNOS
> -	depends on !ARM64
>  	help
>  	  Support for Multi Core Timer controller on Exynos SoCs.
>  
> diff --git a/drivers/clocksource/exynos_mct.c b/drivers/clocksource/exynos_mct.c
> index 9403061..b840ea1 100644
> --- a/drivers/clocksource/exynos_mct.c
> +++ b/drivers/clocksource/exynos_mct.c
> @@ -223,6 +223,7 @@ static u64 notrace exynos4_read_sched_clock(void)
>  	return exynos4_read_count_32();
>  }
>  
> +#if defined(CONFIG_ARM)
>  static struct delay_timer exynos4_delay_timer;
>  
>  static cycles_t exynos4_read_current_timer(void)
> @@ -231,14 +232,17 @@ static cycles_t exynos4_read_current_timer(void)
>  			 "cycles_t needs to move to 32-bit for ARM64 usage");
>  	return exynos4_read_count_32();
>  }
> +#endif
>  
>  static void __init exynos4_clocksource_init(void)
>  {
>  	exynos4_mct_frc_start();
>  
> +#if defined(CONFIG_ARM)
>  	exynos4_delay_timer.read_current_timer = &exynos4_read_current_timer;
>  	exynos4_delay_timer.freq = clk_rate;
>  	register_current_timer_delay(&exynos4_delay_timer);
> +#endif
>  
>  	if (clocksource_register_hz(&mct_frc, clk_rate))
>  		panic("%s: can't register clocksource\n", mct_frc.name);
> 

