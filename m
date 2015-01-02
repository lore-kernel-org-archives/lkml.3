Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbbABOCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 09:02:18 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:65366 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbbABOCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 09:02:16 -0500
Date: Fri, 2 Jan 2015 15:02:11 +0100
From: Johan Hovold <johan@kernel.org>
To: Preston Fick <pffick@gmail.com>
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: cp210x: Correcting IDs for production CEL
 MeshConnect USB Stick
Message-ID: <20150102140211.GB12203@localhost>
References: <1419665561-19977-1-git-send-email-pffick@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419665561-19977-1-git-send-email-pffick@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2014 at 01:32:41AM -0600, Preston Fick wrote:
> Fixing typo for MeshConnect IDs. The original PID (0x8875) is not in production and is not needed. Instead it has been changed to the official production PID (0x8857).

Make sure to use line breaks in your commit messages. I fixed it up here
and applied. 

Thanks,
Johan

> Signed-off-by: Preston Fick <pffick@gmail.com>
> ---
>  drivers/usb/serial/cp210x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index 6c4eb3c..fb8d3fa 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -120,7 +120,7 @@ static const struct usb_device_id id_table[] = {
>  	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
>  	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
>  	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
> -	{ USB_DEVICE(0x10C4, 0x8875) }, /* CEL MeshConnect USB Stick */
> +	{ USB_DEVICE(0x10C4, 0x8857) }, /* CEL MeshConnect USB Stick */
>  	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
>  	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
>  	{ USB_DEVICE(0x10C4, 0x8946) }, /* Ketra N1 Wireless Interface */
