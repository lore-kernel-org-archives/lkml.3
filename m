Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759248Ab3AQHZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 02:25:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:18645 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759229Ab3AQHZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 02:25:41 -0500
Date: Thu, 17 Jan 2013 10:25:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jake Champlin <jake.champlin.27@gmail.com>
Cc: abbotti@mev.co.uk, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, fmhess@users.sourceforge.net
Subject: Re: [PATCH] Staging: comedi: ni_tio: Fixed whitespace / spacing issue
Message-ID: <20130117072523.GJ4584@mwanda>
References: <20130117010523.GA18848@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130117010523.GA18848@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 08:05:28PM -0500, Jake Champlin wrote:
> Fixed a leading whitespace coding style issue.
> 
> Signed-off-by: Jake Champlin <jake.champlin.27@gmail.com>
> ---
>  drivers/staging/comedi/drivers/ni_tio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/comedi/drivers/ni_tio.c b/drivers/staging/comedi/drivers/ni_tio.c
> index 98f8789..73e7cbe 100644
> --- a/drivers/staging/comedi/drivers/ni_tio.c
> +++ b/drivers/staging/comedi/drivers/ni_tio.c
> @@ -276,7 +276,7 @@ static inline unsigned NI_660x_RTSI_Second_Gate_Select(unsigned n)
>  }
>  
>  static const unsigned int counter_status_mask =
> -    COMEDI_COUNTER_ARMED | COMEDI_COUNTER_COUNTING;
> +COMEDI_COUNTER_ARMED | COMEDI_COUNTER_COUNTING;

No.  It should be intended but just using tabs instead of spaces.

regards,
dan carpenter

>  
>  static int __init ni_tio_init_module(void)
>  {
> -- 
> 1.8.1.1
> 
> 
> -- 
> Jake Champlin
> jake.champlin.27@gmail.com
> 8123742937
> <MuttClient>
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
