Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932720AbaESRPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:15:39 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:56506 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaESRPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:15:37 -0400
Date: Mon, 19 May 2014 18:15:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 3/3] mfd: arizona: Correct error message for
 addition of main IRQ chip
Message-ID: <20140519171532.GC20435@lee--X1>
References: <1400517329-1103-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1400517329-1103-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400517329-1103-3-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/arizona-irq.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/arizona-irq.c b/drivers/mfd/arizona-irq.c
> index 88758ab..17102f5 100644
> --- a/drivers/mfd/arizona-irq.c
> +++ b/drivers/mfd/arizona-irq.c
> @@ -285,7 +285,7 @@ int arizona_irq_init(struct arizona *arizona)
>  				  IRQF_ONESHOT, -1, irq,
>  				  &arizona->irq_chip);
>  	if (ret != 0) {
> -		dev_err(arizona->dev, "Failed to add AOD IRQs: %d\n", ret);
> +		dev_err(arizona->dev, "Failed to add main IRQs: %d\n", ret);
>  		goto err_aod;
>  	}
>  

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
