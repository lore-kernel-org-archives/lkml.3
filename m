Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966406AbaLLLYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 06:24:36 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:47216 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966174AbaLLLYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 06:24:35 -0500
Message-ID: <548AD071.1000204@kernel.org>
Date: Fri, 12 Dec 2014 11:24:33 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Sebastian Reichel <sre@debian.org>, lars@metafoo.de,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] iio: consumer.h: Fix scale factor in function comment
References: <1411476702-10004-1-git-send-email-iivanov@mm-sol.com>
In-Reply-To: <1411476702-10004-1-git-send-email-iivanov@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/09/14 13:51, Ivan T. Ivanov wrote:
> 1 milivolt is equal to 1000000 nanovolts.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
Good catch - applied to the togreg branch of iio.git.
Will initially push that as testing sometime later today
for the autobuilders to play.

Thanks,

Jonathan
> ---
>  include/linux/iio/consumer.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/iio/consumer.h b/include/linux/iio/consumer.h
> index 651f9a0..087af10 100644
> --- a/include/linux/iio/consumer.h
> +++ b/include/linux/iio/consumer.h
> @@ -191,7 +191,7 @@ int iio_read_channel_scale(struct iio_channel *chan, int *val,
>   * The scale factor allows to increase the precession of the returned value. For
>   * a scale factor of 1 the function will return the result in the normal IIO
>   * unit for the channel type. E.g. millivolt for voltage channels, if you want
> - * nanovolts instead pass 1000 as the scale factor.
> + * nanovolts instead pass 1000000 as the scale factor.
>   */
>  int iio_convert_raw_to_processed(struct iio_channel *chan, int raw,
>  	int *processed, unsigned int scale);
> 

