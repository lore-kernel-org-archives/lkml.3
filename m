Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbbAFRPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:15:39 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20277 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932240AbbAFRPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:15:37 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+AmBDLePyOtVwNE9TOX+N2
Date: Tue, 6 Jan 2015 09:11:46 -0800
From: Tony Lindgren <tony@atomide.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 11/14] mfd: tps65217: Constify struct regmap_config
Message-ID: <20150106171146.GR4081@atomide.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
 <1420448493-9355-11-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420448493-9355-11-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Krzysztof Kozlowski <k.kozlowski@samsung.com> [150105 01:04]:
> The regmap_config struct may be const because it is not modified by the
> driver and regmap_init() accepts pointer to const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Acked-by: Tony Lindgren <tony@atomide.com>

> Cc: linux-omap@vger.kernel.org
> ---
>  drivers/mfd/tps65217.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
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
> -- 
> 1.9.1
> 
