Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbbANEJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 23:09:15 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:50774 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbbANEJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 23:09:13 -0500
Date: Wed, 14 Jan 2015 13:09:10 +0900
From: Simon Horman <horms@verge.net.au>
To: weiyj_lk@163.com
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] clk: shmobile: fix sparse NULL pointer warning
Message-ID: <20150114040910.GC14661@verge.net.au>
References: <1421198183-17417-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421198183-17417-1-git-send-email-weiyj_lk@163.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 09:16:23AM +0800, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fixes the following sparse warnings:
> 
> drivers/clk/shmobile/clk-sh73a0.c:57:17: warning:
>  Using plain integer as NULL pointer
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  drivers/clk/shmobile/clk-sh73a0.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/shmobile/clk-sh73a0.c b/drivers/clk/shmobile/clk-sh73a0.c
> index 8574a6d..cd529cf 100644
> --- a/drivers/clk/shmobile/clk-sh73a0.c
> +++ b/drivers/clk/shmobile/clk-sh73a0.c
> @@ -54,7 +54,7 @@ static struct div4_clk div4_clks[] = {
>  	{ "m2", "pll1", CPG_FRQCRA,  0 },
>  	{ "zx", "pll1", CPG_FRQCRB, 12 },
>  	{ "hp", "pll1", CPG_FRQCRB,  4 },
> -	{ NULL, 0, 0, 0 },
> +	{ NULL, NULL, 0, 0 },
>  };
>  
>  static const struct clk_div_table div4_div_table[] = {
> 
