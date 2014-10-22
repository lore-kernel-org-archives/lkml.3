Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaJVVOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:14:17 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:49675 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbaJVVOP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:14:15 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Greg KH <gregkh@linuxfoundation.org>, Johan Hovold <johan@kernel.org>
CC: Philip Munksgaard <pmunksgaard@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: serial: Fix indentation style issue
Thread-Topic: [PATCH] usb: serial: Fix indentation style issue
Thread-Index: AQHP5VperSPoUnRx20qW/mBwbC4MupwrZ8CAgBD+UACAAErPgP///VrQ
Date: Wed, 22 Oct 2014 21:14:14 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E5026@US01WEMBX2.internal.synopsys.com>
References: <1413035383-3981-1-git-send-email-pmunksgaard@gmail.com>
 <20141011142049.GA11456@kroah.com> <20141022095112.GJ2113@localhost>
 <20141022141857.GA8639@kroah.com>
In-Reply-To: <20141022141857.GA8639@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Greg KH
> Sent: Wednesday, October 22, 2014 7:19 AM
> 
> On Wed, Oct 22, 2014 at 11:51:12AM +0200, Johan Hovold wrote:
> > On Sat, Oct 11, 2014 at 07:20:49AM -0700, Greg Kroah-Hartman wrote:
> > > On Sat, Oct 11, 2014 at 03:49:43PM +0200, Philip Munksgaard wrote:
> > > > Fix a style issue
> > > >
> > > > Signed-off-by: Philip Munksgaard <pmunksgaard@gmail.com>
> > > > ---
> > > >  drivers/usb/serial/option.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> > > > index d1a3f60..d88998d 100644
> > > > --- a/drivers/usb/serial/option.c
> > > > +++ b/drivers/usb/serial/option.c
> > > > @@ -1616,7 +1616,7 @@ static const struct usb_device_id option_ids[] = {
> > > >  	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
> > > >  	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
> > > >    	  .driver_info = (kernel_ulong_t)&four_g_w14_blacklist
> > > > -  	},
> > > > +	},
> > >
> > > Why not fix the same 'space' issue on the line before this at the same
> > > time?
> >
> > And what about the remaining white-space issues in this file? Do we
> > really want to go down this path?
> 
> No, we don't, if you want to have patches be able to apply properly to
> older kernels, as you point out.

git-apply --ignore-whitespace ?

-- 
Paul

