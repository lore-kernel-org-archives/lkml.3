Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaBZCgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 21:36:25 -0500
Received: from mail-by2lp0237.outbound.protection.outlook.com ([207.46.163.237]:3677
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751163AbaBZCgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 21:36:23 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: Neil Zhang <zhangwm@marvell.com>, "balbi@ti.com" <balbi@ti.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Alexander Shishkin" <alexander.shishkin@linux.intel.com>
Subject: RE: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Topic: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Index: AQHPMTdfHn6q0sLFtkmQnfSG9aPWEJrFsrSA//+qwwCAABEV4IAAIBBQgAAJuqCAAK+LAIAAf1OAgAAMJcA=
Date: Wed, 26 Feb 2014 02:36:19 +0000
Message-ID: <c3b92dae0fe54efc85b886899ddf60ab@BN1PR03MB235.namprd03.prod.outlook.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
 <20140225011839.GD7540@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
 <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
 <bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140225181234.GF23275@saruman.home>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
In-Reply-To: <175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51704005)(199002)(189002)(92566001)(93516002)(81342001)(83322001)(86362001)(81542001)(74706001)(94316002)(80976001)(87936001)(33646001)(74876001)(83072002)(87266001)(4396001)(47736001)(2656002)(47976001)(85852003)(49866001)(76796001)(77096001)(90146001)(76786001)(85306002)(76576001)(76482001)(50986001)(93136001)(69226001)(51856001)(74662001)(81816001)(59766001)(56816005)(54356001)(95666003)(95416001)(77982001)(74366001)(80022001)(56776001)(31966008)(63696002)(94946001)(47446002)(66066001)(81686001)(79102001)(46102001)(54316002)(74316001)(74502001)(53806001)(65816001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB419;H:BN1PR03MB235.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:AEC4C0DF.9F06558A.3DDA7B1.C6E24D60.20185;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > > > easy to be found.
> > > >
> > >
> > > Chipidea bug too? Does it follow ch 8.5.3.2 Variable-length Data
> > > Stage, USB
> > 2.0 spec?
> >
> > wait, this is a chipidea core ? Why aren't you guys using the chipidea
> > driver yet ? You need to switch over to that driver dude, we can't
> > have duplicated code in the tree.
> >
> > I'm sorry, but I won't be taking this series, please use chipidea
> > driver, it should be very simple to add a glue layer for your core to
> the chipidea driver.
> >
> 
> Yes, it use chipidea IP.
> But the driver is earlier than the chipidea one and we use it for our
> products.
> So it may be not that easy to switch to chipidea driver due to the
> stability.
> 

Freescale i.mx SoC used fsl_udc_core.c before which was the one of the
oldest chipidea drivers, now, all i.mx SoC uses chipidea driver including
old hardware.

Peter
