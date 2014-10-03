Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539AbaJCPuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:50:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43658 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752671AbaJCPuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:50:05 -0400
X-Sasl-enc: 9K9xqGFmwa+MYtOnwJj81QaEzHkVTrSIZc++ihl7zIiz 1412351402
Date: Fri, 3 Oct 2014 08:50:01 -0700
From: Greg KH <greg@kroah.com>
To: Nathaniel Ting <nathaniel.ting@silabs.com>
Cc: johan@kernel.org, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: cp210x: Add Silicon Labs 358x VID and PID.
Message-ID: <20141003155001.GB10004@kroah.com>
References: <1412348793-4558-1-git-send-email-nathaniel.ting@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412348793-4558-1-git-send-email-nathaniel.ting@silabs.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 03, 2014 at 11:06:33AM -0400, Nathaniel Ting wrote:
> From: Nathaniel Ting <nathaniel.ting@silabs.com>
> 
> Enable Silicon Labs Ember VID chips to enumerate with the cp210x usb serial
> driver. EM358x devices operating with the Ember Z-Net 5.1.2 stack may now
> connect to host PCs over a USB serial link.
> 
> Signed-off-by: Nathaniel Ting <nathaniel.ting@silabs.com>
> ---
>  drivers/usb/serial/cp210x.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index e4bb622..ce81fa8 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -154,6 +154,7 @@ static const struct usb_device_id id_table[] = {
>  	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
>  	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
>  	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
> +        { USB_DEVICE(0x1BA4, 0x0002) }, /* Silicon Labs 358x factory default */

Close, but if you ran your patch through checkpatch.pl you would see
that you used spaces instead of tabs for indentation.

At least the tabs on the other lines came through correctly, which is
good.

Care to fix this up and try again?

thanks,

greg k-h
