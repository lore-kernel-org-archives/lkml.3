Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbbAWHgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 02:36:31 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:54556 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbbAWHg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 02:36:29 -0500
MIME-Version: 1.0
In-Reply-To: <1421955259-8875-1-git-send-email-sboyd@codeaurora.org>
References: <1421955259-8875-1-git-send-email-sboyd@codeaurora.org>
Date: Fri, 23 Jan 2015 08:36:28 +0100
Message-ID: <CAPDyKFrVseR_Mczn5q0pjcMk6SN1HCebWTis4wOfcH+vfEDnRA@mail.gmail.com>
Subject: Re: [PATCH] clk: ux500: Drop use of clk-private.h
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 January 2015 at 20:34, Stephen Boyd <sboyd@codeaurora.org> wrote:
> These drivers don't need to include clk-private.h. Remove the
> include.
>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

Acked-by: Ulf Hansson <ulf.hansson@linaro.org>

I suppose you can queue this through your clk tree directly?

Kind regards
Uffe

> ---
>  drivers/clk/ux500/clk-prcc.c  | 1 -
>  drivers/clk/ux500/clk-prcmu.c | 1 -
>  2 files changed, 2 deletions(-)
>
> diff --git a/drivers/clk/ux500/clk-prcc.c b/drivers/clk/ux500/clk-prcc.c
> index bd4769a84485..0e950769ed03 100644
> --- a/drivers/clk/ux500/clk-prcc.c
> +++ b/drivers/clk/ux500/clk-prcc.c
> @@ -8,7 +8,6 @@
>   */
>
>  #include <linux/clk-provider.h>
> -#include <linux/clk-private.h>
>  #include <linux/slab.h>
>  #include <linux/io.h>
>  #include <linux/err.h>
> diff --git a/drivers/clk/ux500/clk-prcmu.c b/drivers/clk/ux500/clk-prcmu.c
> index e2d63bc47436..bf63c96acb1a 100644
> --- a/drivers/clk/ux500/clk-prcmu.c
> +++ b/drivers/clk/ux500/clk-prcmu.c
> @@ -8,7 +8,6 @@
>   */
>
>  #include <linux/clk-provider.h>
> -#include <linux/clk-private.h>
>  #include <linux/mfd/dbx500-prcmu.h>
>  #include <linux/slab.h>
>  #include <linux/io.h>
> --
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> a Linux Foundation Collaborative Project
>
