Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaLZKme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 05:42:34 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44510 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbaLZKma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 05:42:30 -0500
Message-ID: <549D3B93.8070808@kernel.org>
Date: Fri, 26 Dec 2014 10:42:27 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>, lars@metafoo.de
CC: Michael.Hennerich@analog.com, knaack.h@gmx.de, pmeerw@pmeerw.net,
        gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: adc: ad7192: fix space before , coding
 style issue
References: <1419165331-29356-1-git-send-email-md.jamalmohiuddin@gmail.com>
In-Reply-To: <1419165331-29356-1-git-send-email-md.jamalmohiuddin@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/12/14 12:35, Mohammad Jamal wrote:
> This patch solves the space before , error of the checkpatch.pl
> 
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Also fixed in that earlier patch from Zachery.
> ---
>  drivers/staging/iio/adc/ad7192.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/iio/adc/ad7192.c b/drivers/staging/iio/adc/ad7192.c
> index f6526aa..6f8ce6c 100644
> --- a/drivers/staging/iio/adc/ad7192.c
> +++ b/drivers/staging/iio/adc/ad7192.c
> @@ -612,7 +612,7 @@ static int ad7192_probe(struct spi_device *spi)
>  	const struct ad7192_platform_data *pdata = spi->dev.platform_data;
>  	struct ad7192_state *st;
>  	struct iio_dev *indio_dev;
> -	int ret , voltage_uv = 0;
> +	int ret, voltage_uv = 0;
>  
>  	if (!pdata) {
>  		dev_err(&spi->dev, "no platform data?\n");
> 

