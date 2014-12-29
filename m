Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaL2Xmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 18:42:32 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:33770 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaL2Xmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 18:42:31 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 09/11 linux-next] [media] uvcvideo: remove unnecessary version.h inclusion
Date: Tue, 30 Dec 2014 01:42:39 +0200
Message-ID: <3892296.djnqqbsP0R@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1419863387-24233-10-git-send-email-fabf@skynet.be>
References: <1419863387-24233-1-git-send-email-fabf@skynet.be> <1419863387-24233-10-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

Thank you for the patch.

On Monday 29 December 2014 15:29:43 Fabian Frederick wrote:
> Based on versioncheck.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Should I take the patch in my tree or do you plan to send a pull request for 
the whole series elsewhere ?

> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 9c5cbcf..43e953f 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -13,7 +13,6 @@
> 
>  #include <linux/compat.h>
>  #include <linux/kernel.h>
> -#include <linux/version.h>
>  #include <linux/list.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>

-- 
Regards,

Laurent Pinchart

