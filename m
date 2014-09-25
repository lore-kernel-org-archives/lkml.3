Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaIYVrL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 17:47:11 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:42632 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbaIYVrI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 17:47:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mark yao <mark.yao@rock-chips.com>, heiko@sntech.de
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1410513887-17459-1-git-send-email-mark.yao@rock-chips.com>
Cc: linux-kernel@vger.kernel.org, djkurtz@chromium.org, dianders@chromium.org,
        dkl@rock-chips.com, eddie.cai@rock-chips.com, xjq@rock-chips.com,
        kfx@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yxj@rock-chips.com, cym@rock-chips.com, zhengsq@rock-chips.com,
        caesar.wang@rock-chips.com, kever.yang@rock-chips.com,
        "Mark yao" <mark.yao@rock-chips.com>
References: <1410513887-17459-1-git-send-email-mark.yao@rock-chips.com>
Message-ID: <20140925214645.19023.94336@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: rockchip: rk3288: fix softreset register count
Date: Thu, 25 Sep 2014 14:46:45 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mark yao (2014-09-12 02:24:46)
> The rk3288 actually has 12 softresets, so fix the register count.
> 
> Signed-off-by: Mark yao <mark.yao@rock-chips.com>

Applied to clk-next.

Regards,
Mike

> ---
>  drivers/clk/rockchip/clk-rk3288.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
> index 0d8c6c5..2e1d790 100644
> --- a/drivers/clk/rockchip/clk-rk3288.c
> +++ b/drivers/clk/rockchip/clk-rk3288.c
> @@ -711,7 +711,7 @@ static void __init rk3288_clk_init(struct device_node *np)
>         rockchip_clk_register_branches(rk3288_clk_branches,
>                                   ARRAY_SIZE(rk3288_clk_branches));
>  
> -       rockchip_register_softrst(np, 9, reg_base + RK3288_SOFTRST_CON(0),
> +       rockchip_register_softrst(np, 12, reg_base + RK3288_SOFTRST_CON(0),
>                                   ROCKCHIP_SOFTRST_HIWORD_MASK);
>  }
>  CLK_OF_DECLARE(rk3288_cru, "rockchip,rk3288-cru", rk3288_clk_init);
> -- 
> 1.9.1
> 
