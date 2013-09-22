Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3IVSUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 14:20:38 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43307 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3IVSUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 14:20:37 -0400
Message-ID: <523F4319.4010208@kernel.org>
Date: Sun, 22 Sep 2013 20:20:57 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Zubair Lutfullah <zubair.lutfullah@gmail.com>
CC: jic23@cam.ac.uk, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/3] iio: ti_am335x_adc: cleanup trigger related code
References: <1379838005-15158-1-git-send-email-zubair.lutfullah@gmail.com> <1379838005-15158-3-git-send-email-zubair.lutfullah@gmail.com>
In-Reply-To: <1379838005-15158-3-git-send-email-zubair.lutfullah@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/13 09:20, Zubair Lutfullah wrote:
> Trigger related headers and variables are not needed
> as driver is now based on INDIO_BUFFER_HARDWARE mode
> 
> Signed-off-by: Zubair Lutfullah <zubair.lutfullah@gmail.com>
Applied
> ---
>  drivers/iio/adc/ti_am335x_adc.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
> index 91dce1f..4eb63eb 100644
> --- a/drivers/iio/adc/ti_am335x_adc.c
> +++ b/drivers/iio/adc/ti_am335x_adc.c
> @@ -30,9 +30,6 @@
>  #include <linux/mfd/ti_am335x_tscadc.h>
>  #include <linux/iio/buffer.h>
>  #include <linux/iio/kfifo_buf.h>
> -#include <linux/iio/trigger.h>
> -#include <linux/iio/trigger_consumer.h>
> -#include <linux/iio/triggered_buffer.h>
>  
>  struct tiadc_device {
>  	struct ti_tscadc_dev *mfd_tscadc;
> @@ -40,7 +37,6 @@ struct tiadc_device {
>  	u8 channel_line[8];
>  	u8 channel_step[8];
>  	int buffer_en_ch_steps;
> -	struct iio_trigger *trig;
>  	u16 data[8];
>  };
>  
> 
