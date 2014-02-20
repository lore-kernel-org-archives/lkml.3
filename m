Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaBTQoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 11:44:15 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35885 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755093AbaBTQoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 11:44:14 -0500
Message-ID: <530630C0.6050401@ti.com>
Date: Thu, 20 Feb 2014 18:43:44 +0200
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>,
        =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] clk: ti: am335x: remove unecessary cpu0 clk node
References: <1391019557-22313-1-git-send-email-nm@ti.com> <1391019557-22313-2-git-send-email-nm@ti.com>
In-Reply-To: <1391019557-22313-2-git-send-email-nm@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2014 08:19 PM, Nishanth Menon wrote:
> cpu0 clock node has no functionality, since cpufreq-cpu0 is already
> capable of picking up the clock from dts.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>

Acked-by: Tero Kristo <t-kristo@ti.com>

> ---
>   drivers/clk/ti/clk-33xx.c |    1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/clk/ti/clk-33xx.c b/drivers/clk/ti/clk-33xx.c
> index 776ee45..028b337 100644
> --- a/drivers/clk/ti/clk-33xx.c
> +++ b/drivers/clk/ti/clk-33xx.c
> @@ -34,7 +34,6 @@ static struct ti_dt_clk am33xx_clks[] = {
>   	DT_CLK(NULL, "dpll_core_m5_ck", "dpll_core_m5_ck"),
>   	DT_CLK(NULL, "dpll_core_m6_ck", "dpll_core_m6_ck"),
>   	DT_CLK(NULL, "dpll_mpu_ck", "dpll_mpu_ck"),
> -	DT_CLK("cpu0", NULL, "dpll_mpu_ck"),
>   	DT_CLK(NULL, "dpll_mpu_m2_ck", "dpll_mpu_m2_ck"),
>   	DT_CLK(NULL, "dpll_ddr_ck", "dpll_ddr_ck"),
>   	DT_CLK(NULL, "dpll_ddr_m2_ck", "dpll_ddr_m2_ck"),
>

