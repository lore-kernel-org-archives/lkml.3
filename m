Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbaBFQHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 11:07:04 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40613 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbaBFQHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 11:07:03 -0500
Date: Thu, 6 Feb 2014 17:06:42 +0100
From: "'Johan Hovold'" <jhovold@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "'Johan Hovold'" <jhovold@gmail.com>
Subject: Re: [PATCH 09/12] backlight: lm3533_bl: Remove unnecessary OOM
 messages
Message-ID: <20140206160642.GA30591@localhost>
References: <000101cf2313$6ef38e80$4cdaab80$%han@samsung.com>
 <000a01cf2315$0110d740$033285c0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01cf2315$0110d740$033285c0$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 06, 2014 at 05:25:33PM +0900, Jingoo Han wrote:
> The site-specific OOM messages are unnecessary, because they
> duplicate the MM subsystem generic OOM message.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Acked-by: Johan Hovold <jhovold@gmail.com>

Thanks,
Johan

> ---
>  drivers/video/backlight/lm3533_bl.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
> index 187d1c2..cff1fbe 100644
> --- a/drivers/video/backlight/lm3533_bl.c
> +++ b/drivers/video/backlight/lm3533_bl.c
> @@ -296,11 +296,8 @@ static int lm3533_bl_probe(struct platform_device *pdev)
>  	}
>  
>  	bl = devm_kzalloc(&pdev->dev, sizeof(*bl), GFP_KERNEL);
> -	if (!bl) {
> -		dev_err(&pdev->dev,
> -				"failed to allocate memory for backlight\n");
> +	if (!bl)
>  		return -ENOMEM;
> -	}
>  
>  	bl->lm3533 = lm3533;
>  	bl->id = pdev->id;
