Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaLAIu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:50:27 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36513 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaLAIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:50:26 -0500
Date: Mon, 1 Dec 2014 11:50:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Anjana Sasindran <anjanasasindran123@gmail.com>
Cc: gregkh@linuxfoundation.org, joe@perches.com, m.chehab@samsung.com,
        hans.verkuil@cisco.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:media:omap24xx:v4l2-int-device.h: Added
 a '*' before ')'--(parenthesis closing)
Message-ID: <20141201085008.GC4994@mwanda>
References: <1417345082-3526-1-git-send-email-anjanasasindran123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417345082-3526-1-git-send-email-anjanasasindran123@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2014 at 04:28:02PM +0530, Anjana Sasindran wrote:
> This patch fix a checkpatch.pl error:
> 
> ERROR: space prohibited before ')' parenthesis closing
> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>
> ---
>  drivers/staging/media/omap24xx/v4l2-int-device.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/omap24xx/v4l2-int-device.h b/drivers/staging/media/omap24xx/v4l2-int-device.h
> index 0286c95..9490595 100644
> --- a/drivers/staging/media/omap24xx/v4l2-int-device.h
> +++ b/drivers/staging/media/omap24xx/v4l2-int-device.h
> @@ -292,7 +292,7 @@ V4L2_INT_WRAPPER_1(s_video_routing, struct v4l2_routing, *);
>  
>  V4L2_INT_WRAPPER_0(dev_init);
>  V4L2_INT_WRAPPER_0(dev_exit);
> -V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, );
> +V4L2_INT_WRAPPER_1(s_power, enum v4l2_power, *);

Wait, what?  The changelog for this is not clear.  This looks like
either a bug fix or a bug introducer.

This driver has been deleted in linux-next anyway so I guess it doesn't
matter.  Please work against linux-next.

regards,
dan carpenter

