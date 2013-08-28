Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab3H1Scy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 14:32:54 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:47228 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab3H1Scw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 14:32:52 -0400
Date: Wed, 28 Aug 2013 19:32:45 +0100
From: "Zubair Lutfullah :" <zubair.lutfullah@gmail.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Zubair Lutfullah <zubair.lutfullah@gmail.com>, jic23@cam.ac.uk,
        lee.jones@linaro.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] iio: am335x-iio-adc: select triggered buffer
Message-ID: <20130828183235.GA3777@gmail.com>
References: <1377470724-15710-1-git-send-email-zubair.lutfullah@gmail.com>
 <1377470724-15710-3-git-send-email-zubair.lutfullah@gmail.com>
 <20130828103134.GA14111@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828103134.GA14111@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 12:31:34PM +0200, Sebastian Andrzej Siewior wrote:
> "triggered buffer" isn't selected so we end up with:
> |ERROR: "iio_triggered_buffer_setup" [drivers/iio/adc/ti_am335x_adc.ko] undefined!
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> Please merge this into _this_ patch, it is still required.
> 
>  drivers/iio/adc/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
> index 09371cb..cfa2039 100644
> --- a/drivers/iio/adc/Kconfig
> +++ b/drivers/iio/adc/Kconfig
> @@ -167,6 +167,7 @@ config TI_ADC081C
>  config TI_AM335X_ADC
>  	tristate "TI's AM335X ADC driver"
>  	depends on MFD_TI_AM335X_TSCADC
> +	select IIO_TRIGGERED_BUFFER
Thanks for pointing it out. Added.

ZubairLK
