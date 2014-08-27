Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaH0IgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 04:36:22 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:1345 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbaH0IgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 04:36:19 -0400
Message-ID: <53FD987B.50601@atmel.com>
Date: Wed, 27 Aug 2014 10:36:11 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Josh Wu <josh.wu@atmel.com>, <linux-kernel@vger.kernel.org>,
        <linux-iio@vger.kernel.org>, <jic23@kernel.org>,
        <maxime.ripard@free-electrons.com>
CC: <alexandre.belloni@free-electrons.com>
Subject: Re: [PATCH] iio: adc: at91: make the function handle_adc_eoc_trigger()
 static
References: <1409128271-14856-1-git-send-email-josh.wu@atmel.com>
In-Reply-To: <1409128271-14856-1-git-send-email-josh.wu@atmel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/2014 10:31, Josh Wu :
> The handle_adc_eoc_trigger() in only used in at91_adc.c. So make it
> static.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>

Absolutely.

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks, bye.

> ---
>  drivers/iio/adc/at91_adc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/at91_adc.c b/drivers/iio/adc/at91_adc.c
> index 772e869..7807e0e 100644
> --- a/drivers/iio/adc/at91_adc.c
> +++ b/drivers/iio/adc/at91_adc.c
> @@ -266,7 +266,7 @@ static irqreturn_t at91_adc_trigger_handler(int irq, void *p)
>  }
>  
>  /* Handler for classic adc channel eoc trigger */
> -void handle_adc_eoc_trigger(int irq, struct iio_dev *idev)
> +static void handle_adc_eoc_trigger(int irq, struct iio_dev *idev)
>  {
>  	struct at91_adc_state *st = iio_priv(idev);
>  
> 


-- 
Nicolas Ferre
