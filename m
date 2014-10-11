Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaJKOVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 10:21:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56321 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbaJKOVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 10:21:49 -0400
Date: Sat, 11 Oct 2014 07:20:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Philip Munksgaard <pmunksgaard@gmail.com>
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: serial: Fix indentation style issue
Message-ID: <20141011142049.GA11456@kroah.com>
References: <1413035383-3981-1-git-send-email-pmunksgaard@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413035383-3981-1-git-send-email-pmunksgaard@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 03:49:43PM +0200, Philip Munksgaard wrote:
> Fix a style issue
> 
> Signed-off-by: Philip Munksgaard <pmunksgaard@gmail.com>
> ---
>  drivers/usb/serial/option.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index d1a3f60..d88998d 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -1616,7 +1616,7 @@ static const struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
>  	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
>    	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
> -  	},
> +	},

Why not fix the same 'space' issue on the line before this at the same
time?

