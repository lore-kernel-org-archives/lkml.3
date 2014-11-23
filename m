Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaKWAwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 19:52:49 -0500
Received: from gloria.sntech.de ([95.129.55.99]:45554 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbaKWAws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 19:52:48 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>
Cc: Mike Turquette <mturquette@linaro.org>,
        "moderated list:ARM/Rockchip SoC..." 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "open list:COMMON CLK FRAMEWORK" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: rockchip: fix rk3188 USB HSIC PHY clock divider
Date: Sun, 23 Nov 2014 01:56:27 +0100
Message-ID: <27247166.7eBDsnluOf@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1416564527-21327-1-git-send-email-julien.chauveau@neo-technologies.fr>
References: <1416564527-21327-1-git-send-email-julien.chauveau@neo-technologies.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 21. November 2014, 11:08:47 schrieb Julien CHAUVEAU:
> The USB HSIC PHY clock divider is set in the register RK2928_CLKSEL_CON(11).
> 
> Signed-off-by: Julien CHAUVEAU <julien.chauveau@neo-technologies.fr>

applied to my clk branch for 3.19


Thanks
Heiko

> ---
>  drivers/clk/rockchip/clk-rk3188.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3188.c
> b/drivers/clk/rockchip/clk-rk3188.c index 725d841..f27ea47 100644
> --- a/drivers/clk/rockchip/clk-rk3188.c
> +++ b/drivers/clk/rockchip/clk-rk3188.c
> @@ -664,7 +664,7 @@ static struct rockchip_clk_branch rk3188_clk_branches[]
> __initdata = { RK2928_CLKSEL_CON(30), 0, 2, DFLAGS,
>  			RK2928_CLKGATE_CON(3), 6, GFLAGS),
>  	DIV(0, "sclk_hsicphy_12m", "sclk_hsicphy_480m", 0,
> -			RK2928_CLKGATE_CON(11), 8, 6, DFLAGS),
> +			RK2928_CLKSEL_CON(11), 8, 6, DFLAGS),
> 
>  	MUX(0, "i2s_src", mux_pll_src_gpll_cpll_p, 0,
>  			RK2928_CLKSEL_CON(2), 15, 1, MFLAGS),

