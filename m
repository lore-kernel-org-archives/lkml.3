Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaIDXSq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 19:18:46 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:57324 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbaIDXSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 19:18:45 -0400
Message-ID: <1409872723.5546.137.camel@x220>
Subject: Re: [PATCH] [TRIVIAL] gpio: fix comment typos 'CONFIG_GPIO_IRQCHIP'
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 05 Sep 2014 01:18:43 +0200
In-Reply-To: <1396598372.19661.10.camel@x220>
References: <1396598372.19661.10.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Sep 2014 23:18:44.0085 (UTC) FILETIME=[92385A50:01CFC896]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, 2014-04-04 at 09:59 +0200, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
> These two typos were introduced in commit 1425052097b5 ("gpio: add IRQ
> chip helpers in gpiolib"), which has just been merged.
> 
>  include/linux/gpio/driver.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
> index 1827b43..8652ab7 100644
> --- a/include/linux/gpio/driver.h
> +++ b/include/linux/gpio/driver.h
> @@ -102,7 +102,7 @@ struct gpio_chip {
>  
>  #ifdef CONFIG_GPIOLIB_IRQCHIP
>  	/*
> -	 * With CONFIG_GPIO_IRQCHIP we get an irqchip inside the gpiolib
> +	 * With CONFIG_GPIOLIB_IRQCHIP we get an irqchip inside the gpiolib
>  	 * to handle IRQs for most practical cases.
>  	 */
>  	struct irq_chip		*irqchip;
> @@ -218,7 +218,7 @@ int gpiochip_irqchip_add(struct gpio_chip *gpiochip,
>  		irq_flow_handler_t handler,
>  		unsigned int type);
>  
> -#endif /* CONFIG_GPIO_IRQCHIP */
> +#endif /* CONFIG_GPIOLIB_IRQCHIP */
>  
>  #else /* CONFIG_GPIOLIB */

Did you ever had a chance to look at this patch? It still applies to
next-20140904.


Paul Bolle

