Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaLAIRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:17:20 -0500
Received: from aer-iport-4.cisco.com ([173.38.203.54]:19961 "EHLO
	aer-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaLAIRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:17:19 -0500
X-IronPort-AV: E=Sophos;i="5.07,492,1413244800"; 
   d="scan'208";a="252200794"
Message-ID: <547C2400.3050409@cisco.com>
Date: Mon, 01 Dec 2014 09:17:04 +0100
From: Hans Verkuil <hansverk@cisco.com>
Organization: Cisco Systems Norway
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Anjana Sasindran <anjanasasindran123@gmail.com>,
        gregkh@linuxfoundation.org, joe@perches.com, m.chehab@samsung.com,
        hans.verkuil@cisco.com
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers:staging:media:omap24xx:v4l2-int-device.h: Added
 a '*' before ')'--(parenthesis closing)
References: <1417345082-3526-1-git-send-email-anjanasasindran123@gmail.com>
In-Reply-To: <1417345082-3526-1-git-send-email-anjanasasindran123@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Authenticated-User: hansverk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2014 11:58 AM, Anjana Sasindran wrote:
> This patch fix a checkpatch.pl error:
> 
> ERROR: space prohibited before ')' parenthesis closing
> 
> Signed-off-by: Anjana Sasindran <anjanasasindran123@gmail.com>

Thanks for the patch, but this driver is removed in kernel 3.19.
So there is no point in patching it.

Regards,

	Hans

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
>  V4L2_INT_WRAPPER_1(g_priv, void, *);
>  V4L2_INT_WRAPPER_1(g_ifparm, struct v4l2_ifparm, *);
>  V4L2_INT_WRAPPER_1(g_needs_reset, void, *);
> 

