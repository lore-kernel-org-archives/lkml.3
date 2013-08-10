Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab3HJWSe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 18:18:34 -0400
Received: from smtp7.oregonstate.edu ([128.193.15.44]:57758 "EHLO
	smtp7.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875Ab3HJWSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 18:18:32 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Aug 2013 18:18:31 EDT
Date: Sat, 10 Aug 2013 15:10:43 -0700
From: Kevin Strasser <strassek@engr.orst.edu>
To: Michael Brunner <mibru@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chris Healy <chealy@imsco-us.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org
Subject: Re: [PATCH] gpio: Fix platform driver name in Kontron PLD GPIO driver
Message-ID: <20130810221043.GC18039@flip3.engr.oregonstate.edu>
References: <20130809173306.1ba24b59@mail.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809173306.1ba24b59@mail.gmx.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 05:33:06PM +0200, Michael Brunner wrote:
> This patch changes the driver name to be consistent with the name that
> is registered as cell name in the MFD driver. Otherwise the driver won't
> load.
> 
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>

Acked-by: Kevin Strasser <strassek@engr.orst.edu>

> ---
>  drivers/gpio/gpio-kempld.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpio-kempld.c b/drivers/gpio/gpio-kempld.c
> index 1bdc3a2..d3ed563 100644
> --- a/drivers/gpio/gpio-kempld.c
> +++ b/drivers/gpio/gpio-kempld.c
> @@ -210,7 +210,7 @@ static int kempld_gpio_remove(struct
> platform_device *pdev) 
>  static struct platform_driver kempld_gpio_driver = {
>         .driver = {
> -               .name = "gpio-kempld",
> +               .name = "kempld-gpio",
>                 .owner = THIS_MODULE,
>         },
>         .probe          = kempld_gpio_probe,
