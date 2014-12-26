Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaLZLlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 06:41:46 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44849 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaLZLll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 06:41:41 -0500
Message-ID: <549D4973.5020700@kernel.org>
Date: Fri, 26 Dec 2014 11:41:39 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v2 3/3] iio: core: Get rid of misleading comment
References: <1419010766-13557-1-git-send-email-k.wrona@samsung.com> <1419010766-13557-4-git-send-email-k.wrona@samsung.com>
In-Reply-To: <1419010766-13557-4-git-send-email-k.wrona@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/12/14 17:39, Karol Wrona wrote:
> This comment did not fit here.  It explains why devm_kmalloc
> uses dr_alloc.  Generally is not needed at all.
> 
A classic bit of cut and paste I guess. Anyhow, applied.

Jonathan
> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> ---
>  drivers/iio/industrialio-core.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index af3e76d..1d030ae 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -1035,7 +1035,6 @@ struct iio_dev *devm_iio_device_alloc(struct device *dev, int sizeof_priv)
>  	if (!ptr)
>  		return NULL;
>  
> -	/* use raw alloc_dr for kmalloc caller tracing */
>  	iio_dev = iio_device_alloc(sizeof_priv);
>  	if (iio_dev) {
>  		*ptr = iio_dev;
> 

