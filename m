Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757504AbaHGKPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:15:52 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36330 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757456AbaHGKPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:15:50 -0400
Message-ID: <53E351D4.50103@kernel.org>
Date: Thu, 07 Aug 2014 11:15:48 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Oussama Jabbari <oussama.jabbari@gmail.com>
CC: gregkh@linuxfoundation.org, sachin.kamat@linaro.org, lars@metafoo.de,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: adis16060: Fix coding style problem
References: <1407344776-2838-1-git-send-email-oussama.jabbari@gmail.com>
In-Reply-To: <1407344776-2838-1-git-send-email-oussama.jabbari@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08/14 18:06, Oussama Jabbari wrote:
> This patch fixes a warning from checkpatch.pl script :
> "WARNING: Missing a blank line after declarations"
> 
> Signed-off-by: Oussama Jabbari <oussama.jabbari@gmail.com>
Whilst I find it hard to care about this particular issue,
I'm accepting this mainly to avoid getting the same thing
sometime in the future!

Anyhow, a nicely formatted patch.  The only change I would
have suggested would be in the title which might as be more
specific.

[PATCH] staging:iio:adis16060 Add missing blank line after declaration.

Applied to the togreg branch of iio.git - initially pushed out as
testing for the autobuilders to play with it.

J
> ---
> The reason of this patch is for completing one task
> of the Eudyptula Challenge.
> 
>  drivers/staging/iio/gyro/adis16060_core.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/iio/gyro/adis16060_core.c b/drivers/staging/iio/gyro/adis16060_core.c
> index d5d395c..4c5869d 100644
> --- a/drivers/staging/iio/gyro/adis16060_core.c
> +++ b/drivers/staging/iio/gyro/adis16060_core.c
> @@ -180,6 +180,7 @@ static int adis16060_w_probe(struct spi_device *spi)
>  	int ret;
>  	struct iio_dev *indio_dev = adis16060_iio_dev;
>  	struct adis16060_state *st;
> +
>  	if (!indio_dev) {
>  		ret =  -ENODEV;
>  		goto error_ret;
> 
