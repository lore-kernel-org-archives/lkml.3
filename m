Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3H3Ajz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 20:39:55 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:57709 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab3H3Ajx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 20:39:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joseph Salisbury <joseph.salisbury@canonical.com>
Cc: linux-kernel@vger.kernel.org, m.chehab@samsung.com,
        linux-media@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] [media] uvcvideo: quirk PROBE_DEF for Dell SP2008WFP monitor.
Date: Fri, 30 Aug 2013 02:41:17 +0200
Message-ID: <3172143.JtUQzMAjLG@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <efa845fedf7b2326c7fe6e82c4f90b15055c4a1c.1377781889.git.joseph.salisbury@canonical.com>
References: <cover.1377781889.git.joseph.salisbury@canonical.com> <efa845fedf7b2326c7fe6e82c4f90b15055c4a1c.1377781889.git.joseph.salisbury@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joseph,

Thank you for the patch.

On Thursday 29 August 2013 11:17:41 Joseph Salisbury wrote:
> BugLink: http://bugs.launchpad.net/bugs/1217957
> 
> Add quirk for Dell SP2008WFP monitor: 05a9:2641
> 
> Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
> Tested-by: Christopher Townsend <christopher.townsend@canonical.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
> Cc: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied it to my tree. Given that we're too close to the v3.12 merge 
window I will push it for v3.13.

> ---
>  drivers/media/usb/uvc/uvc_driver.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_driver.c
> b/drivers/media/usb/uvc/uvc_driver.c index ed123f4..8c1826c 100644
> --- a/drivers/media/usb/uvc/uvc_driver.c
> +++ b/drivers/media/usb/uvc/uvc_driver.c
> @@ -2174,6 +2174,15 @@ static struct usb_device_id uvc_ids[] = {
>  	  .bInterfaceSubClass	= 1,
>  	  .bInterfaceProtocol	= 0,
>  	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
> +	/* Dell SP2008WFP Monitor */
> +	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> +				| USB_DEVICE_ID_MATCH_INT_INFO,
> +	  .idVendor		= 0x05a9,
> +	  .idProduct		= 0x2641,
> +	  .bInterfaceClass	= USB_CLASS_VIDEO,
> +	  .bInterfaceSubClass	= 1,
> +	  .bInterfaceProtocol	= 0,
> +	  .driver_info 		= UVC_QUIRK_PROBE_DEF },
>  	/* Dell Alienware X51 */
>  	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
> 
>  				| USB_DEVICE_ID_MATCH_INT_INFO,
-- 
Regards,

Laurent Pinchart

