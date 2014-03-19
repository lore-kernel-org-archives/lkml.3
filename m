Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965430AbaCSQtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:49:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43667 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965238AbaCSQti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:49:38 -0400
Date: Wed, 19 Mar 2014 09:51:38 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Message-ID: <20140319165138.GC27142@kroah.com>
References: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152628.GI4599@saruman.home>
 <71f42b215c58414d8bfa7efb968dadbf@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140315014015.GD31520@saruman.home>
 <bb1e5245113c424abd45e6dad2d0cba4@BN1PR03MB251.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb1e5245113c424abd45e6dad2d0cba4@BN1PR03MB251.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 02:25:25PM +0000, suresh.gupta@freescale.com wrote:
> Hi
> 
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Saturday, March 15, 2014 7:10 AM
> > To: Gupta Suresh-B42813
> > Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in
> > platform device id
> > 
> > On Fri, Mar 14, 2014 at 08:52:19PM +0000, suresh.gupta@freescale.com
> > wrote:
> > > Hi,
> > > Thanks for reviewing my patches.
> > > Please find my comments inline
> > >
> > > -----Original Message-----
> > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > Sent: Thursday, March 13, 2014 8:56 PM
> > > To: Gupta Suresh-B42813
> > > Cc: balbi@ti.com; gregkh@linuxfoundation.org;
> > > linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Gupta
> > > Suresh-B42813
> > > Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in
> > > platform device id
> > >
> > > On Thu, Mar 13, 2014 at 07:35:31PM +0530, Suresh Gupta wrote:
> > > > From: Suresh Gupta <B42813@freescale.com>
> > > >
> > > > 	Add FSL USB Gadget entry in platform device id table
> > >
> > > why this tab ?
> > > [SuresH] I will remove it in next version.
> > >
> > > > Signed-off-by: Suresh Gupta <B42813@freescale.com>
> > > > ---
> > > >  drivers/usb/gadget/fsl_udc_core.c | 2 ++
> > > >  1 file changed, 2 insertions(+)
> > > >
> > > > diff --git a/drivers/usb/gadget/fsl_udc_core.c
> > > > b/drivers/usb/gadget/fsl_udc_core.c
> > > > index b7dea4e..35b20e6 100644
> > > > --- a/drivers/usb/gadget/fsl_udc_core.c
> > > > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > > > @@ -2654,6 +2654,8 @@ static const struct platform_device_id
> > fsl_udc_devtype[] = {
> > > >  	}, {
> > > >  		.name = "imx-udc-mx51",
> > > >  	}, {
> > > > +		.name = "fsl-usb2-udc",
> > >
> > > why aren't you just using chipidea ?
> > > [SuresH] This is our legacy driver for all previous and existing ppc
> > > socs. Many of our customers are already using this, and we need to
> > > support them on this driver. We do have plans to shift to chipidea,
> > > but after some time.
> > 
> > cool, you already have plans, so we will see a new glue layer for v3.16
> > right ? Which means I don't need to take this patch either.
> > 
> we do have plans, but in remote future. Right now, we need to support
> customers on the present legacy driver. We'll phase out this driver 
> slowly when we integrate chipidea. At this time I would request you 
> to please accept this patch

Even if Felipe takes the patch, I'll reject it as you should be doing
the correct thing here, and if it's accepted, it will never be
changed...

greg k-h
