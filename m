Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaBXQ0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:26:38 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:52958 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaBXQ0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:26:34 -0500
Date: Mon, 24 Feb 2014 16:26:28 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: syscon: Move diagnostic messages to dev_dbg()
Message-ID: <20140224162628.GH15847@lee--X1>
References: <1393048945-15142-1-git-send-email-shc_work@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393048945-15142-1-git-send-email-shc_work@mail.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch moves diagnostic messages used for debugging purposes
> to dev_dbg().
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/mfd/syscon.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
> index 71841f9..2620056 100644
> --- a/drivers/mfd/syscon.c
> +++ b/drivers/mfd/syscon.c
> @@ -152,7 +152,7 @@ static int syscon_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, syscon);
>  
> -	dev_info(dev, "regmap %pR registered\n", res);
> +	dev_dbg(dev, "regmap %pR registered\n", res);
>  
>  	return 0;
>  }

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
