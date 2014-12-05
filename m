Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933578AbaLEDaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:30:25 -0500
Received: from smtp.mei.co.jp ([133.183.100.20]:58959 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaLEDaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:30:24 -0500
Date: Fri, 05 Dec 2014 12:29:39 +0900
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH] clk: remove unnecessary substitution
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
In-Reply-To: <1390889387-24137-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1390889387-24137-1-git-send-email-yamada.m@jp.panasonic.com>
X-BkSecure-Plugin: BkSecure.dll Ver 1, 2, 7, 0
Message-Id: <20141205122939.E213.AA925319@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.64.06 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Mike Turquette

I posted this trivial fix about 10 months ago.

Is it applicable?



On Tue, 28 Jan 2014 15:09:47 +0900
Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:

> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
>  drivers/clk/clk.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 2b38dc9..d97b313 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1637,7 +1637,7 @@ static struct clk *__clk_init_parent(struct clk *clk)
>  
>  	if (clk->num_parents == 1) {
>  		if (IS_ERR_OR_NULL(clk->parent))
> -			ret = clk->parent = __clk_lookup(clk->parent_names[0]);
> +			clk->parent = __clk_lookup(clk->parent_names[0]);
>  		ret = clk->parent;
>  		goto out;
>  	}
> -- 
> 1.8.3.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


