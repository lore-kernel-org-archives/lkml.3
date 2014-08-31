Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaHaKkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 06:40:23 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:40501 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaHaKkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 06:40:18 -0400
Message-ID: <5402FB8A.8010905@kernel.org>
Date: Sun, 31 Aug 2014 11:40:10 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soeren.brinkmann@gmail.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Hartmut Knaack <knaack.h@gmx.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: ad7606_core: Fix checkpatch warning
References: <1409468254-5312-1-git-send-email-soeren.brinkmann@gmail.com>
In-Reply-To: <1409468254-5312-1-git-send-email-soeren.brinkmann@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31/08/14 07:57, Sören Brinkmann wrote:
> Fix the checkpatch complaint regarding unnecessary line continuation.
>   WARNING: Avoid unnecessary line continuations
>   #143: FILE: ad7606_core.c:143:
> 
> Signed-off-by: Sören Brinkmann <soeren.brinkmann@gmail.com>
Applied to the togreg branch of iio.git.  Initially pushed out as testing for the
autobuilders to play.

Thanks,

Jonathan
> ---
>  drivers/staging/iio/adc/ad7606_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/iio/adc/ad7606_core.c b/drivers/staging/iio/adc/ad7606_core.c
> index f0f05f195d2c..bf2c8013134c 100644
> --- a/drivers/staging/iio/adc/ad7606_core.c
> +++ b/drivers/staging/iio/adc/ad7606_core.c
> @@ -140,7 +140,7 @@ static ssize_t ad7606_store_range(struct device *dev,
>  	return count;
>  }
>  
> -static IIO_DEVICE_ATTR(in_voltage_range, S_IRUGO | S_IWUSR, \
> +static IIO_DEVICE_ATTR(in_voltage_range, S_IRUGO | S_IWUSR,
>  		       ad7606_show_range, ad7606_store_range, 0);
>  static IIO_CONST_ATTR(in_voltage_range_available, "5000 10000");
>  
> 
