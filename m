Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaB0DaJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:30:09 -0500
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:5930
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751700AbaB0DaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:30:07 -0500
From: Peter Chen <Peter.Chen@freescale.com>
To: "balbi@ti.com" <balbi@ti.com>
CC: Neil Zhang <zhangwm@marvell.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: RE: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Topic: [PATCH 2/6] usb: gadget: mv_udc: disable HW zlt for ep0
Thread-Index: AQHPMTdfHn6q0sLFtkmQnfSG9aPWEJrFsrSA//+qwwCAABEV4IAAIBBQgAAJuqCAAK+LAIAAf1OAgAAMJcCAANenAIAAyosw
Date: Thu, 27 Feb 2014 03:30:03 +0000
Message-ID: <85ec4eb2fddf48bfa281928393b0c992@BL2PR03MB226.namprd03.prod.outlook.com>
References: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
 <1393228996-14787-3-git-send-email-zhangwm@marvell.com>
 <20140225011839.GD7540@shlinux1.ap.freescale.net>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413563@SC-VEXCH4.marvell.com>
 <6ad74d797ecc473f922ffdb58c3e9c70@BN1PR03MB235.namprd03.prod.outlook.com>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC4135A5@SC-VEXCH4.marvell.com>
 <bce87beb86d34377ac3dae0645622edf@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140225181234.GF23275@saruman.home>
 <175CCF5F49938B4D99B2E3EF7F558EBE54EC413885@SC-VEXCH4.marvell.com>
 <c3b92dae0fe54efc85b886899ddf60ab@BN1PR03MB235.namprd03.prod.outlook.com>
 <20140226152336.GI30028@saruman.home>
In-Reply-To: <20140226152336.GI30028@saruman.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [123.151.195.50]
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(428001)(51704005)(199002)(189002)(86362001)(74366001)(76796001)(93516002)(59766001)(49866001)(79102001)(81342001)(93136001)(54316002)(77096001)(47976001)(76576001)(76786001)(63696002)(53806001)(54356001)(46102001)(76482001)(95416001)(51856001)(81542001)(4396001)(69226001)(74876001)(94316002)(83322001)(80976001)(74662001)(81686001)(81816001)(33646001)(74502001)(85852003)(56776001)(85306002)(83072002)(74706001)(50986001)(56816005)(87266001)(47736001)(94946001)(47446002)(92566001)(74316001)(87936001)(31966008)(2656002)(90146001)(80022001)(66066001)(65816001)(95666003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB401;H:BL2PR03MB226.namprd03.prod.outlook.com;CLIP:123.151.195.50;FPR:EE44C0DF.9B065586.3D5A7B1.C6E24368.20197;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> > > > >
> > > > > Chipidea bug too? Does it follow ch 8.5.3.2 Variable-length Data
> > > > > Stage, USB
> > > > 2.0 spec?
> > > >
> > > > wait, this is a chipidea core ? Why aren't you guys using the
> > > > chipidea driver yet ? You need to switch over to that driver dude,
> > > > we can't have duplicated code in the tree.
> > > >
> > > > I'm sorry, but I won't be taking this series, please use chipidea
> > > > driver, it should be very simple to add a glue layer for your core
> > > > to
> > > the chipidea driver.
> > > >
> > >
> > > Yes, it use chipidea IP.
> > > But the driver is earlier than the chipidea one and we use it for
> > > our products.
> > > So it may be not that easy to switch to chipidea driver due to the
> > > stability.
> > >
> >
> > Freescale i.mx SoC used fsl_udc_core.c before which was the one of the
> 
> btw, when can I remove fsl_udc_core.c from the tree ?
> 

Freescale has other processor group (PowerPC, etc) has used this code now.

Peter
