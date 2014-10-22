Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440AbaJVIQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:16:59 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:52875 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076AbaJVIQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:16:54 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Wed, 22 Oct 2014 10:13:49 +0200
From: Johan Hovold <johan@kernel.org>
To: Nathaniel Ting <nathaniel.ting@silabs.com>
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: cp210x: Add Silicon Labs 358x VID and PID.
Message-ID: <20141022081349.GD2113@localhost>
References: <1412352080-4711-1-git-send-email-nathaniel.ting@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412352080-4711-1-git-send-email-nathaniel.ting@silabs.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 12:01:20PM -0400, Nathaniel Ting wrote:
> From: Nathaniel Ting <nathaniel.ting@silabs.com>
> 
> Enable Silicon Labs Ember VID chips to enumerate with the cp210x usb serial
> driver. EM358x devices operating with the Ember Z-Net 5.1.2 stack may now
> connect to host PCs over a USB serial link.
> 
> Signed-off-by: Nathaniel Ting <nathaniel.ting@silabs.com>

Applied, thanks.

Johan

> ---
>  drivers/usb/serial/cp210x.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index e4bb622..ab1eb9b 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -154,6 +154,7 @@ static const struct usb_device_id id_table[] = {
>  	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
>  	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
>  	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
> +	{ USB_DEVICE(0x1BA4, 0x0002) }, /* Silicon Labs 358x factory default */
>  	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
>  	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
>  	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
