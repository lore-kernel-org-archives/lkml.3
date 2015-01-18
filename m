Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbbARKRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 05:17:54 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:60261 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbARKRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 05:17:51 -0500
Date: Sun, 18 Jan 2015 10:17:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: rtc-linux@googlegroups.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] MAINTAINERS: Add entry for Maxim PMIC-s on Samsung boards
Message-ID: <20150118101744.GF3574@x1>
References: <1421407190-6771-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421407190-6771-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2015, Krzysztof Kozlowski wrote:

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
> +F:	Documentation/devicetree/bindings/mfd/max14577.txt
> +F:	Documentation/devicetree/bindings/mfd/max77686.txt
> +F:	Documentation/devicetree/bindings/mfd/max77693.txt
> +F:	Documentation/devicetree/bindings/clock/maxim,max77686.txt
> +F:	include/linux/mfd/max14577*.h
> +F:	include/linux/mfd/max77686*.h
> +F:	include/linux/mfd/max77693*.h

Acked-by: Lee Jones <lee.jones@linaro.org>

>  MAXIRADIO FM RADIO RECEIVER DRIVER
>  M:	Hans Verkuil <hverkuil@xs4all.nl>
>  L:	linux-media@vger.kernel.org

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
