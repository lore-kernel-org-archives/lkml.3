Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaAXRI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:08:56 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:46596 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbaAXRIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:08:54 -0500
Date: Fri, 24 Jan 2014 11:08:49 -0600 (CST)
From: Thomas Pugliese <thomas.pugliese@gmail.com>
To: Shuah Khan <shuah.kh@samsung.com>
cc: gregkh@linuxfoundation.org, ly80toro@cip.cs.fau.de, alan@linux.intel.com,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Subject: Re: [PATCH] staging/usbip: Add missing speeds to userspace speed_strings
 array
In-Reply-To: <1390420383-3933-1-git-send-email-shuah.kh@samsung.com>
Message-ID: <alpine.DEB.2.10.1401241106380.28215@mint32-virtualbox>
References: <1390420383-3933-1-git-send-email-shuah.kh@samsung.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 22 Jan 2014, Shuah Khan wrote:

> Add speed strings for usb wireless and 3.0 to speed_strings array.
> 
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>  drivers/staging/usbip/userspace/libsrc/usbip_common.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_common.c b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
> index 66f03cc..8cb4fcc 100644
> --- a/drivers/staging/usbip/userspace/libsrc/usbip_common.c
> +++ b/drivers/staging/usbip/userspace/libsrc/usbip_common.c
> @@ -23,6 +23,8 @@ static const struct speed_string speed_strings[] = {
>  	{ USB_SPEED_LOW,  "1.5", "Low Speed(1.5Mbps)"  },
>  	{ USB_SPEED_FULL, "12",  "Full Speed(12Mbps)" },
>  	{ USB_SPEED_HIGH, "480", "High Speed(480Mbps)" },
> +	{ USB_SPEED_WIRELESS, "2.5", "Wireless"},
> +	{ USB_SPEED_SUPER, "5000", "Super Speed(5000Mbps)" },
>  	{ 0, NULL, NULL }
>  };
>  
> -- 

Wireless USB supports variable speeds from 53.3Mbps to 480Mbps.  I'm not 
sure how you want to represent that but "2.5" doesn't seem to apply.

Thanks,
Thomas
