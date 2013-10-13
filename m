Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab3JMPpx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 11:45:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:2060 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab3JMPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 11:45:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,486,1378882800"; 
   d="scan'208";a="374127918"
Date: Sun, 13 Oct 2013 20:23:06 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: linus.walleij@linaro.org, dan.j.williams@intel.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dma: coh901318: remove deprecated IRQF_DISABLED
Message-ID: <20131013145306.GG2954@intel.com>
References: <1381640400-7146-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381640400-7146-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 07:00:00AM +0200, Michael Opdenacker wrote:
> This patch proposes to remove the use of the IRQF_DISABLED flag
> 
> It's a NOOP since 2.6.35 and it will be removed one day.
Applied, thanks

~Vinod

> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  drivers/dma/coh901318.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
> index 31011d2..3025b91 100644
> --- a/drivers/dma/coh901318.c
> +++ b/drivers/dma/coh901318.c
> @@ -2694,7 +2694,7 @@ static int __init coh901318_probe(struct platform_device *pdev)
>  	if (irq < 0)
>  		return irq;
>  
> -	err = devm_request_irq(&pdev->dev, irq, dma_irq_handler, IRQF_DISABLED,
> +	err = devm_request_irq(&pdev->dev, irq, dma_irq_handler, 0,
>  			       "coh901318", base);
>  	if (err)
>  		return err;
> -- 
> 1.8.1.2
> 

-- 
