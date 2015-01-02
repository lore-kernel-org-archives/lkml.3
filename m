Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbbABNu3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 08:50:29 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34432 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbbABNu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 08:50:27 -0500
Date: Fri, 2 Jan 2015 14:50:21 +0100
From: Johan Hovold <johan@kernel.org>
To: "Peterson, David" <David.Peterson@cel.com>
Cc: "johan@kernel.org" <johan@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Additional devices added to cp210x usb-to-serial driver
 in kernel 3.16
Message-ID: <20150102135021.GA12203@localhost>
References: <641A0889272F104D8B07278675C0C484010B1A94@hq27>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <641A0889272F104D8B07278675C0C484010B1A94@hq27>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 29, 2014 at 10:49:34PM +0000, Peterson, David wrote:
> commit 975ae8b32bc5f52a5456e42c3c3310937c6fe833
> Author: David Peterson <david.peterson@cel.com>
> Date:   Mon Dec 29 15:59:37 2014 -0600

The above does not belong in the commit message (i.e. mail body).
Please read Documentation/SubmittingPatches, and consider using "git
format-patch" (and "git send-email").

> Added virtual com port VID/PID entries for CEL USB sticks and MeshWorks devices
> Signed-off-by: David Peterson <david.peterson@cel.com>

Also run scripts/checkpatch.pl on your patch before submitting, it would
have let you now that there are whitespace issues below.

Care to fix this up and resend?

Thanks,
Johan

> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index 6c4eb3c..a6db2fc 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -120,6 +120,9 @@ static const struct usb_device_id id_table[] = {
>                { USB_DEVICE(0x10C4, 0x85F8) }, /* Virtenio Preon32 */
>                { USB_DEVICE(0x10C4, 0x8664) }, /* AC-Services CAN-IF */
>                { USB_DEVICE(0x10C4, 0x8665) }, /* AC-Services OBD-IF */
> +             { USB_DEVICE(0x10C4, 0x8856) }, /* CEL EM357 ZigBee USB Stick - LR */
> +             { USB_DEVICE(0x10C4, 0x8857) }, /* CEL EM357 ZigBee USB Stick */
> +             { USB_DEVICE(0x10C4, 0x8977) }, /* CEL MeshWorks DevKit Device */
>                { USB_DEVICE(0x10C4, 0x8875) }, /* CEL MeshConnect USB Stick */
>                { USB_DEVICE(0x10C4, 0x88A4) }, /* MMB Networks ZigBee USB Device */
>                { USB_DEVICE(0x10C4, 0x88A5) }, /* Planet Innovation Ingeni ZigBee USB Device */
