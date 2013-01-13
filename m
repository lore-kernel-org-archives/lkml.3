Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3AMTYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 14:24:19 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:33900 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab3AMTYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 14:24:17 -0500
Date: Sun, 13 Jan 2013 11:25:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomasz Mloduchowski <q@qdot.me>
Cc: jhovold@gmail.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Crucible Technologies COMET Caller ID - pid added.
Message-ID: <20130113192504.GA15331@kroah.com>
References: <CAEpun2ZA-JKsrtGbajBX7nOo=uacitAvnC5gSKiNJJe5bfDLSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEpun2ZA-JKsrtGbajBX7nOo=uacitAvnC5gSKiNJJe5bfDLSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2013 at 07:20:27PM +0100, Tomasz Mloduchowski wrote:
> From: Tomasz Mloduchowski <q@qdot.me>
> 
> Simple fix to add support for Crucible Technologies COMET Caller ID
> USB decoder - a device containing FTDI USB/Serial converter chip,
> handling 1200bps CallerID messages decoded from the phone line -
> adding correct USB PID is sufficient.
> 
> Tested to apply cleanly and work flawlessly against 3.6.9, 3.7.0-rc8
> and 3.8.0-rc3 on both amd64 and x86 arches.
> 
> Signed-off-by: Tomasz Mloduchowski <q@qdot.me>
> ---
> diff -ur linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio.c
> linux-3.8-rc3/drivers/usb/serial/ftdi_sio.c
> --- linux-3.8-rc3.orig/drivers/usb/serial/ftdi_sio.c    2013-01-13
> 19:41:28.000000000 +0100
> +++ linux-3.8-rc3/drivers/usb/serial/ftdi_sio.c 2013-01-13
> 19:49:27.239874311 +0100
> @@ -875,6 +875,8 @@
>         { USB_DEVICE(FTDI_VID, FTDI_DISTORTEC_JTAG_LOCK_PICK_PID),
>                 .driver_info = (kernel_ulong_t)&ftdi_jtag_quirk },
>         { USB_DEVICE(FTDI_VID, FTDI_LUMEL_PD12_PID) },
> +       /* Crucible Devices */
> +       { USB_DEVICE(FTDI_VID, FTDI_CT_COMET_PID) },
>         { },                                    /* Optional parameter entry */
>         { }                                     /* Terminating entry */
>  };

The patch is line-wrapped and all of the tabs are converted to spaces,
both of which are keeping this patch from being able to be applied :(

Care to fix your email client and resend this so that I can apply it?

thanks,

greg k-h
