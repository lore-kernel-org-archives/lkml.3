Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbaLWLYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 06:24:20 -0500
Received: from mail-lb0-f171.google.com ([209.85.217.171]:46696 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639AbaLWLYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 06:24:18 -0500
Date: Tue, 23 Dec 2014 12:24:18 +0100
From: Johan Hovold <johan@kernel.org>
To: Preston Fick <pffick@gmail.com>
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: cp210x: Correcting IDs for production CEL
 MeshConnect USB Stick
Message-ID: <20141223112418.GJ30375@localhost>
References: <1419226419-19440-1-git-send-email-pffick@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419226419-19440-1-git-send-email-pffick@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 11:33:39PM -0600, Preston Fick wrote:

Please add a proper commit message here describing why this is needed.
Are there any devices with the original PID or was that just a typo?

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

Thanks,
Johan
