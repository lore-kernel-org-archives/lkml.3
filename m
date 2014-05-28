Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbaE1JAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:00:16 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:64033 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707AbaE1JAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:00:12 -0400
Message-ID: <5385A5AA.8070402@linaro.org>
Date: Wed, 28 May 2014 11:00:26 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Chander Kashyap <chander.kashyap@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, lorenzo.pieralisi@arm.com,
        rjw@rjwysocki.net, kgene.kim@samsung.com, tomasz.figa@gmail.com,
        Chander Kashyap <k.chander@samsung.com>
Subject: Re: [PATCH v6 3/6] cpuidle: config: Add ARCH_EXYNOS entry to select
 cpuidle-big-little driver
References: <CANuQgHGSA+R__raSa_tzrgpceqLD2SZw+s0XQUHGF4wscgh6Kg@mail.gmail.com> <1400227438-27155-1-git-send-email-chander.kashyap@linaro.org> <1400227438-27155-4-git-send-email-chander.kashyap@linaro.org>
In-Reply-To: <1400227438-27155-4-git-send-email-chander.kashyap@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2014 10:03 AM, Chander Kashyap wrote:
> Add support to select generic big-little cpuidle driver for Samsung Exynos
> series SoC's. This is required for Exynos big-llittle SoC's eg, Exynos5420.
>
> Signed-off-by: Chander Kashyap <chander.kashyap@linaro.org>
> Signed-off-by: Chander Kashyap <k.chander@samsung.com>

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

> ---
> Changes in v4:
> 	1. Typo fixed from SOC_EXYNOS5420 to ARCH_EXYNOS
> 	2. Commit message updated
> Changes in v3: None
> Changes in v2:
> 	1. Changed config macro from SOC_EXYNOS5420 to ARCH_EXYNOS
>   drivers/cpuidle/Kconfig.arm |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/Kconfig.arm b/drivers/cpuidle/Kconfig.arm
> index 97ccc31..d9596e7 100644
> --- a/drivers/cpuidle/Kconfig.arm
> +++ b/drivers/cpuidle/Kconfig.arm
> @@ -4,7 +4,7 @@
>
>   config ARM_BIG_LITTLE_CPUIDLE
>   	bool "Support for ARM big.LITTLE processors"
> -	depends on ARCH_VEXPRESS_TC2_PM
> +	depends on ARCH_VEXPRESS_TC2_PM || ARCH_EXYNOS
>   	select ARM_CPU_SUSPEND
>   	select CPU_IDLE_MULTIPLE_DRIVERS
>   	help
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

