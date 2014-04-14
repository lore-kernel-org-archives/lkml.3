Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153AbaDNOsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:48:36 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:54903 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaDNOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:48:31 -0400
Date: Mon, 14 Apr 2014 16:48:01 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Tristan Bruns <tristan@tristanbruns.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: cp210x: Add 8281 (Nanotec Plug & Drive)
Message-ID: <20140414144801.GB27724@localhost>
References: <20140413215716.GB13605@eddie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140413215716.GB13605@eddie>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 11:57:16PM +0200, Tristan Bruns wrote:
> Signed-off-by: Tristan Bruns <tristan@tristanbruns.de>

Signed-off-by: Johan Hovold <jhovold@gmail.com>

Thanks for the patch.

Johan

> ---
>  drivers/usb/serial/cp210x.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index 95fa121..762e4a5 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -104,6 +104,7 @@ static const struct usb_device_id id_table[] = {
>  	{ USB_DEVICE(0x10C4, 0x8218) }, /* Lipowsky Industrie Elektronik GmbH, HARP-1 */
>  	{ USB_DEVICE(0x10C4, 0x822B) }, /* Modem EDGE(GSM) Comander 2 */
>  	{ USB_DEVICE(0x10C4, 0x826B) }, /* Cygnal Integrated Products, Inc., Fasttrax GPS demonstration module */
> +	{ USB_DEVICE(0x10C4, 0x8281) }, /* Nanotec Plug & Drive */
>  	{ USB_DEVICE(0x10C4, 0x8293) }, /* Telegesis ETRX2USB */
>  	{ USB_DEVICE(0x10C4, 0x82F9) }, /* Procyon AVS */
>  	{ USB_DEVICE(0x10C4, 0x8341) }, /* Siemens MC35PU GPRS Modem */
