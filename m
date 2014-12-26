Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765AbaLZKjr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 05:39:47 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:44490 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbaLZKjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 05:39:45 -0500
Message-ID: <549D3AEE.5020400@kernel.org>
Date: Fri, 26 Dec 2014 10:39:42 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Mohammad Jamal <md.jamalmohiuddin@gmail.com>, lars@metafoo.de
CC: Michael.Hennerich@analog.com, knaack.h@gmx.de, pmeerw@pmeerw.net,
        gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging : iio: meter: ade7759: fix space before , coding
 style issue
References: <1419165769-29782-1-git-send-email-md.jamalmohiuddin@gmail.com>
In-Reply-To: <1419165769-29782-1-git-send-email-md.jamalmohiuddin@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/12/14 12:42, Mohammad Jamal wrote:
> This patch solves the space before , coding style issue found by
> checkpatch in ade7759.c
> 
> Signed-off-by: Mohammad Jamal <md.jamalmohiuddin@gmail.com>
Fixed by Zachery Warren back in November.  I'm a bit behind with
sending stuff upstream so won't have hit anything other than the
togreg branch of iio.git just yet.

Patch was:

[PATCH] drivers:staging:iio: fix checkpatch complaint about space before comma
Thanks,

Jonathan
> ---
>  drivers/staging/iio/meter/ade7759.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/iio/meter/ade7759.c b/drivers/staging/iio/meter/ade7759.c
> index 7d21743..b0c7dbc 100644
> --- a/drivers/staging/iio/meter/ade7759.c
> +++ b/drivers/staging/iio/meter/ade7759.c
> @@ -116,7 +116,7 @@ static int ade7759_spi_read_reg_40(struct device *dev,
>  
>  	mutex_lock(&st->buf_lock);
>  	st->tx[0] = ADE7759_READ_REG(reg_address);
> -	memset(&st->tx[1], 0 , 5);
> +	memset(&st->tx[1], 0, 5);
>  
>  	ret = spi_sync_transfer(st->us, xfers, ARRAY_SIZE(xfers));
>  	if (ret) {
> 

