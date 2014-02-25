Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227AbaBYIYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:24:20 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56054 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbaBYIYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:24:18 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Nishanth Menon <nm@ti.com>,
        =?utf-8?q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        "Tony Lindgren" <tony@atomide.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1391019557-22313-2-git-send-email-nm@ti.com>
Cc: "Tero Kristo" <t-kristo@ti.com>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, "Nishanth Menon" <nm@ti.com>
References: <1391019557-22313-1-git-send-email-nm@ti.com>
 <1391019557-22313-2-git-send-email-nm@ti.com>
Message-ID: <20140225082411.22529.21466@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 1/2] clk: ti: am335x: remove unecessary cpu0 clk node
Date: Tue, 25 Feb 2014 00:24:11 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Nishanth Menon (2014-01-29 10:19:16)
> cpu0 clock node has no functionality, since cpufreq-cpu0 is already
> capable of picking up the clock from dts.
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Taken into clk-next!

Regards,
Mike

> ---
>  drivers/clk/ti/clk-33xx.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/clk/ti/clk-33xx.c b/drivers/clk/ti/clk-33xx.c
> index 776ee45..028b337 100644
> --- a/drivers/clk/ti/clk-33xx.c
> +++ b/drivers/clk/ti/clk-33xx.c
> @@ -34,7 +34,6 @@ static struct ti_dt_clk am33xx_clks[] = {
>         DT_CLK(NULL, "dpll_core_m5_ck", "dpll_core_m5_ck"),
>         DT_CLK(NULL, "dpll_core_m6_ck", "dpll_core_m6_ck"),
>         DT_CLK(NULL, "dpll_mpu_ck", "dpll_mpu_ck"),
> -       DT_CLK("cpu0", NULL, "dpll_mpu_ck"),
>         DT_CLK(NULL, "dpll_mpu_m2_ck", "dpll_mpu_m2_ck"),
>         DT_CLK(NULL, "dpll_ddr_ck", "dpll_ddr_ck"),
>         DT_CLK(NULL, "dpll_ddr_m2_ck", "dpll_ddr_m2_ck"),
> -- 
> 1.7.9.5
> 
