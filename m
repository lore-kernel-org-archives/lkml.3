Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3LQJdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 04:33:14 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:19889 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab3LQJdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 04:33:07 -0500
Message-ID: <52B01A50.4080209@atmel.com>
Date: Tue, 17 Dec 2013 10:33:04 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Boris BREZILLON <b.brezillon@overkiz.com>,
        Mike Turquette <mturquette@linaro.org>
CC: Fengguang Wu <fengguang.wu@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: at91: fix pmc_clk_ids data type attriubte
References: <1387229127-7605-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1387229127-7605-1-git-send-email-b.brezillon@overkiz.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/12/2013 22:25, Boris BREZILLON :
> Fix pmc_clk_ids data type attribute (__initdata -> __initconst).
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

I take it in at91-3.14-cleanup2 branch and send it upstream through
arm-soc like any other CCF material for AT91 for the 3.14 release.

I guess that even without Mike Acked-by, this little fix can follow this
path.

Bye,

> ---
>  drivers/clk/at91/pmc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/at91/pmc.c b/drivers/clk/at91/pmc.c
> index 7b9db60..4c03eda 100644
> --- a/drivers/clk/at91/pmc.c
> +++ b/drivers/clk/at91/pmc.c
> @@ -228,7 +228,7 @@ out_free_pmc:
>  	return NULL;
>  }
>  
> -static const struct of_device_id pmc_clk_ids[] __initdata = {
> +static const struct of_device_id pmc_clk_ids[] __initconst = {
>  	/* Main clock */
>  	{
>  		.compatible = "atmel,at91rm9200-clk-main",
> 


-- 
Nicolas Ferre
