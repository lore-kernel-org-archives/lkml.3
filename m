Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279AbaGGIaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:30:25 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:45477 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769AbaGGIaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:30:20 -0400
X-Google-Original-Sender: <johan@hovold.com>
Date: Mon, 7 Jul 2014 10:29:45 +0200
From: Johan Hovold <johan@kernel.org>
To: Andras@mail.sth.sze.hu, Kovacs@mail.sth.sze.hu
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andras Kovacs <andras@sth.sze.hu>
Subject: Re: [PATCH 1/1] Add support for Corsair usb dongle
Message-ID: <20140707082945.GB29098@localhost>
References: <1403873411-12889-1-git-send-email-andras@sth.sze.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403873411-12889-1-git-send-email-andras@sth.sze.hu>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 02:50:11PM +0200, Andras@mail.sth.sze.hu wrote:
> From: Andras Kovacs <andras@sth.sze.hu>
> 
> Corsair USB Dongles are shipped with Corsair AXi series PSUs.
> These are cp210x serial usb devices, so make driver detect these.
> I have a program, that can get information from these PSUs.
> 
> Tested with 2 different dongles shipped with Corsair AX860i and
> AX1200i units.
> 
> Signed-off-by: Andras Kovacs <andras@sth.sze.hu>

Applied, thanks.

Johan

> ---
>  drivers/usb/serial/cp210x.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index 762e4a5..330df5c 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -153,6 +153,7 @@ static const struct usb_device_id id_table[] = {
>  	{ USB_DEVICE(0x1843, 0x0200) }, /* Vaisala USB Instrument Cable */
>  	{ USB_DEVICE(0x18EF, 0xE00F) }, /* ELV USB-I2C-Interface */
>  	{ USB_DEVICE(0x1ADB, 0x0001) }, /* Schweitzer Engineering C662 Cable */
> +	{ USB_DEVICE(0x1B1C, 0x1C00) }, /* Corsair USB Dongle */
>  	{ USB_DEVICE(0x1BE3, 0x07A6) }, /* WAGO 750-923 USB Service Cable */
>  	{ USB_DEVICE(0x1E29, 0x0102) }, /* Festo CPX-USB */
>  	{ USB_DEVICE(0x1E29, 0x0501) }, /* Festo CMSP */
