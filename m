Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756952AbaCTFn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 01:43:56 -0400
Received: from mail-bn1blp0184.outbound.protection.outlook.com ([207.46.163.184]:20154
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750854AbaCTFny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 01:43:54 -0400
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Thread-Topic: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Thread-Index: AQHPPpdRgmsBtN4byECY9YgUxW/lcprfJAUAgAHdeiCAAGBZgIAGzXhAgAB6fgCAABOuYIAAw61g
Date: Thu, 20 Mar 2014 05:43:51 +0000
Message-ID: <d8e3ca39d71045aeaef97c9a348de4d6@BN1PR03MB251.namprd03.prod.outlook.com>
References: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152628.GI4599@saruman.home>
 <71f42b215c58414d8bfa7efb968dadbf@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140315014015.GD31520@saruman.home>
 <bb1e5245113c424abd45e6dad2d0cba4@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140319165138.GC27142@kroah.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(189002)(199002)(377454003)(51704005)(13464003)(24454002)(52604005)(47736001)(49866001)(94946001)(47446002)(47976001)(76576001)(50986001)(65816001)(76786001)(92566001)(81342001)(74876001)(79102001)(31966008)(74316001)(19580405001)(87936001)(83072002)(93136001)(94316002)(19580395003)(95416001)(33646001)(74662001)(66066001)(85852003)(80022001)(83322001)(74366001)(76796001)(4396001)(81542001)(81816001)(63696002)(20776003)(97336001)(81686001)(87266001)(56816005)(2656002)(90146001)(85306002)(86362001)(54316002)(69226001)(80976001)(56776001)(46102001)(77096001)(74502001)(93516002)(95666003)(97186001)(51856001)(74706001)(76482001)(53806001)(77982001)(59766001)(54356001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB251;H:BN1PR03MB251.namprd03.prod.outlook.com;FPR:275CF15D.A7329C29.E75F63.4158FA79.20377;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ignore last mail, was not intended for you. 

> -----Original Message-----
> From: Gupta Suresh-B42813
> Sent: Wednesday, March 19, 2014 11:33 PM
> To: 'gregkh@linuxfoundation.org'
> Cc: balbi@ti.com; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in
> platform device id
> 
> Hi Ramneek,
> 
> Do you understand, what Greg want to communicate.
> 
> 
> Thanks
> SuresH
> 
> > -----Original Message-----
> > From: gregkh@linuxfoundation.org [mailto:gregkh@linuxfoundation.org]
> > Sent: Wednesday, March 19, 2014 10:22 PM
> > To: Gupta Suresh-B42813
> > Cc: balbi@ti.com; linux-usb@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in
> > platform device id
> >
> > On Wed, Mar 19, 2014 at 02:25:25PM +0000, suresh.gupta@freescale.com
> > wrote:
> > > Hi
> > >
> > > > -----Original Message-----
> > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > Sent: Saturday, March 15, 2014 7:10 AM
> > > > To: Gupta Suresh-B42813
> > > > Cc: balbi@ti.com; gregkh@linuxfoundation.org;
> > > > linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in
> > > > platform device id
> > > >
> > > > On Fri, Mar 14, 2014 at 08:52:19PM +0000,
> > > > suresh.gupta@freescale.com
> > > > wrote:
> > > > > Hi,
> > > > > Thanks for reviewing my patches.
> > > > > Please find my comments inline
> > > > >
> > > > > -----Original Message-----
> > > > > From: Felipe Balbi [mailto:balbi@ti.com]
> > > > > Sent: Thursday, March 13, 2014 8:56 PM
> > > > > To: Gupta Suresh-B42813
> > > > > Cc: balbi@ti.com; gregkh@linuxfoundation.org;
> > > > > linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Gupta
> > > > > Suresh-B42813
> > > > > Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry
> > > > > in platform device id
> > > > >
> > > > > On Thu, Mar 13, 2014 at 07:35:31PM +0530, Suresh Gupta wrote:
> > > > > > From: Suresh Gupta <B42813@freescale.com>
> > > > > >
> > > > > > 	Add FSL USB Gadget entry in platform device id table
> > > > >
> > > > > why this tab ?
> > > > > [SuresH] I will remove it in next version.
> > > > >
> > > > > > Signed-off-by: Suresh Gupta <B42813@freescale.com>
> > > > > > ---
> > > > > >  drivers/usb/gadget/fsl_udc_core.c | 2 ++
> > > > > >  1 file changed, 2 insertions(+)
> > > > > >
> > > > > > diff --git a/drivers/usb/gadget/fsl_udc_core.c
> > > > > > b/drivers/usb/gadget/fsl_udc_core.c
> > > > > > index b7dea4e..35b20e6 100644
> > > > > > --- a/drivers/usb/gadget/fsl_udc_core.c
> > > > > > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > > > > > @@ -2654,6 +2654,8 @@ static const struct platform_device_id
> > > > fsl_udc_devtype[] = {
> > > > > >  	}, {
> > > > > >  		.name = "imx-udc-mx51",
> > > > > >  	}, {
> > > > > > +		.name = "fsl-usb2-udc",
> > > > >
> > > > > why aren't you just using chipidea ?
> > > > > [SuresH] This is our legacy driver for all previous and existing
> > > > > ppc socs. Many of our customers are already using this, and we
> > > > > need to support them on this driver. We do have plans to shift
> > > > > to chipidea, but after some time.
> > > >
> > > > cool, you already have plans, so we will see a new glue layer for
> > > > v3.16 right ? Which means I don't need to take this patch either.
> > > >
> > > we do have plans, but in remote future. Right now, we need to
> > > support customers on the present legacy driver. We'll phase out this
> > > driver slowly when we integrate chipidea. At this time I would
> > > request you to please accept this patch
> >
> > Even if Felipe takes the patch, I'll reject it as you should be doing
> > the correct thing here, and if it's accepted, it will never be
> changed...
> >
> > greg k-h
> >

