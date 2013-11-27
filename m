Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756553Ab3K0Oaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:30:35 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:63877 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3K0Oa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:30:29 -0500
Date: Wed, 27 Nov 2013 14:30:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] mfd: max14577: Match regulator by of_compatible string
Message-ID: <20131127143023.GM3296@lee--X1>
References: <1385561777-20499-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1385561777-20499-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Match max14577 regulator driver by of_compatible specified in mfd_cell.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  drivers/mfd/max14577.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
> index 94b766d..1337c45 100644
> --- a/drivers/mfd/max14577.c
> +++ b/drivers/mfd/max14577.c
> @@ -26,7 +26,10 @@
>  
>  static struct mfd_cell max14577_devs[] = {
>  	{ .name = "max14577-muic", },
> -	{ .name = "max14577-regulator", },
> +	{
> +		.name = "max14577-regulator",
> +		.of_compatible = "maxim,max14577-regulator",
> +	},
>  	{ .name = "max14577-charger", },
>  };
>  

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
