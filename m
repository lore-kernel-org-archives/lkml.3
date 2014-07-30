Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168AbaG3HZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:25:11 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:48655 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135AbaG3HZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:25:09 -0400
Date: Wed, 30 Jul 2014 08:25:04 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] mfd: ab8500-core: Use 'ifdef' for config options
Message-ID: <20140730072504.GD9030@lee--X1>
References: <1406683788-7776-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406683788-7776-1-git-send-email-festevam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2014, Fabio Estevam wrote:

> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> The config symbol 'CONFIG_DEBUG_FS' should be protected by a 'ifdef' instead
> of a plain 'if'.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
>  drivers/mfd/ab8500-core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

> diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
> index ce48aa7..bde2fc0 100644
> --- a/drivers/mfd/ab8500-core.c
> +++ b/drivers/mfd/ab8500-core.c
> @@ -1754,7 +1754,7 @@ static int ab8500_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> -#if CONFIG_DEBUG_FS
> +#ifdef CONFIG_DEBUG_FS
>  	/* Pass to debugfs */
>  	ab8500_debug_resources[0].start = ab8500->irq;
>  	ab8500_debug_resources[0].end = ab8500->irq;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
