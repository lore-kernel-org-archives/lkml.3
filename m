Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbaKJJXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:23:48 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:52542 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaKJJXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:23:46 -0500
Date: Mon, 10 Nov 2014 10:20:39 +0100
From: Johan Hovold <johan@kernel.org>
To: Preston Fick <pffick@gmail.com>
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: cp210x: Adding IDs for CEL MeshConnect USB
 Stick
Message-ID: <20141110092039.GA29789@localhost>
References: <1415424371-4900-1-git-send-email-pffick@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415424371-4900-1-git-send-email-pffick@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 07, 2014 at 11:26:11PM -0600, Preston Fick wrote:
> Signed-off-by: Preston Fick <pffick@gmail.com>
> ---
>  drivers/usb/serial/cp210x.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index cfd009d..6c4eb3c 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -120,6 +120,7 @@ static const struct usb_device_id id_table[] = {
>  	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
>  	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
>  	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
> +	{ USB_DEVICE(0x10C4, 0x8875) }, /* CEL MeshConnect USB Stick */
>  	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
>  	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
>  	{ USB_DEVICE(0x10C4, 0x8946) }, /* Ketra N1 Wireless Interface */

Applied, thanks.

Johan
