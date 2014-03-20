Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837AbaCTPCO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:02:14 -0400
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:19309
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758578AbaCTPCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:02:12 -0400
From: "suresh.gupta@freescale.com" <suresh.gupta@freescale.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Thread-Topic: [PATCH] usb: gadget: fsl: Add FSL USB Gadget entry in platform
 device id
Thread-Index: AQHPPpdRgmsBtN4byECY9YgUxW/lcprfJAUAgAHdeiCAAGBZgIAGzXhAgAB6fgCAAXMLkA==
Date: Thu, 20 Mar 2014 15:01:56 +0000
Message-ID: <8e9307819fbe4cb589a2b58ac8296230@BN1PR03MB251.namprd03.prod.outlook.com>
References: <1394719531-27062-1-git-send-email-suresh.gupta@freescale.com>
 <20140313152628.GI4599@saruman.home>
 <71f42b215c58414d8bfa7efb968dadbf@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140315014015.GD31520@saruman.home>
 <bb1e5245113c424abd45e6dad2d0cba4@BN1PR03MB251.namprd03.prod.outlook.com>
 <20140319165138.GC27142@kroah.com>
In-Reply-To: <20140319165138.GC27142@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.169.1]
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(51704005)(501624003)(77096001)(76786001)(76796001)(76576001)(46102001)(51856001)(74876001)(66066001)(80022001)(65816001)(79102001)(77982001)(59766001)(20776003)(63696002)(81342001)(95416001)(94316002)(85306002)(94946001)(74706001)(76482001)(69226001)(54316002)(93516002)(56776001)(53806001)(54356001)(33646001)(81542001)(86362001)(92566001)(83072002)(85852003)(49866001)(47736001)(81686001)(74366001)(4396001)(81816001)(93136001)(47976001)(50986001)(56816005)(90146001)(2656002)(97186001)(97336001)(87266001)(95666003)(87936001)(74316001)(80976001)(83322001)(47446002)(74662001)(74502001)(31966008)(24736002)(217873001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1PR03MB252;H:BN1PR03MB251.namprd03.prod.outlook.com;FPR:FF44F29D.17325C21.30E7AB30.4CE0FA61.20275;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > @@ -2654,6 +2654,8 @@ static const struct platform_device_id
> > > fsl_udc_devtype[] = {
> > > > >  	}, {
> > > > >  		.name = "imx-udc-mx51",
> > > > >  	}, {
> > > > > +		.name = "fsl-usb2-udc",
> > > >
> > > > why aren't you just using chipidea ?
> > > > [SuresH] This is our legacy driver for all previous and existing
> > > > ppc socs. Many of our customers are already using this, and we
> > > > need to support them on this driver. We do have plans to shift to
> > > > chipidea, but after some time.
> > >
> > > cool, you already have plans, so we will see a new glue layer for
> > > v3.16 right ? Which means I don't need to take this patch either.
> > >
> > we do have plans, but in remote future. Right now, we need to support
> > customers on the present legacy driver. We'll phase out this driver
> > slowly when we integrate chipidea. At this time I would request you to
> > please accept this patch
> 
> Even if Felipe takes the patch, I'll reject it as you should be doing the
> correct thing here, and if it's accepted, it will never be changed...

Hi Greg, I agree that moving to the chipidea driver is the right thing to do.
However, does this mean that companies have to phase out their current legacy 
drivers as soon as a new controller specific driver is introduced in kernel ??
Can't they decide their own schedule based on their own requirements. Our only 
concern is to keep supporting our customers till we move to the new driver. 
I would really appreciate if you could accept this as this would give us 
some time to move to chipidea driver.
