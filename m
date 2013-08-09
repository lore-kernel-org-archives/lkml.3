Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030824Ab3HITYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:24:53 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42918 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030765Ab3HITYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:24:51 -0400
Date: Fri, 9 Aug 2013 12:24:48 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michael Brunner <mibru@gmx.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Chris Healy <chealy@imsco-us.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-gpio@vger.kernel.org
Subject: Re: [PATCH] gpio: Fix platform driver name in Kontron PLD GPIO driver
Message-ID: <20130809192448.GA10417@roeck-us.net>
References: <20130809173306.1ba24b59@mail.gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809173306.1ba24b59@mail.gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 05:33:06PM +0200, Michael Brunner wrote:
> This patch changes the driver name to be consistent with the name that
> is registered as cell name in the MFD driver. Otherwise the driver won't
> load.
> 
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

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
> 
