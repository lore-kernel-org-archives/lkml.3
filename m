Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3LSID7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:03:59 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:54924 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753029Ab3LSID5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:03:57 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        "Fengguang Wu" <fengguang.wu@intel.com>,
        "Nicolas Ferre" <nicolas.ferre@atmel.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1387229127-7605-1-git-send-email-b.brezillon@overkiz.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Boris BREZILLON" <b.brezillon@overkiz.com>
References: <1387229127-7605-1-git-send-email-b.brezillon@overkiz.com>
Message-ID: <20131219075636.18119.74853@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: at91: fix pmc_clk_ids data type attriubte
Date: Wed, 18 Dec 2013 23:56:36 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Boris BREZILLON (2013-12-16 13:25:27)
> Fix pmc_clk_ids data type attribute (__initdata -> __initconst).
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Mike Turquette <mturquette@linaro.org>

> ---
>  drivers/clk/at91/pmc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
> index 7b9db60..4c03eda 100644
> --- a/drivers/clk/at91/pmc.c
> +++ b/drivers/clk/at91/pmc.c
> @@ -228,7 +228,7 @@ out_free_pmc:
>         return NULL;
>  }
>  
> -static const struct of_device_id pmc_clk_ids[] __initdata = {
> +static const struct of_device_id pmc_clk_ids[] __initconst = {
>         /* Main clock */
>         {
>                 .compatible = "atmel,at91rm9200-clk-main",
> -- 
> 1.7.9.5
> 
