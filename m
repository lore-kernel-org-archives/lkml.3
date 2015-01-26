Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672AbbAZMkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:40:45 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:54318 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbbAZMkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:40:40 -0500
Date: Mon, 26 Jan 2015 13:40:34 +0100
From: Johan Hovold <johan@kernel.org>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        linux-usb@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: cp210x: add ID for RUGGEDCOM USB Serial Console
Message-ID: <20150126124034.GC2465@localhost>
References: <20150121202427.GA4451@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150121202427.GA4451@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 03:24:27PM -0500, Lennart Sorensen wrote:
> Added the USB serial console device ID for Siemens Ruggedcom devices
> which have a USB port for their serial console.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> ---
>  drivers/usb/serial/cp210x.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index f4c56fc..f34e6ba 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -55,6 +55,7 @@ static const struct usb_device_id id_table[] = {
>  	{ USB_DEVICE(0x0745, 0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
>  	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
>  	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
> +	{ USB_DEVICE(0x0908, 0x01FF) }, /* RUGGEDCOM USB Serial Console */
>  	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */

Please try to keep the entries sorted by VID/PID. I fixed it up here and
applied.

Thanks,
Johan
