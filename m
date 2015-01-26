Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbbAZPYG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:24:06 -0500
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:41748 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbbAZPYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:24:04 -0500
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Mon, 26 Jan 2015 10:24:01 -0500
To: Johan Hovold <johan@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: cp210x: add ID for RUGGEDCOM USB Serial Console
Message-ID: <20150126152401.GT30245@csclub.uwaterloo.ca>
References: <20150121202427.GA4451@csclub.uwaterloo.ca>
 <20150126124034.GC2465@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126124034.GC2465@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 01:40:34PM +0100, Johan Hovold wrote:
> On Wed, Jan 21, 2015 at 03:24:27PM -0500, Lennart Sorensen wrote:
> > Added the USB serial console device ID for Siemens Ruggedcom devices
> > which have a USB port for their serial console.
> > 
> > Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>
> > ---
> >  drivers/usb/serial/cp210x.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> > index f4c56fc..f34e6ba 100644
> > --- a/drivers/usb/serial/cp210x.c
> > +++ b/drivers/usb/serial/cp210x.c
> > @@ -55,6 +55,7 @@ static const struct usb_device_id id_table[] = {
> >  	{ USB_DEVICE(0x0745, 0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
> >  	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
> >  	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
> > +	{ USB_DEVICE(0x0908, 0x01FF) }, /* RUGGEDCOM USB Serial Console */
> >  	{ USB_DEVICE(0x08FD, 0x000A) }, /* Digianswer A/S , ZigBee/802.15.4 MAC Device */
> 
> Please try to keep the entries sorted by VID/PID. I fixed it up here and
> applied.

Oh crap, I thought I did.  How ever did I mess that up?  Sorry about that.

-- 
Len Sorensen
