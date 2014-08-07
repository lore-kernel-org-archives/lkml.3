Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435AbaHGJMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:12:46 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:35835 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaHGJMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:12:44 -0400
Message-ID: <53E3430B.5010209@kernel.org>
Date: Thu, 07 Aug 2014 10:12:43 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
CC: gregkh@linuxfoundation.org
Subject: Re: [PATCH v3 2/2] staging: iio: accel: sca3000_core.c: Adjust code
 to fit 80-chars limit
References: <1407370929-26949-1-git-send-email-mopsfelder@gmail.com> <1407370929-26949-3-git-send-email-mopsfelder@gmail.com>
In-Reply-To: <1407370929-26949-3-git-send-email-mopsfelder@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/14 01:22, Murilo Opsfelder Araujo wrote:
> Signed-off-by: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Applied to the togreg branch of iio.git.

Thanks,

Jonathan
> ---
>  drivers/staging/iio/accel/sca3000_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
> index bc53fedb..e4e5639 100644
> --- a/drivers/staging/iio/accel/sca3000_core.c
> +++ b/drivers/staging/iio/accel/sca3000_core.c
> @@ -506,7 +506,8 @@ static int sca3000_read_raw(struct iio_dev *indio_dev,
>  				mutex_unlock(&st->lock);
>  				return ret;
>  			}
> -			*val = ((st->rx[0] & 0x3F) << 3) | ((st->rx[1] & 0xE0) >> 5);
> +			*val = ((st->rx[0] & 0x3F) << 3) |
> +			       ((st->rx[1] & 0xE0) >> 5);
>  		}
>  		mutex_unlock(&st->lock);
>  		return IIO_VAL_INT;
> 
