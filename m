Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965367AbaCSOZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 10:25:42 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:39120
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965087AbaCSOZk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 10:25:40 -0400
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Thread-Topic: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Thread-Index: AQHPPpdRgmsBtN4byECY9YgUxW/lcprfJAUAgAHdeiCAAGBZgIAGzXhA
Date: Wed, 19 Mar 2014 14:25:25 +0000
Message-ID: <bb1e5245113c424abd45e6dad2d0cba4@BN1PR03MB251.namprd03.prod.outlook.com>
References: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152628.GI4599@saruman.home>
 <71f42b215c58414d8bfa7efb968dadbf@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140315014015.GD31520@saruman.home>
In-Reply-To: <20140315014015.GD31520@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 01559F388D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(13464003)(51704005)(52604005)(377454003)(199002)(189002)(24454002)(81542001)(85852003)(33646001)(83072002)(56816005)(97336001)(81686001)(51856001)(95666003)(54356001)(81816001)(53806001)(97186001)(59766001)(77982001)(77096001)(63696002)(65816001)(20776003)(80022001)(93136001)(79102001)(92566001)(66066001)(76786001)(76796001)(50986001)(49866001)(47736001)(90146001)(4396001)(76576001)(46102001)(47976001)(85306002)(95416001)(74876001)(74706001)(74316001)(74366001)(86362001)(87936001)(93516002)(87266001)(69226001)(94946001)(94316002)(80976001)(76482001)(19580395003)(2656002)(81342001)(83322001)(74662001)(31966008)(74502001)(47446002)(54316002)(56776001)(19580405001)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB250;H:BN1PR03MB251.namprd03.prod.outlook.com;FPR:375CF15D.17309CE9.1E77B60.515CFA79.202EA;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> -----Original Message-----
> From: Felipe Balbi [mailto:balbi@ti.com]
> Sent: Saturday, March 15, 2014 7:10 AM
> To: Gupta Suresh-B42813
> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in
> platform device id
> 
> On Fri, Mar 14, 2014 at 08:52:19PM +0000, suresh.gupta@freescale.com
> wrote:
> > Hi,
> > Thanks for reviewing my patches.
> > Please find my comments inline
> >
> > -----Original Message-----
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Thursday, March 13, 2014 8:56 PM
> > To: Gupta Suresh-B42813
> > Cc: balbi@ti.com; gregkh@linuxfoundation.org;
> > linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; Gupta
> > Suresh-B42813
> > Subject: Re: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in
> > platform device id
> >
> > On Thu, Mar 13, 2014 at 07:35:31PM +0530, Suresh Gupta wrote:
> > > From: Suresh Gupta <B42813@freescale.com>
> > >
> > > 	Add FSL USB Gadget entry in platform device id table
> >
> > why this tab ?
> > [SuresH] I will remove it in next version.
> >
> > > Signed-off-by: Suresh Gupta <B42813@freescale.com>
> > > ---
> > >  drivers/usb/gadget/fsl_udc_core.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/drivers/usb/gadget/fsl_udc_core.c
> > > b/drivers/usb/gadget/fsl_udc_core.c
> > > index b7dea4e..35b20e6 100644
> > > --- a/drivers/usb/gadget/fsl_udc_core.c
> > > +++ b/drivers/usb/gadget/fsl_udc_core.c
> > > @@ -2654,6 +2654,8 @@ static const struct platform_device_id
> fsl_udc_devtype[] = {
> > >  	}, {
> > >  		.name = "imx-udc-mx51",
> > >  	}, {
> > > +		.name = "fsl-usb2-udc",
> >
> > why aren't you just using chipidea ?
> > [SuresH] This is our legacy driver for all previous and existing ppc
> > socs. Many of our customers are already using this, and we need to
> > support them on this driver. We do have plans to shift to chipidea,
> > but after some time.
> 
> cool, you already have plans, so we will see a new glue layer for v3.16
> right ? Which means I don't need to take this patch either.
> 
we do have plans, but in remote future. Right now, we need to support
customers on the present legacy driver. We'll phase out this driver 
slowly when we integrate chipidea. At this time I would request you 
to please accept this patch

---
Thanks
SuresH
