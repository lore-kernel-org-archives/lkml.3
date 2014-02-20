Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaBTNtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 08:49:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53460 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141AbaBTNtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 08:49:15 -0500
Date: Thu, 20 Feb 2014 14:48:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Richard Genoud <richard.genoud@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: gpiolib: typo in gpiochip_is_requested
 comment
In-Reply-To: <1392136001-913-1-git-send-email-richard.genoud@gmail.com>
Message-ID: <alpine.LNX.2.00.1402201448070.1192@pobox.suse.cz>
References: <1392136001-913-1-git-send-email-richard.genoud@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Richard Genoud wrote:

> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  drivers/gpio/gpiolib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 80da9f1940c9..a0b96695c519 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1646,7 +1646,7 @@ void gpio_free_array(const struct gpio *array, size_t num)
>  EXPORT_SYMBOL_GPL(gpio_free_array);
>  
>  /**
> - * gpiochip_is_requested - return string iff signal was requested
> + * gpiochip_is_requested - return string if signal was requested

Why do you believe this is correct, please?

-- 
Jiri Kosina
SUSE Labs
