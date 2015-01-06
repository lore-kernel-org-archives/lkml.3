Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbbAFPe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:34:26 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:51971 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbAFPeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:34:24 -0500
Date: Tue, 6 Jan 2015 16:34:24 +0100
From: Johan Hovold <johan@kernel.org>
To: "Peterson, David" <David.Peterson@cel.com>
Cc: "johan@kernel.org" <johan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] USB: cp210x: add IDs for CEL USB sticks and MeshWorks
 devices
Message-ID: <20150106153424.GB9658@localhost>
References: <641A0889272F104D8B07278675C0C484010BF621@hq27>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <641A0889272F104D8B07278675C0C484010BF621@hq27>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 03:00:52PM +0000, Peterson, David wrote:
> From: David Peterson <david.peterson@cel.com>
> 
> Added virtual com port VID/PID entries for CEL USB sticks and MeshWorks devices
> 
> Signed-off-by: David Peterson <david.peterson@cel.com>

Applied, thanks.

Johan

> ---
>  drivers/usb/serial/cp210x.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c index 6c4eb3c..a6db2fc 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -120,6 +120,9 @@ static const struct usb_device_id id_table[] = {
>  	{ USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
>  	{ USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
>  	{ USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
> +	{ USB_DEVICE(0x10C4, 0x8856) }, /* CEL EM357 ZigBee USB Stick - LR */
> +	{ USB_DEVICE(0x10C4, 0x8857) }, /* CEL EM357 ZigBee USB Stick */
> +	{ USB_DEVICE(0x10C4, 0x8977) }, /* CEL MeshWorks DevKit Device */
>  	{ USB_DEVICE(0x10C4, 0x8875) }, /* CEL MeshConnect USB Stick */
>  	{ USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
>  	{ USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
