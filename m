Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaCFUDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:03:46 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:56858 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaCFUDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:03:42 -0500
MIME-Version: 1.0
In-Reply-To: <1394126318-19806-1-git-send-email-paolo.pisati@canonical.com>
References: <1394126318-19806-1-git-send-email-paolo.pisati@canonical.com>
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 6 Mar 2014 12:03:21 -0800
Message-ID: <CAK5ve-K9DVDNsUrFXqLtUnFjMNN2EHr6S1vjzD+E7mQ8S2AOdQ@mail.gmail.com>
Subject: Re: [PATCH] leds-gpio: of: introduce MODULE_DEVICE_TABLE for module autoloading
To: Paolo Pisati <paolo.pisati@canonical.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 6, 2014 at 9:18 AM, Paolo Pisati <paolo.pisati@canonical.com> wrote:
> Enable autoloading of leds-gpio module when a corresponing DT entry is present.
>

Looks good. I will merge it.

Thanks,
-Bryan

> Signed-off-by: Paolo Pisati <paolo.pisati@canonical.com>
> ---
>  drivers/leds/leds-gpio.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
> index 78b0e27..653d501 100644
> --- a/drivers/leds/leds-gpio.c
> +++ b/drivers/leds/leds-gpio.c
> @@ -224,6 +224,8 @@ static const struct of_device_id of_gpio_leds_match[] = {
>         { .compatible = "gpio-leds", },
>         {},
>  };
> +
> +MODULE_DEVICE_TABLE(of, of_gpio_leds_match);
>  #else /* CONFIG_OF_GPIO */
>  static struct gpio_leds_priv *gpio_leds_create_of(struct platform_device *pdev)
>  {
> --
> 1.9.0
>
