Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab3C2LLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 07:11:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab3C2LLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 07:11:20 -0400
Date: Fri, 29 Mar 2013 08:11:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] gspca: remove obsolete Kconfig macros
Message-ID: <20130329081115.30d82656@redhat.com>
In-Reply-To: <51555598.1040505@redhat.com>
References: <1364506437.1345.42.camel@x61.thuisdomein>
	<51555598.1040505@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 29 Mar 2013 09:49:28 +0100
Hans de Goede <hdegoede@redhat.com> escreveu:

> Mauro,
> 
> Can you pick this one up? I don't have anything pending for gspca,
> and to create a tree + pullreq for just a trivial patch is not really
> efficient.

No problem. I'll handle that.

Regards,
Mauro
> Alternatively I can put it on my TODO for when there is more gspca work,
> esp. since there is not really a need to hurry with merging this.
> 
> Regards,
> 
> Hans
> 
> 
> On 03/28/2013 10:33 PM, Paul Bolle wrote:
> > The et61x251 driver was removed in v3.5. Remove the last references to
> > its Kconfig macro now.
> >
> > Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> > ---
> > Untested, as usual.
> >
> >   drivers/media/usb/gspca/etoms.c | 2 --
> >   1 file changed, 2 deletions(-)
> >
> > diff --git a/drivers/media/usb/gspca/etoms.c b/drivers/media/usb/gspca/etoms.c
> > index 38f68e1..f165581 100644
> > --- a/drivers/media/usb/gspca/etoms.c
> > +++ b/drivers/media/usb/gspca/etoms.c
> > @@ -768,9 +768,7 @@ static const struct sd_desc sd_desc = {
> >   /* -- module initialisation -- */
> >   static const struct usb_device_id device_table[] = {
> >   	{USB_DEVICE(0x102c, 0x6151), .driver_info = SENSOR_PAS106},
> > -#if !defined CONFIG_USB_ET61X251 && !defined CONFIG_USB_ET61X251_MODULE
> >   	{USB_DEVICE(0x102c, 0x6251), .driver_info = SENSOR_TAS5130CXX},
> > -#endif
> >   	{}
> >   };
> >
> >


-- 

Cheers,
Mauro
