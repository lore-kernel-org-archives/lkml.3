Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaJVOUd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 10:20:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48832 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbaJVOUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 10:20:07 -0400
Date: Wed, 22 Oct 2014 22:18:57 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Philip Munksgaard <pmunksgaard@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: serial: Fix indentation style issue
Message-ID: <20141022141857.GA8639@kroah.com>
References: <1413035383-3981-1-git-send-email-pmunksgaard@gmail.com>
 <20141011142049.GA11456@kroah.com>
 <20141022095112.GJ2113@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141022095112.GJ2113@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:51:12AM +0200, Johan Hovold wrote:
> On Sat, Oct 11, 2014 at 07:20:49AM -0700, Greg Kroah-Hartman wrote:
> > On Sat, Oct 11, 2014 at 03:49:43PM +0200, Philip Munksgaard wrote:
> > > Fix a style issue
> > > 
> > > Signed-off-by: Philip Munksgaard <pmunksgaard@gmail.com>
> > > ---
> > >  drivers/usb/serial/option.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> > > index d1a3f60..d88998d 100644
> > > --- a/drivers/usb/serial/option.c
> > > +++ b/drivers/usb/serial/option.c
> > > @@ -1616,7 +1616,7 @@ static const struct usb_device_id option_ids[] = {
> > >  	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
> > >  	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
> > >    	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
> > > -  	},
> > > +	},
> > 
> > Why not fix the same 'space' issue on the line before this at the same
> > time?
> 
> And what about the remaining white-space issues in this file? Do we
> really want to go down this path?

No, we don't, if you want to have patches be able to apply properly to
older kernels, as you point out.

Just don't add new whitespace issues please, that's all.

thanks,

greg k-h
