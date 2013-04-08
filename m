Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936547Ab3DHPr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:47:29 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:20221 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936441Ab3DHPr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:47:27 -0400
Message-ID: <5162E68D.5070909@atmel.com>
Date: Mon, 8 Apr 2013 17:47:25 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <trivial@kernel.org>
Subject: Re: [PATCH 1/2] ARM: at91/setup: fix trivial typos
References: <1365346199-29525-1-git-send-email-jhovold@gmail.com>
In-Reply-To: <1365346199-29525-1-git-send-email-jhovold@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 04:49 PM, Johan Hovold :
> Fix a few trivial typos in panic, warning and debug messages.
> 
> Signed-off-by: Johan Hovold <jhovold@gmail.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  arch/arm/mach-at91/setup.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
> index 4b67847..9e7c1e1 100644
> --- a/arch/arm/mach-at91/setup.c
> +++ b/arch/arm/mach-at91/setup.c
> @@ -333,7 +333,7 @@ static void at91_dt_rstc(void)
>  
>  	of_id = of_match_node(rstc_ids, np);
>  	if (!of_id)
> -		panic("AT91: rtsc no restart function availlable\n");
> +		panic("AT91: rtsc no restart function available\n");

This one is stacked up.

>  
>  	arm_pm_restart = of_id->data;
>  
> @@ -353,7 +353,7 @@ static void at91_dt_ramc(void)
>  
>  	np = of_find_matching_node(NULL, ramc_ids);
>  	if (!np)
> -		panic("unable to find compatible ram conroller node in dtb\n");
> +		panic("unable to find compatible ram controller node in dtb\n");
>  
>  	at91_ramc_base[0] = of_iomap(np, 0);
>  	if (!at91_ramc_base[0])
> @@ -403,7 +403,7 @@ static void at91_dt_shdwc(void)
>  
>  	np = of_find_matching_node(NULL, shdwc_ids);
>  	if (!np) {
> -		pr_debug("AT91: unable to find compatible shutdown (shdwc) conroller node in dtb\n");
> +		pr_debug("AT91: unable to find compatible shutdown (shdwc) controller node in dtb\n");
>  		return;
>  	}
>  
> @@ -419,7 +419,7 @@ static void at91_dt_shdwc(void)
>  
>  	if (!of_property_read_u32(np, "atmel,wakeup-counter", &reg)) {
>  		if (reg > AT91_SHDW_CPTWK0_MAX) {
> -			pr_warn("AT91: shdwc wakeup conter 0x%x > 0x%x reduce it to 0x%x\n",
> +			pr_warn("AT91: shdwc wakeup counter 0x%x > 0x%x reduce it to 0x%x\n",
>  				reg, AT91_SHDW_CPTWK0_MAX, AT91_SHDW_CPTWK0_MAX);
>  			reg = AT91_SHDW_CPTWK0_MAX;
>  		}

The remaining bytes are now included in at91-3.10-cleanup branch.

Thanks,
-- 
Nicolas Ferre
