Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbbATL73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:59:29 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:42027 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbbATL70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:59:26 -0500
Date: Tue, 20 Jan 2015 11:59:20 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org
Subject: Re: [PATCH 11/14] mfd: tps65217: Constify struct regmap_config
Message-ID: <20150120115920.GW13701@x1>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
 <1420448493-9355-11-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1420448493-9355-11-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jan 2015, Krzysztof Kozlowski wrote:

> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: linux-omap@vger.kernel.org
> ---
>  drivers/mfd/tps65217.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied with Tony's Ack, thanks.

> diff --git a/drivers/mfd/tps65217.c b/drivers/mfd/tps65217.c
> index 80a919a8ca97..7d1cfc1d3ce0 100644
> --- a/drivers/mfd/tps65217.c
> +++ b/drivers/mfd/tps65217.c
> @@ -145,7 +145,7 @@ int tps65217_clear_bits(struct tps65217 *tps, unsigned int reg,
>  }
>  EXPORT_SYMBOL_GPL(tps65217_clear_bits);
>  
> -static struct regmap_config tps65217_regmap_config = {
> +static const struct regmap_config tps65217_regmap_config = {
>  	.reg_bits = 8,
>  	.val_bits = 8,
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
