Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaBLLmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:42:04 -0500
Received: from top.free-electrons.com ([176.31.233.9]:43600 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751767AbaBLLmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:42:02 -0500
Date: Wed, 12 Feb 2014 12:42:00 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        Josh Wu <josh.wu@atmel.com>, computersforpeace@gmail.com,
        linux-kernel@vger.kernel.org, dedekind1@gmail.com
Subject: Re: [PATCH] MTD: atmel_nand: POI fall back is not an issue: change
 log level
Message-ID: <20140212114200.GA11498@piout.net>
References: <1392204414-20700-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392204414-20700-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small nitpick, subject should read PIO, not POI.

On 12/02/2014 at 12:26:54 +0100, Nicolas Ferre wrote :
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/mtd/nand/atmel_nand.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
> index c36e9b84487c..8d210f8a072d 100644
> --- a/drivers/mtd/nand/atmel_nand.c
> +++ b/drivers/mtd/nand/atmel_nand.c
> @@ -430,7 +430,7 @@ err_dma:
>  	dma_unmap_single(dma_dev->dev, phys_addr, len, dir);
>  err_buf:
>  	if (err != 0)
> -		dev_warn(host->dev, "Fall back to CPU I/O\n");
> +		dev_dbg(host->dev, "Fall back to CPU I/O\n");
>  	return err;
>  }
>  
> -- 
> 1.8.2.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
