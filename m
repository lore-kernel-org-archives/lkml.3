Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab3KNAHn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 19:07:43 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:37818 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3KNAHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 19:07:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linus.walleij@linaro.org, grant.likely@secretlab.ca,
        horms@verge.net.au
Subject: Re: [PATCH 02/03] gpio: em: Setup gpiochip->dev
Date: Thu, 14 Nov 2013 01:08:14 +0100
Message-ID: <6382126.xmUMBJLTFI@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.17-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20131113225946.21449.68990.sendpatchset@w520>
References: <20131113225927.21449.78044.sendpatchset@w520> <20131113225946.21449.68990.sendpatchset@w520>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

Thank you for the patch.

On Thursday 14 November 2013 07:59:46 Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Make sure gpio_chip->dev is setup so of_gpiochip_add()
> will work as expected.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> 
>  drivers/gpio/gpio-em.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- 0001/drivers/gpio/gpio-em.c
> +++ work/drivers/gpio/gpio-em.c	2013-11-13 20:47:40.000000000 +0900
> @@ -327,6 +327,7 @@ static int em_gio_probe(struct platform_
>  	gpio_chip->request = em_gio_request;
>  	gpio_chip->free = em_gio_free;
>  	gpio_chip->label = name;
> +	gpio_chip->dev = &pdev->dev;
>  	gpio_chip->owner = THIS_MODULE;
>  	gpio_chip->base = pdata->gpio_base;
>  	gpio_chip->ngpio = pdata->number_of_pins;
-- 
Regards,

Laurent Pinchart

