Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbaLKUOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:14:37 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58047 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758327AbaLKUOg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:14:36 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: weiyj_lk@163.com, "Stephen Boyd" <sboyd@codeaurora.org>,
        "Chao Xie" <chao.xie@marvell.com>,
        "Haojian Zhuang" <haojian.zhuang@gmail.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1418087250-14258-1-git-send-email-weiyj_lk@163.com>
Cc: "Wei Yongjun" <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
References: <1418087250-14258-1-git-send-email-weiyj_lk@163.com>
Message-ID: <20141211201430.20398.17421@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH -next] clk: mmp: fix sparse non static symbol warning
Date: Thu, 11 Dec 2014 12:14:30 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting weiyj_lk@163.com (2014-12-08 17:07:30)
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warnings:
> 
> drivers/clk/mmp/clk-frac.c:113:6: warning:
>  symbol 'clk_factor_init' was not declared. Should it be static?
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied.

Thanks,
Mike

> ---
>  drivers/clk/mmp/clk-frac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/mmp/clk-frac.c b/drivers/clk/mmp/clk-frac.c
> index eeba52c..584a992 100644
> --- a/drivers/clk/mmp/clk-frac.c
> +++ b/drivers/clk/mmp/clk-frac.c
> @@ -110,7 +110,7 @@ static int clk_factor_set_rate(struct clk_hw *hw, unsigned long drate,
>         return 0;
>  }
>  
> -void clk_factor_init(struct clk_hw *hw)
> +static void clk_factor_init(struct clk_hw *hw)
>  {
>         struct mmp_clk_factor *factor = to_clk_factor(hw);
>         struct mmp_clk_factor_masks *masks = factor->masks;
> 
