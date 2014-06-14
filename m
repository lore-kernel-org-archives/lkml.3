Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943AbaFNPTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 11:19:16 -0400
Received: from mail.kernel.org ([198.145.19.201]:44388 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754827AbaFNPTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 11:19:15 -0400
Message-ID: <539C6867.8090703@kernel.org>
Date: Sat, 14 Jun 2014 16:21:11 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joel Porquet <joel@porquet.org>, gregkh@linuxfoundation.org,
        jg1.han@samsung.com
CC: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: fix coding style
References: <1397066985-2504-1-git-send-email-joel@porquet.org>
In-Reply-To: <1397066985-2504-1-git-send-email-joel@porquet.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 19:09, Joel Porquet wrote:
> As suggested by checkpatch.pl, use dev_info() instead of
> printk(KERN_INFO ...) to print message.
>
> Signed-off-by: Joel Porquet <joel@porquet.org>
This line has been removed by another patch in the meantime.
> ---
> Only tested by compilation.
>   drivers/staging/iio/trigger/iio-trig-periodic-rtc.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c b/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
> index 48a6afa..38ecb4b 100644
> --- a/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
> +++ b/drivers/staging/iio/trigger/iio-trig-periodic-rtc.c
> @@ -33,7 +33,8 @@ static int iio_trig_periodic_rtc_set_state(struct iio_trigger *trig, bool state)
>   	struct iio_prtc_trigger_info *trig_info = iio_trigger_get_drvdata(trig);
>   	if (trig_info->frequency == 0)
>   		return -EINVAL;
> -	printk(KERN_INFO "trigger frequency is %d\n", trig_info->frequency);
> +	dev_info(&trig_info->rtc->dev, "trigger frequency is %d\n",
> +			trig_info->frequency);
>   	return rtc_irq_set_state(trig_info->rtc, &trig_info->task, state);
>   }
>
>

