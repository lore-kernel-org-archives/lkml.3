Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946012AbaD3Wtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:49:33 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:52859 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422662AbaD3Wtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:49:31 -0400
Message-ID: <53617DF8.4060609@gmail.com>
Date: Thu, 01 May 2014 00:49:28 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
CC: kgene.kim@samsung.com, mturquette@linaro.org, sw0312.kim@samsung.com,
        rob.herring@calxeda.com, kishon@ti.com, a.hajda@samsung.com,
        kyungmin.park@samsung.com, sylvester.nawrocki@gmail.com
Subject: Re: [PATCH 2/4] clk: exynos4: export sclk_hdmiphy clock
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com> <1396623201-26000-3-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1396623201-26000-3-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04.04.2014 16:53, Tomasz Stanislawski wrote:
> Export sclk_hdmiphy clock to be usable from DT.
>
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> ---
>   drivers/clk/samsung/clk-exynos4.c   |    2 +-
>   include/dt-bindings/clock/exynos4.h |    1 +
>   2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/samsung/clk-exynos4.c b/drivers/clk/samsung/clk-exynos4.c
> index b4f9672..528f8eb 100644
> --- a/drivers/clk/samsung/clk-exynos4.c
> +++ b/drivers/clk/samsung/clk-exynos4.c
> @@ -428,7 +428,7 @@ static struct samsung_fixed_rate_clock exynos4_fixed_rate_ext_clks[] __initdata
>   /* fixed rate clocks generated inside the soc */
>   static struct samsung_fixed_rate_clock exynos4_fixed_rate_clks[] __initdata = {
>   	FRATE(0, "sclk_hdmi24m", NULL, CLK_IS_ROOT, 24000000),
> -	FRATE(0, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
> +	FRATE(CLK_SCLK_HDMIPHY, "sclk_hdmiphy", NULL, CLK_IS_ROOT, 27000000),
>   	FRATE(0, "sclk_usbphy0", NULL, CLK_IS_ROOT, 48000000),
>   };
>
> diff --git a/include/dt-bindings/clock/exynos4.h b/include/dt-bindings/clock/exynos4.h
> index 75aff33..0e245eb 100644
> --- a/include/dt-bindings/clock/exynos4.h
> +++ b/include/dt-bindings/clock/exynos4.h
> @@ -33,6 +33,7 @@
>   #define CLK_MOUT_MPLL_USER_C	18 /* Exynos4x12 only */
>   #define CLK_MOUT_CORE		19
>   #define CLK_MOUT_APLL		20
> +#define CLK_SCLK_HDMIPHY	22
>
>   /* gate for special clocks (sclk) */
>   #define CLK_SCLK_FIMC0		128
>

Applied.

Best regards,
Tomasz
