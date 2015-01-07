Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbbAGJEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:04:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52703 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbbAGJEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:04:35 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-f3-54acf6a10ad7
Message-id: <1420621470.3893.6.camel@AMDC1943>
Subject: Re: [PATCH] ARM: exynos_defconfig: Enable CONFIG_LOCKUP_DETECTOR
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Anand Moon <moon.linux@yahoo.com>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>,
        Sachin Kamat <sachin.kamat@samsung.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 07 Jan 2015 10:04:30 +0100
In-reply-to: <1420566151-7136-1-git-send-email-moon.linux@yahoo.com>
References: <1420566151-7136-1-git-send-email-moon.linux@yahoo.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t/xy7oLv60JMTh6U8Li7LKDbBZtVw6y
	Wxz9XWDR//g1s8Wmx9dYLS7vmsNmMeP8PiaL25d5La7fn8Zs8XjFW3aLK5dOsVm0/93L5sDj
	0dLcw+Yxu+Eii8ff59dZPBbvecnksWlVJ5vHnWt72Dw2L6n36NuyitHj8yY5j1mzDjMFcEVx
	2aSk5mSWpRbp2yVwZWy7/oa94ChnxdGOU4wNjN/Zuxg5OSQETCRuf1rLBGGLSVy4t56ti5GL
	Q0hgKaPE3PW3oJzPjBJ9C/exgFTxCuhJ9N67CJTg4BAW8JQ4vIwXJMwmYCyxefkSNhBbREBV
	4kHrVVYQm1ngArPEys8VIDYLUHzJ1EmMIDangIvEvBMXmEFsIQFnifOXPkDVq0tMmreIGWS8
	hICyRGO/G8RWQYkfk++xQJTIS2xe85Z5AqPALCQds5CUzUJStoCReRWjaGppckFxUnqukV5x
	Ym5xaV66XnJ+7iZGSAR93cG49JjVIUYBDkYlHl6FyWtChFgTy4orcw8xSnAwK4nwWnUChXhT
	EiurUovy44tKc1KLDzEycXBKNTDuCqgJ+B915OIudkam4tn5cwz95kZohLf0Ry898O5hemOT
	JZfCwT36yT/XS23hM1JPmid4WPj6rPf8K7KL96wrL9e2OsnEpuAnFnn0mxCv3NKpF3auvPvn
	c+a+atnMvKUng56IvdpiuVfA4XfRTf2tH9PZJs3f7S+QsO0167tlf5e43X0ue6BAiaU4I9FQ
	i7moOBEAHgGd/n4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2015-01-06 at 23:12 +0530, Anand Moon wrote:
> ARM Enable CONFIG_LOCKUP_DETECTOR to validaion of kernel locks
s/validaion/validation/

This config item helps getting some useful information when lockup
happens. If you want to validate locks then probably you want
PROVE_LOCKING... but its overhead is larger.

Anyway the overhead of LOCKUP_DETECTOR is small and multi_v7_defconfig
has it enabled so I guess exynos may do it as well.

Could you only fix up the commit msg?


Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>


Best regards,
Krzysztof

> 
> Tested on Exynos5422 ODROID XU3 board.
> 
> Signed-off-by: Anand Moon <moon.linux@yahoo.com>
> ---
>  arch/arm/configs/exynos_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/configs/exynos_defconfig b/arch/arm/configs/exynos_defconfig
> index 5ef14de..ecd9987 100644
> --- a/arch/arm/configs/exynos_defconfig
> +++ b/arch/arm/configs/exynos_defconfig
> @@ -178,6 +178,7 @@ CONFIG_PRINTK_TIME=y
>  CONFIG_DEBUG_FS=y
>  CONFIG_MAGIC_SYSRQ=y
>  CONFIG_DEBUG_KERNEL=y
> +CONFIG_LOCKUP_DETECTOR=y
>  CONFIG_DETECT_HUNG_TASK=y
>  CONFIG_DEBUG_RT_MUTEXES=y
>  CONFIG_DEBUG_SPINLOCK=y

